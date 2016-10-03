//
//  NeighourItem.swift
//  Bruit
//
//  Created by Asanga Udugama on 03/02/16.
//

import Foundation

class NeighbourItem: NSObject, NSCopying {
    var neighbourName: String?
    
    func copy(with zone: NSZone?) -> Any {
        let copy = NeighbourItem()
        copy.neighbourName = neighbourName
        
        return copy
    }
    
}
