import SwiftUI

extension RaindropsReducer {
    func uploadFiles(state: inout S, files: [URL], collection: Int?, completed: Binding<Set<URL>>?, failed: Binding<Set<URL>>?) async throws -> ReduxAction? {
        //nothing to upload
        guard !files.isEmpty
        else { return nil }
        
        var newRaindrops = [Raindrop]()

        let chunks = files
            .filter { !(completed?.wrappedValue ?? []).contains($0) }
            .chunked(into: 10)
        
        for chunk in chunks {
            newRaindrops += await withTaskGroup(of: Raindrop?.self) { [self] group in
                for file in chunk {
                    group.addTask {
                        do {
                            let raindrop = try await self.rest.raindropUploadFile(
                                file: file,
                                collection: collection
                            )
                            completed?.wrappedValue.insert(file)
                            return raindrop
                        } catch {
                            failed?.wrappedValue.insert(file)
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
        
        //can't upload anything
        guard !newRaindrops.isEmpty
        else { throw RestError.invalid("cant upload") }
        
        return A.createdMany(newRaindrops)
    }
}
