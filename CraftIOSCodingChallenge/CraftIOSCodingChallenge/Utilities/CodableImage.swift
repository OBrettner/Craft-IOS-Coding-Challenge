import Foundation
import UIKit

struct CodableImage: Codable {
    private let dataPath: String
    private let width: Int
    private let height: Int
    private let bitsPerComponent: Int
    private let bitsPerPixel: Int
    private let bytesPerRow: Int
    private let colorSpaceName: String
    
    enum CodingKeys: String, CodingKey {
        case dataPath, width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceName
    }

    init?(image: UIImage) {
        guard let cgImage = image.cgImage,
              let data = cgImage.dataProvider?.data as? Data,
              let colorSpace = cgImage.colorSpace,
              let colorSpaceName = colorSpace.name else { return nil }
        
        self.width = cgImage.width
        self.height = cgImage.height
        self.bitsPerComponent = cgImage.bitsPerComponent
        self.bitsPerPixel = cgImage.bitsPerPixel
        self.bytesPerRow = cgImage.bytesPerRow
        self.colorSpaceName = colorSpaceName as String
        
        let fileName = UUID().uuidString
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            self.dataPath = fileName
        } catch {
            print("Error saving raw image data: \(error)")
            return nil
        }
    }

    var image: UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent(dataPath)
        
        if let rawData = try? Data(contentsOf: fileURL) as CFData {
            let provider = CGDataProvider(data: rawData)
            
            guard let colorSpace = CGColorSpace(name: colorSpaceName as CFString) else { return nil }
            
            let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
            
            if let cgImage = CGImage(
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bitsPerPixel: bitsPerPixel,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo,
                provider: provider!,
                decode: nil,
                shouldInterpolate: true,
                intent: .defaultIntent
            ) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dataPath = try container.decode(String.self, forKey: .dataPath)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.bitsPerComponent = try container.decode(Int.self, forKey: .bitsPerComponent)
        self.bitsPerPixel = try container.decode(Int.self, forKey: .bitsPerPixel)
        self.bytesPerRow = try container.decode(Int.self, forKey: .bytesPerRow)
        self.colorSpaceName = try container.decode(String.self, forKey: .colorSpaceName)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dataPath, forKey: .dataPath)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(bitsPerComponent, forKey: .bitsPerComponent)
        try container.encode(bitsPerPixel, forKey: .bitsPerPixel)
        try container.encode(bytesPerRow, forKey: .bytesPerRow)
        try container.encode(colorSpaceName, forKey: .colorSpaceName)
    }
}
