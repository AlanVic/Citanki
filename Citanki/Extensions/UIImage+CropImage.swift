//
//  UIImage+CropImage.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 03/07/19.
//  Copyright © 2019 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit


extension UIImage{
    func cropped(boundingBox: CGRect) -> UIImage?{
        guard let ciImage = self.ciImage?.cropped(to: boundingBox) else {
            return nil
        }
        
//        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
//            return nil
//        }
        
        return UIImage(ciImage: ciImage)
        
    }
}
