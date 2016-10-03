//
//  DataProvider.swift
//  Bruit
//
//  Created by Asanga Udugama on 03/02/16.
//

import Foundation

class DataProvider: NSObject {
    
    var mainVCDataProviderDelegate: VCDataProviderDelegate?
    var showNeighboursViewDataProviderDelegate: VCDataProviderDelegate?
    var keetchiDataProviderDelegate: KeetchiDataProviderDelegate?
    
    fileprivate var itemList: [BruitItem] = [BruitItem]()
    fileprivate var neighbourList: [NeighbourItem] = [NeighbourItem]()
    fileprivate var dataFileName: String = "bruit.dat"
    
    override init() {
        super.init()
        
//        fillTempItemData()
//        fillTempNeighbourData()
        loadBruitItems()

    }
    
    func loadBruitItems() {
        let directoryPath: NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first! as NSString
        let filePath = directoryPath.appendingPathComponent(dataFileName)
//        print("looking for \(filePath)")
        if FileManager.default.fileExists(atPath: filePath) {
//            print("file found... loading")
            self.itemList = (NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [BruitItem])!
//            print("item count - \(self.itemList.count)")
        }
    }
    
    func saveBruitItems() {
        
        let directoryPath: NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first! as NSString
        let filePath = directoryPath.appendingPathComponent(dataFileName)
//        print("looking for \(filePath)")
        if FileManager.default.fileExists(atPath: filePath) {
//            print("file found... deleting")
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
                print("couldn't delete file")
            }
        }
        
//        print("writing to file...")
//        print("item count - \(self.itemList.count)")
        NSKeyedArchiver.archiveRootObject(self.itemList, toFile: filePath)
    }
    
    // MARK: BruitItem updates
    
    func getItemCount() -> Int {
        return itemList.count
    }
    
    func getItemUsingIndex(_ itemIndex: Int) -> BruitItem? {
        
        if (itemIndex < 0 || itemIndex >= itemList.count) {
            return nil
        }
        
        return itemList[itemIndex]
    }
    
    
    func getItemUsingDataName(_ dataName: String) -> BruitItem? {
        for i in 0 ..< itemList.count {
            if dataName == itemList[i].dataName {
                return itemList[i]
            }
        }

        return nil
    }
    
    func addOwnItem(_ sentItem: BruitItem) {
        var addedItem: BruitItem
        
        addedItem = BruitItem(dataName: sentItem.dataName!, shortDesc: sentItem.shortDesc!, longDesc: sentItem.longDesc!, goodnessValue: sentItem.goodnessValue!, imageName: sentItem.imageName!, updateDate: sentItem.updateDate!, assignedColor: sentItem.assignedColor!, imageData: sentItem.imageData!)

        addedItem.itemSelected = sentItem.itemSelected
        
        itemList.insert(addedItem, at: 0)
        
        mainVCDataProviderDelegate?.dataChanged()
        keetchiDataProviderDelegate?.newItemAdded(addedItem)
    }

    func addOthersItem(_ sentItem: BruitItem) {
        var addedItem: BruitItem
        
        addedItem = BruitItem(dataName: sentItem.dataName!, shortDesc: sentItem.shortDesc!, longDesc: sentItem.longDesc!, goodnessValue: sentItem.goodnessValue!, imageName: sentItem.imageName!, updateDate: sentItem.updateDate!, assignedColor: sentItem.assignedColor!, imageData: sentItem.imageData!)
        
        addedItem.itemSelected = sentItem.itemSelected
        
        itemList.insert(addedItem, at: 0)
        
        mainVCDataProviderDelegate?.dataChanged()
    }
    
    
    func updateItemGoodnessValue(_ dataName: String, goodnessValue: Int) {
        for i in 0 ..< itemList.count {
            if dataName == itemList[i].dataName {
                itemList[i].goodnessValue = goodnessValue
                break
            }
        }

        mainVCDataProviderDelegate?.dataChanged()
    }
    
    func removeItem(_ itemIndex: Int) {
        itemList.remove(at: itemIndex)
        mainVCDataProviderDelegate?.dataChanged()
    }
    
    func updateItemGoodnessValueFromVC(_ dataName: String, goodnessValue: Int) {
        for i in 0 ..< itemList.count {
            if dataName == itemList[i].dataName {
                itemList[i].goodnessValue = goodnessValue
                keetchiDataProviderDelegate?.goodnessValueChanged(itemList[i])
                break
            }
        }
        
        
    }
    
    // MARK: NeighbourItem updates
    
    
    func getNeighbourCount() -> Int {
        return neighbourList.count
    }
    
    func getNeighbour(_ neighbourIndex: Int) -> NeighbourItem? {
        
        if (neighbourIndex < 0 || neighbourIndex >= neighbourList.count) {
            return nil
        }
        
        return neighbourList[neighbourIndex]
    }
    
    
    func addNeighbour(_ sentNeighbour: NeighbourItem) {
        var addedNeighbour: NeighbourItem
        
        addedNeighbour = NeighbourItem()
        addedNeighbour.neighbourName = sentNeighbour.neighbourName
        
        neighbourList.insert(addedNeighbour, at: 0)
        showNeighboursViewDataProviderDelegate?.dataChanged()
        
    }
    
    
    
    func updateNewNeighbourList(_ newNeighbourList: [String]) {
        
        while neighbourList.count > 0 {
            neighbourList.remove(at: 0)
        }
        for i in 0..<newNeighbourList.count {
            let newNeighbourItem: NeighbourItem = NeighbourItem()
            newNeighbourItem.neighbourName = newNeighbourList[i]
            neighbourList.insert(newNeighbourItem, at: 0)
        }
        showNeighboursViewDataProviderDelegate?.dataChanged()
    }
    
    
    
