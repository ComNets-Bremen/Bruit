//
//  Keetchi.swift
//  Bruit
//
//  Created by Asanga Udugama on 14/02/16.
//  Copyright © 2016 Asanga Udugama. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class Keetchi: NSObject {
    var dataProvider: DataProvider?
    var commManager: P2PCommManager?
    var invocationIntervalInSec: Double?
    
    var lastNeighbourList: [NeighbourItem]?

    override init() {
        super.init()

        invocationIntervalInSec = 10
        lastNeighbourList = [NeighbourItem]()
        
    }
    
    func startKeetchiService() {
        
        let date: Date = Date().addingTimeInterval(invocationIntervalInSec!)
        let timer: Timer = Timer(fireAt: date, interval: invocationIntervalInSec!,
                                        target: self, selector: #selector(Keetchi.performKeetchiActivities),
                                        userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        print("Keetchi activities started ...")
    }
    
    func performKeetchiActivities() {
        OperationQueue.main.addOperation {
            let date = Date()
        
            print("\(date) - performKeetchiActivities() called")
            
            if self.dataProvider?.getItemCount() == 0 {
                return
            }
            
            // get item list
            var sortedItemList: [BruitItem] = [BruitItem]()
            //for var i = 0; i < self.dataProvider?.getItemCount(); i += 1 {
            for i in 0..<(self.dataProvider?.getItemCount() ?? 0) {
                let bruitItem: BruitItem = (self.dataProvider?.getItemUsingIndex(i))!
                let copyBruitItem: BruitItem = bruitItem.copy() as! BruitItem
                sortedItemList.insert(copyBruitItem, at: 0)
            }
            
            // sort list
            var itemsSwapped: Bool = true
            while itemsSwapped {
                itemsSwapped = false
                for i in 0 ..< sortedItemList.count {
                    for j in (i + 1) ..< sortedItemList.count {
                        if sortedItemList[i].goodnessValue < sortedItemList[j].goodnessValue {
                            let bruitItem: BruitItem = sortedItemList[i]
                            sortedItemList[i] = sortedItemList[j]
                            sortedItemList[j] = bruitItem
                            itemsSwapped = true
                            break
                        }
                    }
                    if itemsSwapped {
                        break
                    }
                }
            }
            
            for i in 0 ..< sortedItemList.count {
                print("item: \(sortedItemList[i].shortDesc), \(sortedItemList[i].goodnessValue)")
            }
            
            
            // get neighbour list
            var newNeighbourList: [NeighbourItem] = [NeighbourItem]()
            for i in 0..<(self.dataProvider?.getNeighbourCount() ?? 0) {
                let neighbourItem: NeighbourItem = (self.dataProvider?.getNeighbour(i))!
                let copyNeighbourItem: NeighbourItem = neighbourItem.copy() as! NeighbourItem
                newNeighbourList.insert(copyNeighbourItem, at: 0)
            }
            
            // check how many new arrivals
            var arrivedCount: Int = 0
            for i in 0 ..< newNeighbourList.count {
                var found: Bool = false
                for j in 0..<(self.lastNeighbourList?.count ?? 0) {
                    if newNeighbourList[i].neighbourName == self.lastNeighbourList![j].neighbourName {
                        found = true
                        break
                    }
                }
                if !found {
                    arrivedCount += 1
                }
            }
            
            // find change significance
            //
            // select item to send based on change siginificance
            // change significance computation:
            // - new arrivals is 25% or more, then siginificant change -> take randomly an item from top half of list (i.e. popular items)
            // - new arrivals is less than 25%, then insignificant change -> take randomly an item from bottom half of list (i.e. unpopular items)
            var selectedBruitItem: BruitItem?
            var itemSelected: Bool = false
            let changeRatio: Double = Double(arrivedCount) / Double((self.lastNeighbourList?.count)!)
            let topHalf: Int = sortedItemList.count / 2
            let bottomHalf: Int = sortedItemList.count - topHalf
            if changeRatio >= 0.25 && topHalf > 0 {
                let index = Int(arc4random_uniform(UInt32(topHalf)))
                selectedBruitItem = sortedItemList[index]
                itemSelected = true
                print("significant change - selected \(selectedBruitItem?.shortDesc) with \(selectedBruitItem?.goodnessValue)")
            } else {
                let index = Int(arc4random_uniform(UInt32(bottomHalf))) + topHalf
                selectedBruitItem = sortedItemList[index]
                itemSelected = true
                print("insignificant change - selected \(selectedBruitItem?.shortDesc) with \(selectedBruitItem?.goodnessValue)")
            }
            
            if itemSelected {
                var itemDict: [String: AnyObject] = [:]
                itemDict["messageType"] = "Data" as AnyObject?
                itemDict["dataName"] = selectedBruitItem?.dataName as AnyObject?
                itemDict["shortDesc"] = selectedBruitItem?.shortDesc as AnyObject?
                itemDict["longDesc"] = selectedBruitItem?.longDesc as AnyObject?
                itemDict["goodnessValue"] = selectedBruitItem?.goodnessValue as AnyObject?
                itemDict["imageName"] = selectedBruitItem?.imageName as AnyObject?
                itemDict["updateDate"] = selectedBruitItem?.updateDate as AnyObject?
                itemDict["assignedColor"] = selectedBruitItem?.assignedColor
                itemDict["imageData"] = selectedBruitItem?.imageData as AnyObject?
                
                let sendData: Data = NSKeyedArchiver.archivedData(withRootObject: itemDict)
                self.commManager?.sendMessageToAllPeers(sendData)
            }
            
            self.lastNeighbourList = newNeighbourList
        }
        
    }
}

