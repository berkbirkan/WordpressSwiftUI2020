//
//  Post.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 26.06.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import SwiftUI
import SwiftSoup


class Post: Codable,Identifiable {
   
    var id = UUID()
    
    var title = "Title"
    var date = "01-06-2020"
    var content = "Content"
    var desc = "Desc"
    var image = ""
    var category = "General"
    var comment = "52"
    var link = ""
    var postid = ""
    var author_name = ""
    var featuredmedia = ""
    
    
    
}

extension Post {
    
    
    
    
    
    func parsehtmlimage(content: String)->[String]{
        do {
            let doc: Document = try SwiftSoup.parse(content)
            let srcs: Elements = try doc.select("img[src]")
            let srcsStringArray: [String?] = srcs.array().map { try? $0.attr("src").description }
            // do something with srcsStringArray
            return srcsStringArray as! [String]
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
        return []
        
    }
    
    func parseHTMLText(html:String)->String{
        do {
           let doc: Document = try SwiftSoup.parse(html)
           return try doc.text()
        } catch Exception.Error(let type, let message) {
            print(message)
            print(type)
            return ""
        } catch {
            print("error")
            return ""
        }
    }
    
    func getPostsbyCategory(cid:String,completion: @escaping ([Post]) -> ()){
        
        var posts = [Post]()
        guard let url = URL(string: WORDPRESS_URL + "/wp-json/wp/v2/posts?_embed&status=publish&categories=" + cid) else {return}
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
             
             for post in result{
                 let title = post["title"] as! [String:Any]
                 let link = post["link"] as! String
                 let renderedtitle = title["rendered"] as! String
                 
                 let content = post["content"] as! [String:Any]
                 let renderedcontent = content["rendered"] as! String
                 
                 let desk = post["excerpt"] as! [String:Any]
                 let rendereddesc = desk["rendered"] as! String
                 let postid = post["id"] as! Int
                 
                 var newpost = Post()
                 newpost.title = self.parseHTMLText(html: renderedtitle)
                 newpost.content = renderedcontent
                 newpost.date = post["date"] as! String
                 if self.parsehtmlimage(content: renderedcontent).count != 0{
                     newpost.image = self.parsehtmlimage(content: renderedcontent)[0]
                 }else{
                     newpost.image = ""
                 }
                 newpost.desc = rendereddesc
                 newpost.link = link
                 newpost.postid = String(postid)
                 
                 posts.append(newpost)
                 
             }
             
             DispatchQueue.main.async {
                 //comp
                 
                 completion(posts)
                 
             }
             
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
    
    
    func getPosts(completion: @escaping ([Post]) -> ()){
        
        var posts = [Post]()
       guard let url = URL(string: HOME_URL) else {return}
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
            
            for post in result{
                let title = post["title"] as! [String:Any]
                let link = post["link"] as! String
                let renderedtitle = title["rendered"] as! String
                
                let content = post["content"] as! [String:Any]
                let renderedcontent = content["rendered"] as! String
                
                let desk = post["excerpt"] as! [String:Any]
                let rendereddesc = desk["rendered"] as! String
                let postid = post["id"] as! Int
                
                var newpost = Post()
                newpost.title = self.parseHTMLText(html: renderedtitle)
                newpost.content = renderedcontent
                newpost.date = post["date"] as! String
                if self.parsehtmlimage(content: renderedcontent).count != 0{
                    newpost.image = self.parsehtmlimage(content: renderedcontent)[0]
                }else{
                    newpost.image = ""
                }
                newpost.desc = rendereddesc
                newpost.link = link
                newpost.postid = String(postid)
                
                posts.append(newpost)
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                 completion(posts)
            }
            
            } catch let parsingError {
               print("Error", parsingError)
          }
       }
       task.resume()
    }
    
    
    
}
public class PostFetcher: ObservableObject {

    @Published var postArray = [Post]()
    
    func parsehtmlimage(content: String)->[String]{
        do {
            let doc: Document = try SwiftSoup.parse(content)
            let srcs: Elements = try doc.select("img[src]")
            let srcsStringArray: [String?] = srcs.array().map { try? $0.attr("src").description }
            // do something with srcsStringArray
            return srcsStringArray as! [String]
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
        return []
        
    }
    
    func parseHTMLText(html:String)->String{
        do {
           let doc: Document = try SwiftSoup.parse(html)
           return try doc.text()
        } catch Exception.Error(let type, let message) {
            print(message)
            print(type)
            return ""
        } catch {
            print("error")
            return ""
        }
    }
    
    init(){
        deneme()
    }
    
    func deneme(){
        var posts = [Post]()
        guard let url = URL(string: HOME_URL) else {return}
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
             
             for post in result{
                var author_name = ""
                var thumbnail_image = ""
                var comment = "5"
                 let title = post["title"] as! [String:Any]
                 let link = post["link"] as! String
                 let renderedtitle = title["rendered"] as! String
                 
                 let content = post["content"] as! [String:Any]
                 let renderedcontent = content["rendered"] as! String
                 
                 let desk = post["excerpt"] as! [String:Any]
                 let rendereddesc = desk["rendered"] as! String
                 let postid = post["id"] as! Int
                let featuredmedia = post["featured_media"] as! Int
                
                let author = post["author"] as! Int
                author_name = String(author)
 
                
                if let enyenideneme = post["wp:featuredmedia"] as? [String:Any]{
                    let source_url = enyenideneme["source_url"] as! String
                    thumbnail_image = source_url
                }
                
                
                 
                 var newpost = Post()
                 newpost.title = self.parseHTMLText(html: renderedtitle)
                 newpost.content = renderedcontent
                 newpost.date = post["date"] as! String
                 if self.parsehtmlimage(content: renderedcontent).count != 0{
                     newpost.image = self.parsehtmlimage(content: renderedcontent)[0]
                 }else{
                     newpost.image = thumbnail_image
                 }
                 newpost.desc = rendereddesc
                 newpost.link = link
                 newpost.postid = String(postid)
                newpost.comment = comment
                newpost.author_name = author_name
                newpost.featuredmedia = String(featuredmedia)
                
                 
                 posts.append(newpost)
                 
             }
             
                DispatchQueue.main.async {
                    self.postArray = posts
                }
             
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
}
