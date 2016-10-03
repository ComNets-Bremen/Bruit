//
//  BruitItem.swift
//  Bruit
//
//  Created by Asanga Udugama on 03/02/16.
//

import Foundation
import UIKit

class BruitItem: NSObject, NSCopying, NSCoding {
    var dataName: String?
    var shortDesc: String?
    var longDesc: String?
    var goodnessValue: Int?
    var imageName: String?
    var updateDate: Date?
    var assignedColor: UIColor?
    var imageData: Data?
    
    var itemSelected: Bool?
    
    init(dataName: String, shortDesc: String, longDesc: String, goodnessValue: Int, imageName: String, updateDate: Date, assignedColor: UIColor, imageData: Data) {
        
        self.dataName = dataName
        self.shortDesc = shortDesc
        self.longDesc = longDesc
        self.goodnessValue = goodnessValue
        self.imageName = imageName
        self.updateDate = updateDate
        self.assignedColor = assignedColor
        self.imageData = imageData
        
        self.itemSelected = false
    }
    
    
    required convenience init?(coder decoder: NSCoder) {
        guard let dataName = decoder.decodeObject(forKey: "dataName") as? String,
                let shortDesc = decoder.decodeObject(forKey: "shortDesc") as? String,
                let longDesc =  decoder.decodeObject(forKey: "longDesc") as? String,
                let goodnessValue = decoder.decodeObject(forKey: "goodnessValue") as? Int,
                let imageName = decoder.decodeObject(forKey: "imageName") as? String,
                let updateDate = decoder.decodeObject(forKey: "updateDate") as? Date,
                let assignedColor = decoder.decodeObject(forKey: "assignedColor") as? UIColor,
                let imageData = decoder.decodeObject(forKey: "imageData") as? Data
        
        
            else { return nil }
        
        self.init(dataName: dataName, shortDesc: shortDesc, longDesc: longDesc, goodnessValue: goodnessValue, imageName: imageName, updateDate: updateDate, assignedColor: assignedColor, imageData: imageData)
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.dataName, forKey: "dataName")
        coder.encode(self.shortDesc, forKey: "shortDesc")
        coder.encode(self.longDesc, forKey: "longDesc")
        coder.encode(self.goodnessValue, forKey: "goodnessValue")
        coder.encode(self.imageName, forKey: "imageName")
        coder.encode(self.updateDate, forKey: "updateDate")
        coder.encode(self.assignedColor, forKey: "assignedColor")
        coder.encode(self.imageData, forKey: "imageData")
    }
    
    
    func copy(with zone: NSZone?) -> Any {
        let copy = BruitItem(dataName: dataName!, shortDesc: shortDesc!, longDesc: longDesc!, goodnessValue: goodnessValue!, imageName: imageName!, updateDate: updateDate!, assignedColor: assignedColor!,imageData: imageData!)
        
        copy.itemSelected = itemSelected
        
        
        return copy
    }
    
    
    
}

