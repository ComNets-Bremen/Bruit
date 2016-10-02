//
//  FormFactor.swift
//  Bruit
//
//  Created by Asanga Udugama on 10/02/16.
//  Copyright © 2016 Asanga Udugama. All rights reserved.
//

import Foundation
import UIKit

class FormFactor {
    //static let deviceString = UIDevice().type.rawValue.lowercased()
    //static let deviceString = "ipad"
    static let deviceString = UIDevice.current.model
//    static let deviceString = "iPhone"
    
    class func getAddBruitItemViewFFValues() -> (viewX: CGFloat, viewY: CGFloat, viewWidth: CGFloat, viewHeight: CGFloat, rowHeight: CGFloat, viewCenter: CGFloat, textFieldHeight: CGFloat, textFieldWidth: CGFloat, textFontSize: CGFloat, labelWidth: CGFloat, viewYInvisible: CGFloat) {

        let vcFrameRect: CGRect = UIScreen.main.bounds
        
        // iPad settings
        let viewX: CGFloat = (vcFrameRect.size.width - (vcFrameRect.size.width * 0.75)) / 2
        var viewY: CGFloat = vcFrameRect.size.height * 0.10
        let viewWidth: CGFloat = vcFrameRect.size.width * 0.75
        let viewHeight: CGFloat = vcFrameRect.size.height * 0.60
        let rowHeight: CGFloat = viewHeight / 12
        let viewCenter: CGFloat = viewWidth / 2.0
        let textFieldHeight: CGFloat = rowHeight
        let textFieldWidth: CGFloat = viewWidth - 10.0
        var textFontSize: CGFloat = 32
        let labelWidth: CGFloat = viewWidth - 10.0
        let viewYInvisible: CGFloat = 0 - viewHeight - 20
        
        if deviceString.range(of: "iPhone") != nil {
            viewY = vcFrameRect.size.height * 0.05
            textFontSize = 18
            
        }
        
        return (viewX, viewY, viewWidth, viewHeight, rowHeight,
                viewCenter, textFieldHeight, textFieldWidth,
                textFontSize, labelWidth, viewYInvisible)
    }
    
    class func getShowNeighboursViewFFValues() -> (viewX: CGFloat, viewY: CGFloat, viewWidth: CGFloat, viewHeight: CGFloat, rowHeight: CGFloat, viewCenter: CGFloat, textFieldHeight: CGFloat, textFieldWidth: CGFloat, textFontSize: CGFloat, labelWidth: CGFloat, viewYInvisible: CGFloat) {
        
        let vcFrameRect: CGRect = UIScreen.main.bounds
            
        let viewX: CGFloat = (vcFrameRect.size.width - (vcFrameRect.size.width * 0.75)) / 2
        
        var viewY: CGFloat = vcFrameRect.size.height * 0.10
        let viewWidth: CGFloat = vcFrameRect.size.width * 0.75
        let viewHeight: CGFloat = vcFrameRect.size.height * 0.40
        let rowHeight: CGFloat = viewHeight / 8
        let viewCenter: CGFloat = viewWidth / 2.0
        let textFieldHeight: CGFloat = rowHeight
        let textFieldWidth: CGFloat = viewWidth - 10.0
        var textFontSize: CGFloat = 32
        let labelWidth: CGFloat = viewWidth - 10.0
        let viewYInvisible: CGFloat = 0 - viewHeight - 20
        
        
        if deviceString.range(of: "iPhone") != nil {
            viewY = vcFrameRect.size.height * 0.05
            textFontSize = 18
            
        }

        return (viewX, viewY, viewWidth, viewHeight, rowHeight,
                viewCenter, textFieldHeight, textFieldWidth,
                textFontSize, labelWidth, viewYInvisible)
    }
    
    class func getMainVCFFValues() -> (viewWidth: CGFloat, viewHeight: CGFloat, rowHeight: CGFloat, viewCenter: CGFloat, buttonWidthHeight: CGFloat, titleDescFontSize: CGFloat, titleNameFontSize: CGFloat) {
        
        print("device - \(deviceString)")
        
        let viewFrameRect: CGRect = UIScreen.main.bounds
        let viewWidth: CGFloat = viewFrameRect.width
        let viewHeight: CGFloat = viewFrameRect.height
        let rowHeight: CGFloat = viewFrameRect.height / 12
        let viewCenter: CGFloat = viewFrameRect.width / 2.0
        let buttonWidthHeight: CGFloat = rowHeight * 1.5
        
        var titleDescFontSize: CGFloat = 36.0
        var titleNameFontSize: CGFloat = 64.0
                                            
        if deviceString.range(of: "iPhone") != nil {
            titleDescFontSize = 20.0
            titleNameFontSize = 32.0
        }
        
        return (viewWidth, viewHeight, rowHeight, viewCenter, buttonWidthHeight,
                titleDescFontSize, titleNameFontSize)
    }

    class func getMainVCListFFValues(_ listFrame: CGRect) -> (viewWidth: CGFloat, viewHeight: CGFloat, rowHeight: CGFloat, colSize: CGFloat, starIncrementFactor: CGFloat, shortDescFontSize: CGFloat, longDescFontSize: CGFloat) {
                                                                
        let viewWidth: CGFloat = listFrame.width
        let viewHeight: CGFloat = listFrame.height
        let rowHeight: CGFloat = listFrame.height / 10
        let colSize: CGFloat = listFrame.width / 8
        var starIncrementFactor: CGFloat = 2
        var shortDescFontSize: CGFloat = 32
        var longDescFontSize: CGFloat = 24
        
