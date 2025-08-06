import Foundation
import UIKit

struct CodableImage: Codable {
    let image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case image
    }
    
    init(image: UIImage) {
        self.image = image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        guard let image = UIImage(data: data) else {
            throw PersistencyError.encodingFailed
        }
        
        self.image = image
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let resolvedImage = image else {
            throw PersistencyError.encodingFailed
        }
        guard let data = resolvedImage.pngData() else {
            throw PersistencyError.encodingFailed
        }
        
        try container.encode(data, forKey: CodingKeys.image)
    }
}