//    func fillTempItemData() {
//        let directoryPath: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first!
//        let filePath = directoryPath.stringByAppendingPathComponent(dataFileName)
//        print("looking for \(filePath)")
//        if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
//            print("file found... deleting")
//            do {
//                try NSFileManager.defaultManager().removeItemAtPath(filePath)
//            } catch {
//                print("couldn't delete file")
//            }
//        }
//        
//        var tempItem: BruitItem
//        
//        tempItem = BruitItem(dataName: "/bruit/hoi", shortDesc: "Holiday on Ice", longDesc: "A show like no other. Beautiful dancers on ice celebating winter.", goodnessValue: 20, imageName: "\(Util.get10DigitRandomNumber())", updateDate: NSDate(), assignedColor: Colors.getRandomItemEntryBackgroundColor())
//        tempItem.itemSelected = false
//        
//        itemList.append(tempItem)
//        
//        tempItem = BruitItem(dataName: "/bruit/summercamp", shortDesc: "Summer Camp", longDesc: "The ultimate outing for kids above 9 and below 12 to learn how life is when parents are not around.", goodnessValue: 80, imageName: "\(Util.get10DigitRandomNumber())", updateDate: NSDate(), assignedColor: Colors.getRandomItemEntryBackgroundColor())
//        tempItem.itemSelected = false
//        
//        itemList.append(tempItem)
//        
//        tempItem = BruitItem(dataName: "/bruit/keller", shortDesc: "Restaurant Keller", longDesc: "Opening of the Celebrations Wing of the newly renovated Restaurant Keller. Free coffee and cakes on the opening day on a first come, first served basis.", goodnessValue: 100, imageName: "\(Util.get10DigitRandomNumber())", updateDate: NSDate(), assignedColor: Colors.getRandomItemEntryBackgroundColor())
//        tempItem.itemSelected = false
//        
//        itemList.append(tempItem)
//        
//        tempItem = BruitItem(dataName: "/bruit/miller", shortDesc: "Circus Miller", longDesc: "Circus Miller is in town. Bring your kids and be enchanted !!!", goodnessValue: 60, imageName: "\(Util.get10DigitRandomNumber())", updateDate: NSDate(), assignedColor: Colors.getRandomItemEntryBackgroundColor())
//        tempItem.itemSelected = false
//        
//        itemList.append(tempItem)
//
//        tempItem = BruitItem(dataName: "/bruit/jake", shortDesc: "Jake's Garage", longDesc: "Don't pay exhorbitant amounts for simple car repairs. Let me have a look !!!", goodnessValue: 60, imageName: "\(Util.get10DigitRandomNumber())", updateDate: NSDate(), assignedColor: Colors.getRandomItemEntryBackgroundColor())
//        tempItem.itemSelected = false
//        
//        itemList.append(tempItem)
//        
//        tempItem = BruitItem(dataName: "/bruit/pete", shortDesc: "Pete's Pizza", longDesc: "Pizzas for everyone to enjoy ", goodnessValue: 40, imageName: "\(Util.get10DigitRandomNumber())", updateDate: NSDate(), assignedColor: Colors.getRandomItemEntryBackgroundColor())
//        tempItem.itemSelected = false
//        
//        itemList.append(tempItem)
//        
//        tempItem = BruitItem(dataName: "/bruit/jenny", shortDesc: "Nails By Jenny", longDesc: "Manicure and pedicure like nowhere ", goodnessValue: 80, imageName: "\(Util.get10DigitRandomNumber())", updateDate: NSDate(), assignedColor: Colors.getRandomItemEntryBackgroundColor())
//        tempItem.itemSelected = false
//        
//        itemList.append(tempItem)
//
////        tempItem = BruitItem()
////        tempItem.dataName = "/bruit/runcie"
////        tempItem.shortDesc = "Runcie's Bakery"
////        tempItem.longDesc = "We make the best bread in town."
////        tempItem.goodnessValue = 80
////        tempItem.imageName = "\(Util.get10DigitRandomNumber())"
////        tempItem.updateDate = NSDate()
////        tempItem.assignedColor = Colors.getRandomItemEntryBackgroundColor()
////        tempItem.itemSelected = false
////        
////        itemList.append(tempItem)
////        
////        tempItem = BruitItem()
////        tempItem.dataName = "/bruit/kate"
////        tempItem.shortDesc = "Yoga by Kate"
////        tempItem.longDesc = "Learn and practive Yoga from a well teained practitioner of all forms of Indian Yoga practices."
////        tempItem.goodnessValue = 80
////        tempItem.imageName = "\(Util.get10DigitRandomNumber())"
////        tempItem.updateDate = NSDate()
////        tempItem.assignedColor = Colors.getRandomItemEntryBackgroundColor()
////        tempItem.itemSelected = false
////        
////        itemList.append(tempItem)
//
//        mainVCDataProviderDelegate?.dataChanged()
//        
//        
//    }

    func fillTempNeighbourData() {
        let ni: NeighbourItem = NeighbourItem()
        ni.neighbourName = "Asanga's iPad 1"
        neighbourList.append(ni)
        
    }
}


protocol VCDataProviderDelegate {
    func dataChanged()
}

protocol KeetchiDataProviderDelegate {
    func goodnessValueChanged(_ bruitItem: BruitItem)
    func newItemAdded(_ bruitItem: BruitItem)
}
