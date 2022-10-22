//
//  Categories.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 27.06.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import SwiftUI

struct Categories: View {
    
    func getCategories(){
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
              //  print(jsonResponse)
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
                 
                self.categories = categories
                 
             }
             
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
    
    @State var categories = [Category]()
    
    var body: some View {
        NavigationView{
            List(self.categories, id: \.id) { post in
                
                
                NavigationLink(destination: LastPosts(isCategory: true, category: post)) {
                    CategoryCell(category: post)
                }
                    
            }.onAppear(){
                self.getCategories()
                
            }.navigationBarTitle("Categories")
                
        }

    }
    }


struct Categories_Previews: PreviewProvider {
    static var previews: some View {
        Categories()
    }
}

struct CategoryCell: View {
    var category = Category()
    
    var body: some View {
        
        HStack{
            Image("wordpress").resizable().frame(width: 100,height: 100)
            VStack{
                Text(category.name).font(.system(size: 15)).bold().lineLimit(2).frame(maxWidth: .infinity, alignment: .leading)
                Text(category.description).lineLimit(2).font(.system(size: 13)).lineLimit(2).frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Image(systemName: "pencil")
                    Text(String(category.count)).font(.system(size: 11)).frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
        }
        
        
    }
}
