//
//  MainVC.swift
//  Bruit
//
//  Created by Asanga Udugama on 03/02/16.
//  Copyright © 2016 Asanga Udugama. All rights reserved.
//

import UIKit
import MobileCoreServices
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


class MainVC: UIViewController {
    
    var dataProvider: DataProvider?
    
    fileprivate var titleLabel: UILabel?
    fileprivate var itemTableView: UITableView?
    fileprivate var addButton: UIButton?
    fileprivate var showNeighboursButton: UIButton?
    fileprivate var screenShotImageView: UIImageView?
    
    fileprivate var addBruitItemView: AddBruitItemView?
    fileprivate var showNeighboursView: ShowNeighboursView?
    
    fileprivate let cellIdentifer = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ff = FormFactor.getMainVCFFValues()
        print("view did load on main called")
        
        view.backgroundColor = Colors.viewBackgroundColor
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        titleLabel?.attributedText = buildAttributedTitleString()
        titleLabel?.textAlignment = .center
        titleLabel?.sizeToFit()
        titleLabel?.center = CGPoint(x: ff.viewCenter, y: (ff.rowHeight * 0.5) + (ff.rowHeight / 2))
        view.addSubview(self.titleLabel!)
        
        
        itemTableView = UITableView(frame: CGRect(x: 0, y: (ff.rowHeight * 1.5),
            width: ff.viewWidth, height: (ff.rowHeight * 9)), style: .plain)
        itemTableView?.delegate = self
        itemTableView?.dataSource = self
        //registerCellsForTableView(self.itemTableView!)
        itemTableView!.register(BruitItemViewCell.self, forCellReuseIdentifier: NSStringFromClass(BruitItemViewCell.self))
        itemTableView?.backgroundColor = Colors.viewBackgroundColor
        
        itemTableView?.layer.masksToBounds = true
        itemTableView?.layer.borderColor = Colors.tableBorderColor.cgColor
        itemTableView?.layer.borderWidth = 1.0
        
        view.addSubview(self.itemTableView!)
        
        
        addButton = UIButton(type: .custom)
        addButton?.frame = CGRect(x: 0, y: 0, width: ff.buttonWidthHeight, height: ff.buttonWidthHeight)
        addButton?.setImage(UIImage(named:"plus_icon"), for: UIControlState())
        addButton?.imageEdgeInsets = UIEdgeInsets(top: ff.buttonWidthHeight / 4,
            left: ff.buttonWidthHeight / 4,
            bottom: ff.buttonWidthHeight / 4,
            right: ff.buttonWidthHeight / 4)
        addButton?.backgroundColor = Colors.addButtonBackgroundColor
        addButton?.addTarget(self, action: #selector(MainVC.addPressed), for: .touchUpInside)
        addButton?.center = CGPoint(x: (ff.viewCenter / 2.0), y: (ff.rowHeight * 11))
        addButton?.layer.cornerRadius = 0.5 * (self.addButton?.bounds.size.width)!
        addButton?.layer.masksToBounds = false
        //addButton?.layer.borderWidth = 1.0
        addButton?.layer.shadowColor = UIColor.black.cgColor
        addButton?.layer.shadowOpacity = 0.8
        addButton?.layer.shadowRadius = 12
        addButton?.layer.shadowOffset = CGSize(width: 12.0, height: 12.0)
        view.addSubview(self.addButton!)

        
        showNeighboursButton = UIButton(type: .custom)
        showNeighboursButton?.frame = CGRect(x: 0, y: 0, width: ff.buttonWidthHeight, height: ff.buttonWidthHeight)
        showNeighboursButton?.setImage(UIImage(named:"neighbours_icon"), for: UIControlState())
        showNeighboursButton?.imageEdgeInsets = UIEdgeInsets(top: ff.buttonWidthHeight / 4,
                                                            left: ff.buttonWidthHeight / 4,
                                                            bottom: ff.buttonWidthHeight / 4,
                                                                right: ff.buttonWidthHeight / 4)
        showNeighboursButton?.backgroundColor = Colors.showNeighboursButtonBackgroundColor
        showNeighboursButton?.addTarget(self, action: #selector(MainVC.showNeighboursPressed), for: .touchUpInside)
        showNeighboursButton?.center = CGPoint(x: (ff.viewCenter / 2.0) * 3.0, y: (ff.rowHeight * 11))
        showNeighboursButton?.layer.cornerRadius = 0.5 * (self.showNeighboursButton?.bounds.size.width)!
        showNeighboursButton?.layer.masksToBounds = false
        //showNeighboursButton?.layer.borderWidth = 1.0
        showNeighboursButton?.layer.shadowColor = UIColor.black.cgColor
        showNeighboursButton?.layer.shadowOpacity = 0.8
        showNeighboursButton?.layer.shadowRadius = 12
        showNeighboursButton?.layer.shadowOffset = CGSize(width: 12.0, height: 12.0)
        view.addSubview(showNeighboursButton!)
        
        
        addBruitItemView = AddBruitItemView(delegate: self, provider: dataProvider!)
        view.addSubview(addBruitItemView!)

        showNeighboursView = ShowNeighboursView(delegate: self, provider: dataProvider!)
        dataProvider?.showNeighboursViewDataProviderDelegate = showNeighboursView
        view.addSubview(showNeighboursView!)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        print("view will appear on main called")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addPressed() {
        print("Add Pressed")
        
        for i in 0..<(dataProvider?.getItemCount() ?? 0) {
            let bruitItem: BruitItem = (dataProvider?.getItemUsingIndex(i))!
            
            print("item: \(bruitItem.shortDesc), selected: \(bruitItem.itemSelected), goodness value: \(bruitItem.goodnessValue) ")
           
        }
        
        UIGraphicsBeginImageContext(view.bounds.size);
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        screenShotImageView = UIImageView(image: screenShot)
        screenShotImageView?.frame = UIScreen.main.bounds
        screenShotImageView?.layer.opacity = 0.5
        
        view.addSubview(screenShotImageView!)
        view.bringSubview(toFront: screenShotImageView!)
        
        addButton?.isHidden = true
        showNeighboursButton?.isHidden = true
        itemTableView?.isHidden = true
        
        view.bringSubview(toFront: addBruitItemView!)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
                self.addBruitItemView?.showAddBruitItemView()
            }, completion: nil)
        
        
    }
    
