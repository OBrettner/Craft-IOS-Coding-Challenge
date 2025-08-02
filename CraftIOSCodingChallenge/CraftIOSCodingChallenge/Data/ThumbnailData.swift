import Foundation
import UIKit

struct ThumbnailData: Codable {
    let userName: String
    let fontName: String
    let backgroundColor: CodableColor
    let imageData: CodableImage?
    
    var hasImage: Bool {
        imageData != nil
    }
}

class Thumbnail: Persistent {
    var savedFilePath = URL.documentsDirectory.appending(path:"CraftIOSCodingChallengeData")
    var codableData: ThumbnailData
    
    required init(data: ThumbnailData) {
        self.codableData = data
    }
    
    func updateData(thumbnailData: ThumbnailData) throws {
        self.codableData = thumbnailData
        try save()
    }
}
