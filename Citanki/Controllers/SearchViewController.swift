//
//  SearchViewController.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 19/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func parsingQuotesToOtherViewController(quotes:[Quote])
}

class SearchViewController: UIViewController {
    
    var quotes:[Quote] = []
    var searchController: UISearchController!
    var scopeTitles = ["Word","Tag","Author"]
    
    var delegate:SearchViewControllerDelegate?
    
    var activityView:UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        activityView.style = .gray
        activityView.transform = CGAffineTransform(scaleX: 3, y: 3)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        super.viewDidLoad()
        let barButtonSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveCards))
        let barButtonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        navigationItem.rightBarButtonItem = barButtonSave
        navigationItem.leftBarButtonItem = barButtonCancel
        
        let navBar = navigationController?.navigationBar
        title = "Search"
        navBar?.prefersLargeTitles = true
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Buscar Citações"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = scopeTitles
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
       
        
        let nibCell = UINib(nibName: "CardTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "CardTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityView.startAnimating()
        QuotesAPI.getQuotes { (result) in
            switch result{
            case .success(let quotesApi):
                DispatchQueue.main.async {
                    self.quotes = quotesApi
                    self.tableView.reloadData()
                    self.activityView.stopAnimating()
                }
            case .failure(let error):
                self.quotes = []
                self.tableView.reloadData()
                self.activityView.stopAnimating()
                print(error)
            }
        }
    }
    

    @objc func didTapSaveCards(){
        delegate?.parsingQuotesToOtherViewController(quotes: quotes)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapCancel(){
        self.dismiss(animated: true, completion: nil)
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! CardTableViewCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as? CardTableViewCell{
            cell.selectionStyle = .none
            cell.quote = quotes[indexPath.row]
            cell.indexPath = indexPath
            cell.delegate = self
            cell.notRequiredAcessoryView = false
            cell.loadCell()
            
            return cell
        }
        else {
            return UITableViewCell()
            
        }
    }
}

extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        return
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        let indexScope = searchBar.selectedScopeButtonIndex
        
        activityView.startAnimating()
        
        QuotesAPI.getQuotes(withType: Types(rawValue: indexScope)!, andWord: searchText) { (result) in
            switch result {
            case .success(let quotesApi):
                DispatchQueue.main.async {
                    self.quotes = quotesApi
                    self.tableView.reloadData()
                    self.activityView.stopAnimating()
                }
            case .failure(let error):
                self.quotes = []
                self.tableView.reloadData()
                self.activityView.stopAnimating()
                print(error)
            }
        }
    }
    
}

extension SearchViewController: CardTableViewCellDelegate{
    func didTapInCheckBox(cell: CardTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell)else{return}
        quotes[indexPath.row].selected = true
        
    }
}


