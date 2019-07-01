//
//  HeaderNewDeckTableViewCell.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 18/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit

protocol HeaderNewDeckDelegate: class {
    func didTapNewDeck()
}

class HeaderViewNewDeck: UIView {
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    var delegate: HeaderNewDeckDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("HeaderNewDeck", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        buttonView.layer.cornerRadius = 8
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapNewDeck(_:)))
        buttonView.addGestureRecognizer(gesture)
    }
    
    @objc func didTapNewDeck(_ gesture: UIGestureRecognizer){
        delegate?.didTapNewDeck()
    }
    
}
