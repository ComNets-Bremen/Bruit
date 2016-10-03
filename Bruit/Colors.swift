//
//  Colors.swift
//  Bruit
//
//  Created by Asanga Udugama on 05/02/16.
//

import Foundation
import UIKit

class Colors {
    
    // all color values come from the Crayola color combinations at
    // https://en.wikipedia.org/wiki/List_of_Crayola_crayon_colors
    //
//    static let colorRGBValArray: [[Float]] =
//        [[0, 149, 183], [101, 45, 193], [252, 116, 253], [175, 89, 62], [102, 66, 40],
//            
//            
//        [237, 10, 63], [195, 33, 72], [253, 14, 53], [198, 45, 66], [204, 71, 75],
//        [204, 51, 54], [225, 44, 44], [217, 33, 33], [185, 78, 72], [255, 63, 52],
//        [254, 76, 64], [254, 111, 9], [179, 59, 36], [204, 85, 61], [230, 115, 92],
//        [255, 153, 128], [229, 144, 115], [255, 112, 52], [255, 104, 31], [255, 136, 100],
//        [255, 185, 123], [236, 177, 118], [231, 114, 0], [255, 174, 66], [242, 186, 73],
//        [251, 231, 178], [242, 198, 73], [248, 213, 104], [252, 214, 103], [254, 216, 93],
//        [252, 232, 131],
//            
//        [233, 116, 81], [140, 144, 200], [172, 172, 230.0], [214, 174, 221],
//        [235, 176, 215], [222, 166, 1239], [217, 154, 108], [255, 203, 164],
//        [254, 111, 94], [195, 205, 230], [147, 223, 184]]
    

    static let colorRGBValArray: [[Float]] =
[[251, 231, 178], [248, 213, 104], [252, 214, 103], [252, 232, 131], [241, 231, 136 ], [236, 235, 189], [255, 255, 153], [217, 230, 80], [190, 230, 75], [197, 225, 122], [147, 223, 184], [143, 216, 216], [149, 224, 232], [118, 215, 234], [126, 212, 230], [147, 204, 234], [169, 178, 195], [195, 205, 230], [141, 144, 161], [191, 143, 204], [214, 174, 221], [235, 176, 215], [251, 174, 210], [255, 183, 213], [253, 215, 228], [254, 186, 173], [237, 201, 175], [255, 203, 164], [238, 217, 196], [217, 214, 207], [201, 192, 187]]
    
    
//    static let viewBackgroundColor: UIColor =
//        UIColor(colorLiteralRed: 197/255, green: 225/255, blue: 122/255, alpha: 1)
    static let viewBackgroundColor: UIColor =
        UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 200/255, alpha: 1)
    
    static let addButtonBackgroundColor: UIColor =
        UIColor(colorLiteralRed: 190.0/255.0, green: 230.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    
    static let showNeighboursButtonBackgroundColor: UIColor =
        UIColor(colorLiteralRed: 147.0/255.0, green: 204.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    
    static let tableBorderColor: UIColor =
        UIColor(colorLiteralRed: 236/255.0, green: 235/255.0, blue: 189/255.0, alpha: 1.0)
    
    static let testColor: UIColor =
        UIColor(colorLiteralRed: 45/255.0, green: 56/255.0, blue: 58/255.0, alpha: 1.0)
    
    static let bruitLogoTextColorRGBValArray: [[Float]] =
        [[0, 102, 255], [90, 140, 49], [253, 14, 53], [175, 89, 62], [230, 188, 40], [214, 174, 221]]

    static let addBruitItemViewBackgroundColor: UIColor =
        UIColor(colorLiteralRed: 157/255, green: 224/255, blue: 147/255, alpha: 1.0)

    static let addItemButtonBackgroundColor: UIColor =
        UIColor(colorLiteralRed: 190/255, green: 230/255, blue: 75/255, alpha: 1.0)
    static let cancelButtonBackgroundColor: UIColor =
        UIColor(colorLiteralRed: 255/255, green: 63/255, blue: 52/255, alpha: 1.0)
    
    static let showNeighboursViewBackgroundColor: UIColor =
        UIColor(colorLiteralRed: 157/255, green: 224/255, blue: 147/255, alpha: 1.0)
 
    static let okButtonBackgroundColor: UIColor =
        UIColor(colorLiteralRed: 147.0/255.0, green: 204.0/255.0, blue: 234.0/255.0, alpha: 1.0)

    
    
    class func getRandomItemEntryBackgroundColor() -> UIColor {
        let randomIndex = Int(arc4random_uniform(UInt32(colorRGBValArray.count)))
        let rbgArray: [Float] = colorRGBValArray[randomIndex]
        
        return UIColor(colorLiteralRed: rbgArray[0]/255, green: rbgArray[1]/255, blue: rbgArray[2]/255, alpha: 1.0)
    }

    class func getColorByIndex(_ index: Int) -> UIColor {
        let rbgArray: [Float] = colorRGBValArray[index]
        return UIColor(colorLiteralRed: rbgArray[0]/255, green: rbgArray[1]/255, blue: rbgArray[2]/255, alpha: 1.0)
    }
    
    class func getBruitTextColorByIndex(_ index: Int) -> UIColor {
        let rbgArray: [Float] = bruitLogoTextColorRGBValArray[index]
        return UIColor(colorLiteralRed: rbgArray[0]/255.0, green: rbgArray[1]/255.0, blue: rbgArray[2]/255.0, alpha: 1.0)
    }
    
        
}
