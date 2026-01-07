import SwiftUI

extension RaindropsReducer {
    func add(state: S, urls: Set<URL>, collection: Int?, completed: Binding<Set<URL>>?, failed: Binding<[URL: RestError]>?) async throws -> ReduxAction? {
        //nothing to add
        guard !urls.isEmpty
        else { return nil }
        
        var newRaindrops = [Raindrop]()
        
        //check existing
        var existing = [URL: Raindrop.ID]()
        do {
            existing = try await rest.raindropsGetId(urls: urls)
        } catch {
            let restError = (error as? RestError) ?? .unknown(error.localizedDescription)
            for url in urls {
                failed?.wrappedValue[url] = restError
            }
            throw error
        }
        
        let chunks = urls
            //ignore existing
            .filter { url in
                if existing[url.compact] != nil {
                    completed?.wrappedValue.insert(url)
                    return false
                }
                return true
            }
            //ignore completed
            .filter { !(completed?.wrappedValue ?? []).contains($0) }
            //split to parallel tasks
            .chunked(into: 10)
        
        for chunk in chunks {
            newRaindrops += await withTaskGroup(of: Raindrop?.self) { [self] group in
                for url in chunk {
                    group.addTask {
                        do {
                            var raindrop: Raindrop
                            
                            //file
                            if url.isFileURL {
                                raindrop = try await self.rest.raindropUploadFile(
                                    file: url,
                                    collection: collection
                                )
                            }
                            //web url
                            else {
                                var item = Raindrop.new(link: url)
                                if let collection {
                                    item.collection = collection
                                }
                                raindrop = try await self.rest.raindropCreate(raindrop: item)
                            }
                            
                            completed?.wrappedValue.insert(url)
                            return raindrop
                        } catch {
                            print(error, url)
                            failed?.wrappedValue[url] = (error as? RestError) ?? .unknown(error.localizedDescription)
                            return nil
                        }
                    }
                }
                
                var raindrops = [Raindrop]()
                for await raindrop in group {
                    if let raindrop {
                        raindrops.append(raindrop)
                    }
                }
                
                return raindrops
            }
        }
        
        //can't add anything
        guard !newRaindrops.isEmpty
        else { throw RestError.invalid("cant add") }
        
        return A.createdMany(newRaindrops)
    }
}