        if deviceString.range(of: "iPhone") != nil {
            starIncrementFactor = 1.5
            shortDescFontSize = 18
            longDescFontSize = 14
        }
        
        return (viewWidth, viewHeight, rowHeight, colSize, starIncrementFactor, shortDescFontSize, longDescFontSize)
            
    }
    
    class func getShowNeighboursViewListFFValues(_ listFrame: CGRect) -> (viewWidth: CGFloat, viewHeight: CGFloat, rowHeight: CGFloat, fontSize: CGFloat) {
            
        let viewWidth: CGFloat = listFrame.width
        let viewHeight: CGFloat = listFrame.height
        let rowHeight: CGFloat = listFrame.height / 4
        var fontSize: CGFloat = 24
            
        if deviceString.range(of: "iPhone") != nil {
            fontSize = 14
        }
        
        return (viewWidth, viewHeight, rowHeight, fontSize)
            
    }
    
    class func getSuitableImageSize(_ viewAreaSize: CGSize, imageSize: CGSize) -> CGSize {
        var suitableImageSize: CGSize = CGSize(width: 0, height: 0)
        var ratio: Double = 1
        
        if (viewAreaSize.width < viewAreaSize.height) {
            ratio = Double(viewAreaSize.width / imageSize.width)
            
        } else {
            ratio = Double(viewAreaSize.height / imageSize.height)
            
        }
        
        suitableImageSize.width = imageSize.width * CGFloat(ratio)
        suitableImageSize.height = imageSize.height * CGFloat(ratio)
        
        return suitableImageSize
    }
}


//public enum Model : String {
//    case simulator = "simulator/sandbox",
//    iPod1          = "iPod 1",
//    iPod2          = "iPod 2",
//    iPod3          = "iPod 3",
//    iPod4          = "iPod 4",
//    iPod5          = "iPod 5",
//    iPad2          = "iPad 2",
//    iPad3          = "iPad 3",
//    iPad4          = "iPad 4",
//    iPhone4        = "iPhone 4",
//    iPhone4S       = "iPhone 4S",
//    iPhone5        = "iPhone 5",
//    iPhone5S       = "iPhone 5S",
//    iPhone5C       = "iPhone 5C",
//    iPadMini1      = "iPad Mini 1",
//    iPadMini2      = "iPad Mini 2",
//    iPadMini3      = "iPad Mini 3",
//    iPadAir1       = "iPad Air 1",
//    iPadAir2       = "iPad Air 2",
//    iPhone6        = "iPhone 6",
//    iPhone6plus    = "iPhone 6 Plus",
//    iPhone6S       = "iPhone 6S",
//    iPhone6Splus   = "iPhone 6S Plus",
//    unrecognized   = "?unrecognized?"
//}
//
//public extension UIDevice {
//    public var type: Model {
//        var systemInfo = utsname()
//        uname(&systemInfo)
//        let modelCode = withUnsafeMutablePointer(to: &systemInfo.machine) {
//            ptr in String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
//        }
//        var modelMap : [ String : Model ] = [
//            "i386"      : .simulator,
//            "x86_64"    : .simulator,
//            "iPod1,1"   : .iPod1,
//            "iPod2,1"   : .iPod2,
//            "iPod3,1"   : .iPod3,
//            "iPod4,1"   : .iPod4,
//            "iPod5,1"   : .iPod5,
//            "iPad2,1"   : .iPad2,
//            "iPad2,2"   : .iPad2,
//            "iPad2,3"   : .iPad2,
//            "iPad2,4"   : .iPad2,
//            "iPad2,5"   : .iPadMini1,
//            "iPad2,6"   : .iPadMini1,
//            "iPad2,7"   : .iPadMini1,
//            "iPhone3,1" : .iPhone4,
//            "iPhone3,2" : .iPhone4,
//            "iPhone3,3" : .iPhone4,
//            "iPhone4,1" : .iPhone4S,
//            "iPhone5,1" : .iPhone5,
//            "iPhone5,2" : .iPhone5,
//            "iPhone5,3" : .iPhone5C,
//            "iPhone5,4" : .iPhone5C,
//            "iPad3,1"   : .iPad3,
//            "iPad3,2"   : .iPad3,
//            "iPad3,3"   : .iPad3,
//            "iPad3,4"   : .iPad4,
//            "iPad3,5"   : .iPad4,
//            "iPad3,6"   : .iPad4,
//            "iPhone6,1" : .iPhone5S,
//            "iPhone6,2" : .iPhone5S,
//            "iPad4,1"   : .iPadAir1,
//            "iPad4,2"   : .iPadAir2,
//            "iPad4,4"   : .iPadMini2,
//            "iPad4,5"   : .iPadMini2,
//            "iPad4,6"   : .iPadMini2,
//            "iPad4,7"   : .iPadMini3,
//            "iPad4,8"   : .iPadMini3,
//            "iPad4,9"   : .iPadMini3,
//            "iPhone7,1" : .iPhone6plus,
//            "iPhone7,2" : .iPhone6,
//            "iPhone8,1" : .iPhone6S,
//            "iPhone8,2" : .iPhone6Splus
//        ]
//        
//        if let model = modelMap[String(cString: modelCode)] {
//            return model
//        }
//        return Model.unrecognized
//    }
//}
