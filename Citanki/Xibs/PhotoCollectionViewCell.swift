//
//  PhotoCollectionViewCell.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 23/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit

protocol CellActionDelegate {
    func removeCell(_ cell: UICollectionViewCell)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var shakeEnabled: Bool!
    var indexPath: IndexPath!
    static var delegate: CellActionDelegate!
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deleteButton.layer.masksToBounds = false
        deleteButton.layer.shadowColor = UIColor.black.cgColor
        deleteButton.layer.shadowRadius = 0.5
        deleteButton.layer.shadowOffset = CGSize(width: -2, height: 2)
        deleteButton.layer.shadowOpacity = 0.3
        
        // Initialization code
    }
    @IBAction func removeItem(_ sender: UIButton) {
        PhotoCollectionViewCell.delegate.removeCell(self)
    }
    
    
    func shakeIcons() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.01
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        let startAngle: Float = (-1) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value:  stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount = 10000
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"shaking")
        self.deleteButton.isHidden = false
        shakeEnabled = true
    }
    
    func stopShakingIcons() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
        self.deleteButton.isHidden = true
        shakeEnabled = false
    }

}
