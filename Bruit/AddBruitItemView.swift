//
//  ItemDetailsView.swift
//  Bruit
//
//  Created by Asanga Udugama on 08/02/16.
//

import UIKit

class AddBruitItemView: UIView {
    var dataProvider: DataProvider?
    var addBruitItemViewDelegate: AddBruitItemViewDelegate?

    fileprivate var instructionsLabel: UILabel?
    fileprivate var shortDescTextField: UITextField?
    fileprivate var longDescTextView: UITextView?
    fileprivate var itemImageView: UIImageView?
    fileprivate var itemImage: UIImage?
    
    fileprivate var addButton: UIButton?
    fileprivate var cancelButton: UIButton?
    
    init(delegate: AddBruitItemViewDelegate, provider: DataProvider) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addBruitItemViewDelegate = delegate
        dataProvider = provider
        
        let ff = FormFactor.getAddBruitItemViewFFValues()
        frame = CGRect(x: ff.viewX, y: ff.viewYInvisible, width: ff.viewWidth, height: ff.viewHeight)
        
        var placeholder: NSAttributedString
        
        backgroundColor = Colors.addBruitItemViewBackgroundColor
        //layer.borderWidth = 1.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 12
        
        instructionsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: ff.labelWidth, height: (ff.rowHeight * 2)))
        instructionsLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: ff.textFontSize)
        instructionsLabel?.text = "Enter the details of the new Bruit item (title and description)"
        instructionsLabel?.textAlignment = .left
        instructionsLabel?.lineBreakMode = .byWordWrapping
        instructionsLabel?.numberOfLines = 2
        addSubview(instructionsLabel!)
        
        shortDescTextField = UITextField(frame: CGRect(x: 0, y: 0, width: ff.textFieldWidth, height: ff.rowHeight))
        placeholder = NSAttributedString(string: "Enter the title here", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        shortDescTextField?.attributedPlaceholder = placeholder
        shortDescTextField?.textColor = UIColor.black
        shortDescTextField?.font = UIFont(name:"HelveticaNeue-Bold", size: ff.textFontSize)
        shortDescTextField?.delegate = self
        shortDescTextField?.borderStyle = UITextBorderStyle.roundedRect
        shortDescTextField?.clearsOnBeginEditing = true
        shortDescTextField?.center = CGPoint(x: ff.viewCenter, y: (ff.rowHeight * 2) + (ff.rowHeight / 2))
        addSubview(shortDescTextField!)


        longDescTextView = UITextView(frame: CGRect(x: 0, y: 0, width: ff.textFieldWidth, height: (ff.rowHeight * 3)))
        placeholder = NSAttributedString(string: "Enter the description here", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        longDescTextView?.textColor = UIColor.black
        longDescTextView?.font = UIFont(name:"HelveticaNeue-Bold", size: ff.textFontSize)
        longDescTextView?.delegate = self
        longDescTextView?.center = CGPoint(x: ff.viewCenter, y: (ff.rowHeight * 4) + (ff.rowHeight / 2))
        longDescTextView?.layer.cornerRadius = 0.008 * (self.longDescTextView?.bounds.size.width)!
        addSubview(longDescTextView!)
        
        itemImage = UIImage(named: "camera_icon")
        print("image dim width \(itemImage?.size.width), height \(itemImage?.size.height)")
        let suitableImageSize: CGSize = FormFactor.getSuitableImageSize(
            CGSize(width: (ff.viewWidth - 10), height: (ff.rowHeight * 3)),
            imageSize: CGSize(width: itemImage!.size.width, height: itemImage!.size.height))
        itemImageView = UIImageView(image: itemImage)
        itemImageView?.frame = CGRect(x: 0, y: 0, width: suitableImageSize.width, height: suitableImageSize.height)
        itemImageView?.center = CGPoint(x: ff.viewCenter,
            y: ((ff.rowHeight * 6) + (ff.rowHeight / 2) + ((ff.rowHeight * 3) / 2)))
        itemImageView!.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddBruitItemView.imageTapped(_:)))
        itemImageView!.addGestureRecognizer(tapRecognizer)
        addSubview(itemImageView!)
        
        
        addButton = UIButton(type: .custom)
        addButton?.frame = CGRect(x: 0, y: 0, width: (ff.rowHeight * 3), height: ff.rowHeight)
        addButton?.setTitle("Add Item", for: UIControlState())
        addButton?.setTitleColor(UIColor.black, for: UIControlState())
        addButton?.setTitleColor(UIColor.gray, for: .highlighted)
        addButton?.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: ff.textFontSize)
        addButton?.backgroundColor = Colors.addItemButtonBackgroundColor
        addButton?.addTarget(self, action: #selector(AddBruitItemView.addPressed), for: .touchUpInside)
        addButton?.center = CGPoint(x: (ff.viewCenter / 2.0), y: (ff.rowHeight * 11))
        addButton?.layer.cornerRadius = 0.05 * (self.addButton?.bounds.size.width)!
        addButton?.layer.masksToBounds = false
        //addButton?.layer.borderWidth = 1.0
        addButton?.layer.shadowColor = UIColor.black.cgColor
        addButton?.layer.shadowOpacity = 0.8
        addButton?.layer.shadowRadius = 12
        addButton?.layer.shadowOffset = CGSize(width: 12.0, height: 12.0)
        addSubview(self.addButton!)
        
        
        cancelButton = UIButton(type: .custom)
        cancelButton?.frame = CGRect(x: 0, y: 0, width: (ff.rowHeight * 3), height: ff.rowHeight)
        cancelButton?.setTitle("Cancel", for: UIControlState())
        cancelButton?.setTitleColor(UIColor.black, for: UIControlState())
        cancelButton?.setTitleColor(UIColor.gray, for: .highlighted)
        cancelButton?.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: ff.textFontSize)
        cancelButton?.backgroundColor = Colors.cancelButtonBackgroundColor
        cancelButton?.addTarget(self, action: #selector(AddBruitItemView.cancelPressed), for: .touchUpInside)
        cancelButton?.center = CGPoint(x: (ff.viewCenter + (ff.viewCenter / 2.0)), y: (ff.rowHeight * 11))
        cancelButton?.layer.cornerRadius = 0.05 * (self.cancelButton?.bounds.size.width)!
        cancelButton?.layer.masksToBounds = false
        //cancelButton?.layer.borderWidth = 1.0
        cancelButton?.layer.shadowColor = UIColor.black.cgColor
        cancelButton?.layer.shadowOpacity = 0.8
        cancelButton?.layer.shadowRadius = 12
        cancelButton?.layer.shadowOffset = CGSize(width: 12.0, height: 12.0)
        addSubview(self.cancelButton!)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func showAddBruitItemView() {
        shortDescTextField?.becomeFirstResponder()
        
        let ff = FormFactor.getAddBruitItemViewFFValues()
        frame = CGRect(x: ff.viewX, y: ff.viewY, width: ff.viewWidth, height: ff.viewHeight)
        
    }

    func hideAddBruitItemView() {
        let ff = FormFactor.getAddBruitItemViewFFValues()
        frame = CGRect(x: ff.viewX, y: ff.viewYInvisible, width: ff.viewWidth, height: ff.viewHeight)
        
    }
    
    func addPressed() {
        
        if ((shortDescTextField?.text ?? "").isEmpty || (longDescTextView?.text ?? "").isEmpty) {
            return
        }
        
        shortDescTextField!.resignFirstResponder()
        longDescTextView?.resignFirstResponder()
        
        
        
        let longRandomNumber: Int = Util.get10DigitRandomNumber()
        let bruitItem: BruitItem = BruitItem(dataName: "/bruit/\(longRandomNumber)", shortDesc: (shortDescTextField?.text)!, longDesc: (longDescTextView?.text)!, goodnessValue: 40, imageName: "\(longRandomNumber)", updateDate: Date(), assignedColor: Colors.getRandomItemEntryBackgroundColor(), imageData: UIImagePNGRepresentation(itemImage!)! as Data)
        
        bruitItem.itemSelected = false

//        print("add pressed for \(bruitItem.dataName)")
        
        addBruitItemViewDelegate?.addNewItem(bruitItem)
        
        clearAllFields()
    }

    func cancelPressed() {
        shortDescTextField!.resignFirstResponder()
        longDescTextView?.resignFirstResponder()
        
        addBruitItemViewDelegate?.cancelAddNewItem()
        
        clearAllFields()
    }
    
    func clearAllFields() {
        let ff = FormFactor.getAddBruitItemViewFFValues()
        shortDescTextField?.text = ""
        longDescTextView?.text = ""
        
        itemImageView?.removeFromSuperview();
        
        itemImage = UIImage(named: "camera_icon")
//        print("image dim width \(itemImage?.size.width), height \(itemImage?.size.height)")
        let suitableImageSize: CGSize = FormFactor.getSuitableImageSize(
            CGSize(width: (ff.viewWidth - 10), height: (ff.rowHeight * 3)),
            imageSize: CGSize(width: itemImage!.size.width, height: itemImage!.size.height))
        itemImageView = UIImageView(image: itemImage)
        itemImageView?.frame = CGRect(x: 0, y: 0, width: suitableImageSize.width, height: suitableImageSize.height)
        itemImageView?.center = CGPoint(x: ff.viewCenter,
            y: ((ff.rowHeight * 6) + (ff.rowHeight / 2) + ((ff.rowHeight * 3) / 2)))
        itemImageView!.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddBruitItemView.imageTapped(_:)))
        itemImageView!.addGestureRecognizer(tapRecognizer)
        
        addSubview(itemImageView!)
        
    }
    
    func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("image tapped")
        
        addBruitItemViewDelegate?.pickImage()
        
    }
    
    func updatePickedImage(_ pickedImage: UIImage) {
        let ff = FormFactor.getAddBruitItemViewFFValues()

        itemImageView?.removeFromSuperview();
        
        // check to make image size smaller
        var qualityLevel: Float = 1.0
        var pickedImageData: Data = UIImageJPEGRepresentation(pickedImage, CGFloat(qualityLevel))!
        while (pickedImageData.count > 250000) {
            qualityLevel -= 0.1
            qualityLevel = round(qualityLevel * 10) / 10
//            print("quality level considered \(qualityLevel)")
            if (qualityLevel < 0.1) {
                break
            }
            pickedImageData = UIImageJPEGRepresentation(pickedImage, CGFloat(qualityLevel))!
//            print("quality level \(qualityLevel), image size \(pickedImageData.length)")
        }
        
        print("quality level \(qualityLevel), image size \(pickedImageData.count)")
        itemImage = UIImage(data: pickedImageData)
//        print("image dim width \(itemImage?.size.width), height \(itemImage?.size.height)")
        let suitableImageSize: CGSize = FormFactor.getSuitableImageSize(
            CGSize(width: (ff.viewWidth - 10), height: (ff.rowHeight * 3)),
            imageSize: CGSize(width: itemImage!.size.width, height: itemImage!.size.height))
        itemImageView = UIImageView(image: itemImage)
        itemImageView?.frame = CGRect(x: 0, y: 0, width: suitableImageSize.width, height: suitableImageSize.height)
        itemImageView?.center = CGPoint(x: ff.viewCenter,
            y: ((ff.rowHeight * 6) + (ff.rowHeight / 2) + ((ff.rowHeight * 3) / 2)))
        itemImageView!.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddBruitItemView.imageTapped(_:)))
        itemImageView!.addGestureRecognizer(tapRecognizer)
        
        addSubview(itemImageView!)
        
    }
    
    
}

extension AddBruitItemView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension AddBruitItemView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    
}

protocol AddBruitItemViewDelegate {
    func addNewItem(_ newBruitItem: BruitItem)
    func cancelAddNewItem()
    func pickImage()
}

