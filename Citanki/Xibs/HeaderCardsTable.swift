//
//  HeaderCardsTable.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 19/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit

protocol HeaderCardsTableDelegate {
    func didTapButton()
}

class HeaderCardsTable: UIView {

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonNewCard: UIView!
    
    var delegate: HeaderCardsTableDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("HeaderCardsTable", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        buttonNewCard.layer.cornerRadius = 8
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapNewDeck(_:)))
        buttonNewCard.addGestureRecognizer(gesture)
    }
    
    @objc func didTapNewDeck(_ gesture:UIGestureRecognizer){
        delegate?.didTapButton()
    }

}
