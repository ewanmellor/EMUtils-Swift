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

    public class func registerNibOnTableView(_ tableView: UITableView) {
        let cellId = cellIdentifier
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }

    public class func dequeueFromTableView<T: UITableViewCell>(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> T {
        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! T
    }
}
