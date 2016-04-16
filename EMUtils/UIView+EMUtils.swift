//
//  UIView+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/15/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import UIKit


extension UIView {
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T {
        let v: T? = fromNib(nibNameOrNil)
        return v!
    }

    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T? {
        let name = (nibNameOrNil ?? "\(T.self)".componentsSeparatedByString(".").last!)
        let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews {
            if let result = v as? T {
                return result
            }
        }
        return nil
    }
}
