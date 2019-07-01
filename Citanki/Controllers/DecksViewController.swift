//
//  DecksViewController.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 17/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit
import CoreData

class DecksViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var decks:[Deck] = []
    
    var chooseQuote:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = navigationController?.navigationBar
        title = "Decks"
        navBar?.prefersLargeTitles = true
        
        if chooseQuote{
            let barButtonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(buttonCancel))
            let navItem = self.navigationItem
            navItem.leftBarButtonItem = barButtonCancel
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        decks = CoreDataModel.fetch(request)
        
        let nibDeck = UINib(nibName: "DeckTableViewCell", bundle: nil)
        tableView.register(nibDeck, forCellReuseIdentifier: "cellDeck")
    }
    
    @objc func buttonCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DetailsDeckViewController
        let indexPath = sender as! IndexPath
        
        controller.deck = decks[indexPath.row]
        if chooseQuote{
            controller.chooseQuote = true
        }
    }
 

}

extension DecksViewController: UITableViewDataSource, UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let w = tableView.frame.width
        let h:CGFloat = 21
        let frame = CGRect(x: 0, y: 0, width: w, height: h)
        let header = HeaderViewNewDeck(frame: frame)
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
        return decks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDeck", for: indexPath) as! DeckTableViewCell
        cell.selectionStyle = .none
        cell.deck = decks[indexPath.row]
        cell.loadCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height/4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sender = indexPath
        performSegue(withIdentifier: "detailsDeck", sender: sender)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let object = self.decks.remove(at: indexPath.row)
            CoreDataModel.deleteObject(Object: object)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension DecksViewController: HeaderNewDeckDelegate {
    func didTapNewDeck() {
        var nomeDeck:String = ""
        
        let alertController = UIAlertController(title: "Novo Deck", message: "Digite um nome para seu Deck", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        let saveAlertAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let textField = alertController.textFields?[0]{
                nomeDeck = textField.text!
            }
            alertController.dismiss(animated: true, completion: nil)
            let deck = Deck(context: CoreDataModel.persistentContainer.viewContext)
            deck.title = nomeDeck
            self.decks.append(deck)
            self.tableView.reloadData()
        }
        alertController.addAction(cancelAlertAction)
        alertController.addAction(saveAlertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
