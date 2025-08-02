import Foundation
import UIKit

struct CodableColor: Codable {
    private var red = CGFloat(0.0)
    private var green = CGFloat(0.0)
    private var blue = CGFloat(0.0)
    private var alpha = CGFloat(0.0)
    
    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}
