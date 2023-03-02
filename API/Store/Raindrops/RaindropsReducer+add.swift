import SwiftUI

extension RaindropsReducer {
    func add(state: inout S, urls: Set<URL>, collection: Int?, completed: Binding<Set<URL>>?, failed: Binding<Set<URL>>?) async throws -> ReduxAction? {
        //nothing to add
        guard !urls.isEmpty
        else { return nil }
        
        await links(state: &state)
        
        var newRaindrops = [Raindrop]()
        
        let chunks = urls
            //ignore existing
            .filter { url in
                if state.lookups[url.compact] != nil {
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
                                var item = try? await self.rest.importUrlParse(url)
                                if item == nil {
                                    item = .new(link: url)
                                }
                                if let collection {
                                    item?.collection = collection
                                }
                                raindrop = try await self.rest.raindropCreate(raindrop: item!)
                            }
                            
                            completed?.wrappedValue.insert(url)
                            return raindrop
                        } catch {
                            print(error)
                            failed?.wrappedValue.insert(url)
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
