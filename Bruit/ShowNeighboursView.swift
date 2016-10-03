//
//  ShowNeighboursView.swift
//  Bruit
//
//  Created by Asanga Udugama on 11/02/16.
//

import UIKit

class ShowNeighboursView: UIView {
    var dataProvider: DataProvider?
    var showNeighboursViewDelegate: ShowNeighboursViewDelegate?

    fileprivate var titleLabel: UILabel?
    fileprivate var neighbourTableView: UITableView?
    fileprivate var okButton: UIButton?
    
    init(delegate: ShowNeighboursViewDelegate, provider: DataProvider) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        showNeighboursViewDelegate = delegate
        dataProvider = provider
        let ff = FormFactor.getShowNeighboursViewFFValues()
        frame = CGRect(x: ff.viewX, y: ff.viewYInvisible, width: ff.viewWidth, height: ff.viewHeight)
        
        backgroundColor = Colors.showNeighboursViewBackgroundColor
        //layer.borderWidth = 1.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 12
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: ff.labelWidth, height: (ff.rowHeight * 1)))
        titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: ff.textFontSize)
        titleLabel?.text = "Current Neighbours"
        titleLabel?.textAlignment = .center
        addSubview(titleLabel!)

        neighbourTableView = UITableView(frame: CGRect(x: 0, y: (ff.rowHeight * 2),
            width: ff.viewWidth, height: (ff.rowHeight * 4)), style: .plain)
        neighbourTableView?.delegate = self
        neighbourTableView?.dataSource = self
        neighbourTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        neighbourTableView?.backgroundColor = Colors.showNeighboursViewBackgroundColor
        
        neighbourTableView?.layer.masksToBounds = true
        neighbourTableView?.layer.borderColor = Colors.tableBorderColor.cgColor
        neighbourTableView?.layer.borderWidth = 1.0
        
        addSubview(neighbourTableView!)
        
        
        
        okButton = UIButton(type: .custom)
        okButton?.frame = CGRect(x: 0, y: 0, width: (ff.rowHeight * 3), height: ff.rowHeight)
        okButton?.setTitle("OK", for: UIControlState())
        okButton?.setTitleColor(UIColor.black, for: UIControlState())
        okButton?.setTitleColor(UIColor.gray, for: .highlighted)
        okButton?.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: ff.textFontSize)
        okButton?.backgroundColor = Colors.okButtonBackgroundColor
        okButton?.addTarget(self, action: #selector(ShowNeighboursView.okPressed), for: .touchUpInside)
        okButton?.center = CGPoint(x: ff.viewCenter, y: (ff.rowHeight * 7))
        okButton?.layer.cornerRadius = 0.05 * (self.okButton?.bounds.size.width)!
        okButton?.layer.masksToBounds = false
        //okButton?.layer.borderWidth = 1.0
        okButton?.layer.shadowColor = UIColor.black.cgColor
        okButton?.layer.shadowOpacity = 0.8
        okButton?.layer.shadowRadius = 12
        okButton?.layer.shadowOffset = CGSize(width: 12.0, height: 12.0)
        addSubview(self.okButton!)
        
        
        

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func showShowNeighboursView() {
        let ff = FormFactor.getShowNeighboursViewFFValues()
        frame = CGRect(x: ff.viewX, y: ff.viewY, width: ff.viewWidth, height: ff.viewHeight)
        
    }
    
    func hideShowNeighboursView() {
        let ff = FormFactor.getShowNeighboursViewFFValues()
        frame = CGRect(x: ff.viewX, y: ff.viewYInvisible, width: ff.viewWidth, height: ff.viewHeight)
        
    }
    
    func okPressed() {
        
        showNeighboursViewDelegate?.neighboursSeen()
        
    }
}

extension ShowNeighboursView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataProvider?.getNeighbourCount())!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ff = FormFactor.getShowNeighboursViewListFFValues(frame)
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
//        cell.textLabel?.text = "Item \(indexPath.row)"
        let neighbourItem: NeighbourItem = (dataProvider?.getNeighbour((indexPath as NSIndexPath).row))!
        cell.textLabel?.text = neighbourItem.neighbourName
        
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: ff.fontSize)
        cell.backgroundColor = Colors.showNeighboursViewBackgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You selected cell #\((indexPath as NSIndexPath).row)!")
    }
    
}

extension ShowNeighboursView: VCDataProviderDelegate {
    func dataChanged() {
        neighbourTableView?.reloadData()
        
    }
    
}


protocol ShowNeighboursViewDelegate {
    func neighboursSeen()
}
