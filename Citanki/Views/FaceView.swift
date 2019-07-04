//
//  FaceView.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 03/07/19.
//  Copyright © 2019 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit

class FaceView: UIView {
    var boundingBox = CGRect.zero
    
    func clear(){
        boundingBox = .zero
        DispatchQueue.main.async {
            self.setNeedsLayout()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.saveGState()
        
        defer{
            context.restoreGState()
        }
        
//        context.addRect(boundingBox)
        context.stroke(boundingBox, width: 5)
        UIColor.red.setStroke()
        
    }
}
