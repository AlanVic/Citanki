//
//  DeckTableViewCell.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 18/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit

class DeckTableViewCell: UITableViewCell {

    @IBOutlet weak var titleDeck: UILabel!
    @IBOutlet weak var backgroundCell: UIView!
    @IBOutlet weak var qtdCards: UILabel!
    
    var deck: Deck?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadCell(){
        titleDeck.text = deck?.title
        qtdCards.text =  "\(String(describing: deck!.cards!.count))"
        backgroundCell.layer.cornerRadius = 10
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
