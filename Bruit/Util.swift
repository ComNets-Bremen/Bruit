//
//  Util.swift
//  Bruit
//
//  Created by Asanga Udugama on 10/02/16.
//  Copyright © 2016 Asanga Udugama. All rights reserved.
//

import Foundation

class Util {
    
    class func get10DigitRandomNumber() -> Int {
        var longRandomNumber: Int = 0
        var tens: Int = 1
        
        for _ in 1...8 {
            let rNum = Int(UInt32(arc4random_uniform(8)) + UInt32(1))
            longRandomNumber += (rNum * tens)
            tens *= 10
        }
        return longRandomNumber
        
    }
}


