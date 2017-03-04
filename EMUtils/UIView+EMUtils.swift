//
//  UIView+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/15/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import UIKit


extension UIView {
    public class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil) -> T {
        let v: T? = fromNib(nibNameOrNil)
        return v!
    }

    public class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil) -> T? {
        let name = (nibNameOrNil ?? "\(T.self)".components(separatedBy: ".").last!)
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews! {
            if let result = v as? T {
                return result
            }
        }
        return nil
    }


    public func addFixedSubview(_ subview: UIView) {
        addSubview(subview)
        subview.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        let views = ["subview": subview]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: [], metrics: nil, views: views))
    }
}
