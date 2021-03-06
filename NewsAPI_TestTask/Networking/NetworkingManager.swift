//
//  NetworkingManager.swift
//  NewsAPI_TestTask
//
//  Created by TarasPeregrinus on 12.04.2021.
//

import Foundation

class News: Codable {
    
    //MARK: - Struct
    
    struct Result: Codable {
        var status: String?
        var totalResults: Int?
        var articles: [Articles]
    }
    
    struct Articles: Codable {
        var source: Source
        var author: String?
        var title: String?
        var description: String?
        var url: String?
        var urlToImage: String?
        var publishedAt: String
        var content: String?
    }
    
    struct Source: Codable {
        var id: String?
        var name: String?
    }
    
    var country = "us"
    var category = "general"
    var result: News.Result?
    
    //MARK: - Reference
    
    private let apiKey = "9d22dc6191124789b5721d6f482ec503"
    private let rootEndpoint = "http://newsapi.org/v2/top-headlines?"
    
    
    //MARK: - Parsing
    
    func getData(completed: @escaping () -> ()){
        
        // Create URL
        let urlString = "\(self.rootEndpoint)country=\(self.country)&category=\(self.category)&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("ERROR: incorrect URL \(urlString)")
            return
        }
        
        let session = URLSession.shared
        
        // Get data with data task
        let dataTask = session.dataTask(with: url) { (data, responce, error) in
            if let error = error{
                print("ERROR!\(error.localizedDescription)")
            }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data!)
                self.result = result
                print("\(result)")
                
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
            completed()
        }
        dataTask.resume()
    }
    
}
