//
//  DetailsDeckViewController.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 19/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit

protocol DetailsDeckViewControllerDelegate:class {
    func parsingCard(quote:Quote)
}

class DetailsDeckViewController: UIViewController {
    var quotes:[Quote] = []
    var deck:Deck?
    var quoteSelected:Quote?
    var chooseQuote:Bool = false
    static var delegate:DetailsDeckViewControllerDelegate?
    var indexPathSelected: IndexPath!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if chooseQuote{
            let okBarButtomItem = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(buttonOk))
            self.navigationItem.rightBarButtonItem = okBarButtomItem
        }
        title = deck?.title
        
        let navBar = navigationController?.navigationBar
        navBar?.prefersLargeTitles = true

        tableView.delegate = self
        tableView.dataSource = self
        
        
        let cellCard:UINib = UINib(nibName: "CardTableViewCell", bundle: nil)
        tableView.register(cellCard, forCellReuseIdentifier: "CardTableViewCell")
      
    }
    
    @objc func buttonOk(){
        if let quoteSelected = quoteSelected{
            DetailsDeckViewController.delegate?.parsingCard(quote: quoteSelected)
            self.dismiss(animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: nil, message: "Please, choose an quote for your photo", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(actionOk)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let cards = deck?.cards?.allObjects as! [Card]
        let quotes = cards.map { (card) -> Quote in
            let quote = self.getQuote(fromCard: card)
            return quote
        }
        self.quotes = quotes
//        self.cards = cards
        tableView.reloadData()
    }
    
    func getCard(fromQuote quote:Quote) -> Card{
        let cards = deck?.cards?.allObjects as! [Card]
        let cardFilter = cards.filter {$0.id == quote.id}
        return cardFilter.first ?? Card()
    }
    
    func getQuote(fromCard card:Card) -> Quote{
        let id = Int(card.id)
        let body = card.quote
        let author = card.author
        let selected = false
        
        let quote = Quote(id: id, body: body!, author: author!, selected: selected)
        
        return quote
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newCard"{
            let destination = segue.destination as! UINavigationController
            let controller = destination.topViewController as! SearchViewController
            controller.delegate = self
            
        }
    }
 

}
extension DetailsDeckViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let w = tableView.frame.width
        let h:CGFloat = 44
        let frame = CGRect(x: 0, y: 0, width: w, height: h)
        let header = HeaderCardsTable(frame: frame)
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if chooseQuote == true{
            return 0
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as! CardTableViewCell
        cell.selectionStyle = .none
        cell.quote = quotes[indexPath.row]
        cell.indexPath = indexPath
        if chooseQuote{
            cell.notRequiredAcessoryView = false
            cell.delegate = self
        }
        cell.loadCell()
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let quote = quotes.remove(at: indexPath.row)
            let card = self.getCard(fromQuote: quote)
            deck?.removeFromCards(card)
            CoreDataModel.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension DetailsDeckViewController: HeaderCardsTableDelegate,SearchViewControllerDelegate, CardTableViewCellDelegate{
    
    func didTapInCheckBox(cell: CardTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else{return}
        self.quoteSelected = quotes[indexPath.row]
        deselectAllQuotes()
        self.tableView.reloadData()
        quotes[indexPath.row].selected = true
        let customCell = cell
        customCell.isChecked = true
        
        
//        tableView.reloadData()
    }
    
    func deselectAllQuotes(){
        quotes = self.quotes.map { (quote) -> Quote in
            var newQuote = quote
            newQuote.selected = false
            return newQuote
        }
    }
    
    func parsingQuotesToOtherViewController(quotes: [Quote]) {
        
        let quotesSelected = quotes.filter{$0.selected == true}
        quotesSelected.forEach { (quote) in
            deck?.addToCards(fromQuote: quote)
        }
    }
    
    func didTapButton() {
        performSegue(withIdentifier: "newCard", sender: nil)
    }
    
}

extension Deck{
    func addToCards(fromQuote quote:Quote){
        let card = Card(context: CoreDataModel.persistentContainer.viewContext)
        card.author = quote.author
        card.id = Int32(quote.id)
        card.quote = quote.body
        self.addToCards(card)
    }
}


