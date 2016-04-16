//
//  UIViewController+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/15/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import UIKit


extension UIViewController {

    /**
     true if this view is has been presented modally.
     */
    public var isModal: Bool {
        return (
            (presentingViewController?.presentedViewController == self) ||
                (navigationController?.presentingViewController?.presentedViewController == navigationController) ||
                (tabBarController?.presentingViewController?.isKindOfClass(UITabBarController) ?? false)
        )
    }

    /**
     If this view is modal, dismiss it, otherwise pop it.  See isModal.
     */
    func dismissOrPop() {
        if (isModal) {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
}
