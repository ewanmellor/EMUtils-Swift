//
//  AVCaptureVisualEffectView.swift
//  EMUtils
//
//  Created by Ewan Mellor on 5/7/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import UIKit


public class AVCaptureVisualEffectView: AVCaptureView {
    private weak var visualEffectView: UIVisualEffectView?

    var effectStyle: UIBlurEffect.Style? {
        didSet {
            refresh()
        }
    }

    override public func layoutSubviews() {
        if visualEffectView == nil {
            let v = UIVisualEffectView(effect: nil)
            addFixedSubview(v)
            visualEffectView = v
            refresh()
        }

        super.layoutSubviews()
    }

    private func refresh() {
        guard let veView = visualEffectView else {
            return
        }
        if let effectStyle = effectStyle {
            veView.effect = UIBlurEffect(style: effectStyle)
        }
        else {
            veView.effect = nil
        }
    }
}
