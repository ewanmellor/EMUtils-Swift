//
//  UITableViewCell+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/22/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import UIKit


public extension UITableViewCell {
    public class var cellIdentifier: String {
        return NSStringFromClass(self)
    }

    public class func registerNibOnTableView(tableView: UITableView) {
        let cellId = cellIdentifier
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
    }

    public class func dequeueFromTableView<T: UITableViewCell>(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> T {
        return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! T
    }
}
