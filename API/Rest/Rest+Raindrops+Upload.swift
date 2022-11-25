import Foundation

//MARK: - Create raindrop
extension Rest {
    public func raindropUploadFile(file: URL, collection: Int? = nil) async throws -> Raindrop {
        var formData = FormData()
        formData.append(key: "file", value: file)
        
        if let collection {
            formData.append(key: "collectionId", value: collection)
        }
        
        let res: ItemResponse<Raindrop> = try await fetch.put(
            "raindrop/file",
            formData: formData
        )
        return res.item
    }
}
