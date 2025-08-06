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
    
    static var defaultThumbnailData = ThumbnailData(
        userName: "Brettner Oliver",
        fontName: FontTypes.Rounded,
        backgroundColor: CodableColor(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)),
        imageData: nil
    )
}

class Thumbnail: Persistent {
    var savedFilePath = URL.documentsDirectory.appending(path:"CraftIOSCodingChallengeData")
    var codableData: ThumbnailData
    
    required init(data: ThumbnailData) {
        self.codableData = data
    }
    
    func updateData(thumbnailData: ThumbnailData) {
        self.codableData = thumbnailData
        do {
            try save()
        } catch {
            print("Saving Failed")
        }
    }
}
