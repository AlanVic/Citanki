//
//  QuotesApi.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 17/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import Foundation

struct Quote:Codable,Equatable {
    var id: Int
    var tags: [String]
    var body:String
    var author:String
    var selected:Bool? = false
    
    init(id:Int, body: String, author:String, selected:Bool) {
        self.id = id
        self.tags = []
        self.body = body
        self.author = author
        self.selected = selected
    }
    
    static func ==(lhs: Quote, rhs: Quote) -> Bool{
        if lhs.id == rhs.id{
            return true
        }else{
            return false
        }
    }
}

struct ListQuotes:Codable {
    var quotes:[Quote]
}

struct QuoteDay:Codable{
    var quote:Quote
}

enum  Result<Value> {
    case success(Value)
    case failure(Error)
}



enum Types:Int{
    case word = 0
    case tag = 1
    case author = 2
}

struct QuotesAPI {
    private static let baseURLString = "https://favqs.com/"
    private static let apiKey = "a856e644ee540eec54fe632d91ede7a2"
    
    static func getQuotes(withType type:Types = .word, andWord word:String? = nil, completion: @escaping ((Result<[Quote]>) -> Void)){
        var urlComponets = URLComponents(string: baseURLString)
        urlComponets?.path = "/api/quotes"
        switch type {
        case .tag:
            let queryItem = URLQueryItem(name: "type", value: "tag")
            urlComponets?.queryItems = [queryItem]
        case .author:
            let queryItem = URLQueryItem(name: "type", value: "author")
            urlComponets?.queryItems = [queryItem]
        case .word: break
        }
        
        if let _ = word{
            let queryItem = URLQueryItem(name: "filter", value: word)
            urlComponets?.queryItems?.append(queryItem)
        }
        
        guard let url = urlComponets?.url else {fatalError("Could not create URL")}
 
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError{
                    completion(.failure(error))
                }else if let jsonData = responseData{
                    let decoder = JSONDecoder()
                    
                    do{
                        let listQuotes = try decoder.decode(ListQuotes.self, from: jsonData)
                        let quotes = listQuotes.quotes
                        completion(.success(quotes))
                    }catch{
                        completion(.failure(error))
                    }
                }else{
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from request"]) as Error
                    
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    static func getQuoteDay(completion:@escaping((Result<Quote>) -> Void)){
        var urlComponets = URLComponents(string: baseURLString)
        urlComponets?.path = "/api/qotd"
        
        guard let url = urlComponets?.url else {fatalError("Could not create URL")}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError{
                    completion(.failure(error))
                }else if let jsonData = responseData{
                    let decoder = JSONDecoder()
                    
                    do{
                        let quoteDay = try decoder.decode(QuoteDay.self, from: jsonData)
                        let quote = quoteDay.quote
                    
                        completion(.success(quote))
                    }catch{
                        completion(.failure(error))
                    }
                }else{
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from request"]) as Error
                    
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
