//
//  UIWindow+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 5/8/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import UIKit


private let transitionDuration = 0.2


extension UIWindow {
    public func crossDissolveToRootViewController(_ viewController: UIViewController) {
        UIView.transition(with: self, duration: transitionDuration, options: [.transitionCrossDissolve], animations: { [unowned self] in
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(true)
        }, completion: nil)
    }
}
