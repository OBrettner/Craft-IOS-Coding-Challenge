import Foundation
import UIKit

extension UIFontDescriptor.SystemDesign: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = UIFontDescriptor.SystemDesign(rawValue: rawValue)
    }
}

struct ThumbnailData: Codable {
    let userName: String
    let fontDesign: UIFontDescriptor.SystemDesign
    let backgroundColor: CodableColor
    let imageData: CodableImage?
    
    var hasImage: Bool {
        imageData != nil
    }
    
    static var defaultThumbnailData = ThumbnailData(
        userName: "Brettner Oliver",
        fontDesign: .default,
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
