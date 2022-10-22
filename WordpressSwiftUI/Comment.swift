//
//  Comment.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 5.07.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import Foundation

struct Comment: Codable,Identifiable {
    var id = UUID()
    
    var author_name = ""
    var date = ""
    var content = ""
    var avatar = ""
}


public class CommentFetcher: ObservableObject{
    @Published var comments = [Comment]()
    var postid = ""
    func getComments(){
        
        guard let url = URL(string: COMMENTS + postid) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                
                let jsonArray = jsonResponse as? [[String: Any]]
                let comments = jsonArray
                for comment in comments! {
                    let author = comment["author_name"] as! String
                    let date = comment["date"] as! String
                    let content = comment["content"] as! [String:Any]
                    let renderedcontent = content["rendered"] as! String
                    
                    let avatar = comment["author_avatar_urls"] as! [String:Any]
                    let renderedavatar = avatar.values.first as! String
                    
                    var comment = Comment()
                    comment.author_name = author
                    comment.date = date
                    comment.content = renderedcontent
                    comment.avatar = renderedavatar
                    
                    self.comments.append(comment)
                    
                }
                
                DispatchQueue.main.async {
                    //self.commentbuttton.titleLabel?.text = String(self.comments.count)
                    
                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}