    func showNeighboursPressed() {
        print("Show Neighbours Pressed")
        UIGraphicsBeginImageContext(view.bounds.size);
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        screenShotImageView = UIImageView(image: screenShot)
        screenShotImageView?.frame = UIScreen.main.bounds
        screenShotImageView?.layer.opacity = 0.5
        
        view.addSubview(screenShotImageView!)
        view.bringSubview(toFront: screenShotImageView!)
        
        addButton?.isHidden = true
        showNeighboursButton?.isHidden = true
        itemTableView?.isHidden = true
        
        view.bringSubview(toFront: showNeighboursView!)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
            self.showNeighboursView?.showShowNeighboursView()
            }, completion: nil)
        
    }
    
    func buildAttributedTitleString() -> NSMutableAttributedString {
        var titleStringAttributed: NSMutableAttributedString
        let titleString: String = "Bruit: Spread the Word !!!"
        let ff = FormFactor.getMainVCFFValues()

        titleStringAttributed = NSMutableAttributedString(string: titleString,
        attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: ff.titleDescFontSize)!])
 
        titleStringAttributed.addAttribute(NSFontAttributeName,
            value: UIFont(
                name: "HelveticaNeue-Bold",
//                name: "Chalkduster",
                size: ff.titleNameFontSize)!,
            range: NSRange(
                location: 0,
                length: 6))
        for i in 0...5 {
            titleStringAttributed.addAttribute(NSForegroundColorAttributeName,
//                value: Colors.getColorByIndex(i),
                value: Colors.getBruitTextColorByIndex(i),
                range: NSRange(
                    location:i,
                    length:1))
        }
        for i in 6 ..< titleString.characters.count {
            titleStringAttributed.addAttribute(NSForegroundColorAttributeName,
                value: Colors.testColor,
//                value: Colors.getRandomItemEntryBackgroundColor(),
                range: NSRange(
                    location:i,
                    length:1))
        }
        

        return titleStringAttributed
    }
    
}

extension MainVC: AddBruitItemViewDelegate {
    func addNewItem(_ newBruitItem: BruitItem) {
        dataProvider?.addOwnItem(newBruitItem)
        //itemTableView?.reloadData()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
        
            self.addBruitItemView?.hideAddBruitItemView()
            
            
            
            }, completion: { (Bool) in
                self.screenShotImageView?.removeFromSuperview()
                self.addButton?.isHidden = false
                self.showNeighboursButton?.isHidden = false
                self.itemTableView?.isHidden = false
                
                })
        
        
        
    }
    
    func cancelAddNewItem() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
            
            self.addBruitItemView?.hideAddBruitItemView()
            

            
            }, completion: { (Bool) in
                self.screenShotImageView?.removeFromSuperview()
                self.addButton?.isHidden = false
                self.showNeighboursButton?.isHidden = false
                self.itemTableView?.isHidden = false
                
                })
        
        
    }
    
    func pickImage() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
}

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            dismiss(animated: true, completion: nil)
            addBruitItemView?.updatePickedImage(pickedImage)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension MainVC: ShowNeighboursViewDelegate {
    func neighboursSeen() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
            
            self.showNeighboursView?.hideShowNeighboursView()
            

            }, completion: {(Bool) in
                self.screenShotImageView?.removeFromSuperview()
                self.addButton?.isHidden = false
                self.showNeighboursButton?.isHidden = false
                self.itemTableView?.isHidden = false
                
                })
        
        
    }
    
}