extension Keetchi: P2PCommManagerDelegate {
    func receivedMessage(_ messageData: Data) {
        OperationQueue.main.addOperation {
            
            let itemDict: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: messageData) as! NSDictionary
            let messageType: String = (itemDict["messageType"] as? String)!
            
            var dataName: String?
            var shortDesc: String?
            var longDesc: String?
            var goodnessValue: Int?
            var imageName: String?
            var updateDate: Date?
            var assignedColor: UIColor?
            var imageData: Data?
            
            if messageType == "Data" {
                print("data received - \(itemDict["dataName"])")
                print(" short desc \(itemDict["shortDesc"])")
                
                dataName = (itemDict["dataName"] as? String)!
                shortDesc = (itemDict["shortDesc"] as? String)!
                longDesc = (itemDict["longDesc"] as? String)!
                goodnessValue = (itemDict["goodnessValue"] as? Int)!
                imageName = (itemDict["imageName"] as? String)!
                updateDate = (itemDict["updateDate"] as? Date)!
                assignedColor = (itemDict["assignedColor"] as? UIColor)!
                imageData = (itemDict["imageData"] as? Data)!
                
                let receivedItem: BruitItem = BruitItem(dataName: dataName!, shortDesc: shortDesc!, longDesc: longDesc!, goodnessValue: goodnessValue!, imageName: imageName!, updateDate: updateDate!, assignedColor: assignedColor!, imageData: imageData!)
                receivedItem.itemSelected = false
                
                let bruitItem: BruitItem? = self.dataProvider?.getItemUsingDataName(dataName!)
                
                if bruitItem != nil {
                    goodnessValue = (goodnessValue! + (bruitItem?.goodnessValue)!) / 2
                    self.dataProvider?.updateItemGoodnessValue(dataName!, goodnessValue: goodnessValue!)
                    
                } else {
                    self.dataProvider?.addOthersItem(receivedItem)
                    
                }
                
            } else if messageType == "Feedback" {
                print("feedback received - \(itemDict["dataName"])")
                
                dataName = (itemDict["dataName"] as? String)!
                goodnessValue = (itemDict["goodnessValue"] as? Int)!
                
                let bruitItem: BruitItem? = self.dataProvider?.getItemUsingDataName(dataName!)
                
                if bruitItem != nil {
                    goodnessValue = (goodnessValue! + (bruitItem?.goodnessValue)!) / 2
                    self.dataProvider?.updateItemGoodnessValue(dataName!, goodnessValue: goodnessValue!)
            
                }
                
                
            } else {
                print("received an unknown message")
            }
            
            
            
            
        }
        
    }
    
    func processNewNeighbourList(_ neighbourList: [String]) {
        OperationQueue.main.addOperation {
            self.dataProvider!.updateNewNeighbourList(neighbourList)
        
        }
        
    }
    
}

extension Keetchi: KeetchiDataProviderDelegate {
    func goodnessValueChanged(_ bruitItem: BruitItem) {
        OperationQueue.main.addOperation {
            var itemDict: [String: AnyObject] = [:]
            itemDict["messageType"] = "Feedback" as AnyObject?
            itemDict["dataName"] = bruitItem.dataName as AnyObject?
            itemDict["goodnessValue"] = bruitItem.goodnessValue as AnyObject?
            
            let sendData: Data = NSKeyedArchiver.archivedData(withRootObject: itemDict)
            self.commManager?.sendMessageToAllPeers(sendData)
            
        }
    }
    
    func newItemAdded(_ bruitItem: BruitItem) {
        OperationQueue.main.addOperation {
            var itemDict: [String: AnyObject] = [:]
            itemDict["messageType"] = "Data" as AnyObject?
            itemDict["dataName"] = bruitItem.dataName as AnyObject?
            itemDict["shortDesc"] = bruitItem.shortDesc as AnyObject?
            itemDict["longDesc"] = bruitItem.longDesc as AnyObject?
            itemDict["goodnessValue"] = bruitItem.goodnessValue as AnyObject?
            itemDict["imageName"] = bruitItem.imageName as AnyObject?
            itemDict["updateDate"] = bruitItem.updateDate as AnyObject?
            itemDict["assignedColor"] = bruitItem.assignedColor
            itemDict["imageData"] = bruitItem.imageData as AnyObject?
            
            let sendData: Data = NSKeyedArchiver.archivedData(withRootObject: itemDict)
            self.commManager?.sendMessageToAllPeers(sendData)
        }
    }
}



