//
//  AVCaptureView.swift
//  EMUtils
//
//  Created by Ewan Mellor on 5/7/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import AVFoundation
import UIKit


public class AVCaptureView: UIView {
    override public static var layerClass : AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    override public var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
}