extension MainVC: VCDataProviderDelegate {
    func dataChanged() {
        itemTableView?.reloadData()
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider!.getItemCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BruitItemViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BruitItemViewCell.self), for: indexPath) as! BruitItemViewCell
        
        let bruitItem: BruitItem = dataProvider!.getItemUsingIndex((indexPath as NSIndexPath).row)!
        bruitItem.itemSelected = false
        cell.bruitItem = bruitItem
        cell.dataProvider = dataProvider
        
//        cell.layer.borderWidth = 1.0
//        cell.layer.borderColor = UIColor.lightGrayColor().CGColor

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bruitItem: BruitItem = dataProvider!.getItemUsingIndex((indexPath as NSIndexPath).row)!
        bruitItem.itemSelected = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        print("You selected cell #\((indexPath as NSIndexPath).row)! \(bruitItem.shortDesc)")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let bruitItem: BruitItem = dataProvider!.getItemUsingIndex((indexPath as NSIndexPath).row)!
        bruitItem.itemSelected = false

        tableView.beginUpdates()
        tableView.endUpdates()
        
        print("You deselected cell #\((indexPath as NSIndexPath).row)! \(bruitItem.shortDesc)")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bruitItem: BruitItem = dataProvider!.getItemUsingIndex((indexPath as NSIndexPath).row)!
        let ff = FormFactor.getMainVCListFFValues(self.view.frame)

        if (bruitItem.itemSelected == true) {
            return (ff.rowHeight * 4)
        } else {
            return (ff.rowHeight + 10)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataProvider?.removeItem((indexPath as NSIndexPath).row)
        }
    }
}

class BruitItemViewCell: UITableViewCell {
    var dataProvider: DataProvider?
    
    var itemImageView: UIImageView!
    var itemShortDescLabel: UILabel!
    var itemLongDescLabel: UILabel!
    var itemGoodnessValueStarImageViewList: [UIImageView]!
    var largeItemImageView: UIImageView!
    
    var bruitItem: BruitItem? {
        didSet {
            if let b = bruitItem {
                itemShortDescLabel.text = b.shortDesc
                itemLongDescLabel.text = b.longDesc
                
                let fullStarCount: Int = (b.goodnessValue! - (b.goodnessValue! % 20)) / 20
                for i in 0..<5 {
                    let starImageView: UIImageView = itemGoodnessValueStarImageViewList[i]
                    if (i < fullStarCount) {
                        starImageView.image = UIImage(named: "star_full_icon")
                        starImageView.tag = (i * 10) + 1
                    } else {
                        starImageView.image = UIImage(named: "star_empty_icon")
                        starImageView.tag = (i * 10) + 2
                    }
                    starImageView.isUserInteractionEnabled = true
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BruitItemViewCell.starTapped(_:)))
                    starImageView.addGestureRecognizer(tapRecognizer)
                }
                itemImageView.removeFromSuperview()
                var itemImage: UIImage = UIImage(data:b.imageData! as Data, scale:1.0)!
                itemImageView = UIImageView(image: itemImage)
                contentView.addSubview(itemImageView)
                
                largeItemImageView.removeFromSuperview()
                itemImage = UIImage(data:b.imageData! as Data, scale:1.0)!
                largeItemImageView = UIImageView(image: itemImage)
                contentView.addSubview(largeItemImageView)
                
              
                setNeedsLayout()
                
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let ff = FormFactor.getMainVCListFFValues(frame)
        
        selectionStyle = .none
        
        itemImageView = UIImageView(image: UIImage(named: "camera_icon"))
        contentView.addSubview(itemImageView)
        
        itemShortDescLabel = UILabel(frame: CGRect.zero)
        itemShortDescLabel.textAlignment = .left
        itemShortDescLabel.textColor = UIColor.black
        itemShortDescLabel.font = UIFont(name:"HelveticaNeue-Bold", size: ff.shortDescFontSize)
            //.font.fontWithSize(itemShortDescLabel.font.pointSize * 0.65)
        contentView.addSubview(itemShortDescLabel)
        
        itemLongDescLabel = UILabel(frame: CGRect.zero)
        itemLongDescLabel.textAlignment = .left
        itemLongDescLabel.textColor = UIColor.black
        itemLongDescLabel.lineBreakMode = .byWordWrapping
        itemLongDescLabel.numberOfLines = 0
        itemLongDescLabel.font = UIFont(name:"HelveticaNeue-Bold", size: ff.longDescFontSize)

        itemLongDescLabel.isHidden = true
        contentView.addSubview(itemLongDescLabel)
        
        itemGoodnessValueStarImageViewList = []
        for i in 0..<5 {
            let starImageView: UIImageView = UIImageView(frame: CGRect.zero)
            starImageView.image = UIImage(named: "star_empty_icon")
            starImageView.tag = (i * 10) + 2
            itemGoodnessValueStarImageViewList.append(starImageView)
            contentView.addSubview(starImageView)
        }
        
        largeItemImageView = UIImageView(image: UIImage(named: "camera_icon"))
        largeItemImageView.isHidden = true
        contentView.addSubview(largeItemImageView)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected) {
            itemLongDescLabel.isHidden = false
            largeItemImageView.isHidden = false
            bruitItem?.itemSelected = true
        } else {
            itemLongDescLabel.isHidden = true
            largeItemImageView.isHidden = true
            bruitItem?.itemSelected = false
        }
        print("setSelected for \(bruitItem?.shortDesc) called")
        
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        let ff = FormFactor.getMainVCListFFValues(frame)
        
