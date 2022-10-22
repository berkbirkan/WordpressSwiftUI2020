//
//  Category.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 27.06.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import Foundation
struct Category: Codable,Identifiable {
    
    let id = UUID()
    var cid = ""
    var name = ""
    var count = 0
    var description = ""
    
}

extension Category{
    
    
    
    func getCategories(completion: @escaping ([Category]) -> ()){
        
        var categories = [Category]()
       guard let url = URL(string: CATEGORY_URL) else {return}
       let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
       guard let dataResponse = data,
                 error == nil else {
                 print(error?.localizedDescription ?? "Response Error")
                 return }
           do{
               //here dataResponse received from a network request
               let jsonResponse = try JSONSerialization.jsonObject(with:
                                      dataResponse, options: [])
              // print(jsonResponse)
            let result = jsonResponse as! [[String:Any]]
            
            for category in result{
                let id = category["id"] as! Int
                let count = category["count"] as! Int
                let name = category["name"] as! String
                let description = category["description"] as! String
                
                let newcategory = Category(cid: String(id), name: name, count: count,description: description)
                
                categories.append(newcategory)
                
            }
            
            DispatchQueue.main.async {
                //comp
                
                completion(categories)
                
            }
            
            } catch let parsingError {
               print("Error", parsingError)
          }
       }
       task.resume()
    }
    
}


