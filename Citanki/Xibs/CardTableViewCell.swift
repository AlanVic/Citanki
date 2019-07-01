//
//  CardTableViewCell.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 19/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol CardTableViewCellDelegate: class {
    func didTapInCheckBox(cell: CardTableViewCell)
}

class CardTableViewCell: UITableViewCell {
    
    var card:Card?
    var quote:Quote?
    var indexPath: IndexPath?
    var notRequiredAcessoryView:Bool = true
    
    var isChecked = false{
        didSet{
            if isChecked == false{
                checkBox.setOn(false, animated: true)
            }
            else{
                checkBox.setOn(true, animated: true)
            }
        }
    }
    
    @IBOutlet weak var widthConstraintCheckBox: NSLayoutConstraint!
    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var textQuote: UILabel!
    @IBOutlet weak var authorQuote: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    var delegate:CardTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.delegate = self
        backgroundCard.layer.cornerRadius = 10
    }
    
    func loadCell() {
        if let _ = card{
            textQuote.text = card?.quote
            authorQuote.text = card?.author
        }else{
            textQuote.text = quote?.body
            authorQuote.text = quote?.author
        }
        
        if let stateCheck = quote?.selected{
            if stateCheck{
                isChecked = true
            }else{
                isChecked = false
            }
        }else{
            isChecked = false
        }
        
        if notRequiredAcessoryView{
            self.checkBox.isHidden = true
            widthConstraintCheckBox.constant = 0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CardTableViewCell: BEMCheckBoxDelegate{
    func didTap(_ checkBox: BEMCheckBox) {
        delegate?.didTapInCheckBox(cell: self)
    }
}