        contentView.backgroundColor = bruitItem?.assignedColor
        
        var x, y, w, h: CGFloat
                
        w = ff.colSize - 10.0
        h = ff.colSize - 10.0
        x = 5.0
        y = 5.0
        itemImageView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        itemShortDescLabel.sizeToFit()
        w = (ff.colSize * 4.0) - 10.0
        h = itemShortDescLabel.frame.size.height
        x = ff.colSize + 5.0
        y = 5.0
        itemShortDescLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = ff.colSize + 5.0
        y = itemShortDescLabel.frame.origin.y + itemShortDescLabel.frame.size.height + 5.0
        for i in 0..<5 {
            let starImageView: UIImageView = itemGoodnessValueStarImageViewList[i]
            starImageView.sizeToFit()
            starImageView.frame.size.width *= ff.starIncrementFactor
            starImageView.frame.size.height *= ff.starIncrementFactor
            starImageView.frame.origin.x = x
            starImageView.frame.origin.y = y
            x += starImageView.frame.size.width + 2.0
        }
        
        let starImageView: UIImageView = itemGoodnessValueStarImageViewList[0]
        x = ff.colSize + 5.0
        y = y + starImageView.frame.size.height + 5.0
        w = (ff.colSize * 7.0) - 10.0
        h = itemShortDescLabel.frame.size.height * 3.0
        itemLongDescLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        let itemImage: UIImage = largeItemImageView.image!
        let suitableImageSize: CGSize = FormFactor.getSuitableImageSize(
            CGSize(width: (ff.viewWidth - 10), height: (ff.rowHeight * 4)),
            imageSize: CGSize(width: itemImage.size.width, height: itemImage.size.height))
        x = (ff.viewWidth - suitableImageSize.width) / 2
        y = y + itemLongDescLabel.frame.size.height + 5
        largeItemImageView.frame = CGRect(x: x, y: y, width: suitableImageSize.width, height: suitableImageSize.height)
       
        print("item \(bruitItem?.shortDesc) rendered")
    }
    
    func starTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if (bruitItem?.itemSelected != true) {
            return
        }
        
        let tappedImageView = gestureRecognizer.view!
        let imageType: Int = tappedImageView.tag % 10
        let index: Int = (tappedImageView.tag - imageType) / 10
        
        
        for i in 0..<5 {
            let starImageView: UIImageView = itemGoodnessValueStarImageViewList[i]
            starImageView.image = UIImage(named: "star_empty_icon")
            starImageView.tag = (i * 10) + 2
        }
        
        var goodnessValue: Int = 0
        
        for i in 0..<5 {
            if (i <= index) {
                let starImageView: UIImageView = itemGoodnessValueStarImageViewList[i]
                starImageView.image = UIImage(named: "star_full_icon")
                starImageView.tag = (i * 10) + 1
                goodnessValue += 20
            }
        }

        bruitItem?.goodnessValue = goodnessValue
        bruitItem?.updateDate = Date()
        setNeedsLayout()
        
        dataProvider?.updateItemGoodnessValueFromVC((bruitItem?.dataName)!, goodnessValue: goodnessValue)
        
    }
    
    
}

