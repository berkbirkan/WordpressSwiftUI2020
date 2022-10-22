//
//  LastPosts.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 27.06.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftSoup

struct LastPosts: View {
    
    @State var posts = [Post]()
    @State var isCategory = false
    @State var category = Category()
    
    
    var body: some View {
        VStack{
            
            if self.isCategory{
                CategoryView(category: self.category).navigationBarTitle(category.name)
                
            }else{
                NavigationView{
                    GeneralPosts().navigationBarTitle("Last Posts")
                    
                    //Image("wordpress").frame(width:100,height: 150)
                }
               
            }
        }
        
    }
}

struct LastPosts_Previews: PreviewProvider {
    static var previews: some View {
        LastPosts()
    }
}


struct CategoryView: View{
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
    
    func getPostbyCategory(){
        var posts = [Post]()
        guard let url = URL(string: WORDPRESS_URL + "/wp-json/wp/v2/posts?_embed&status=publish&categories=" + category.cid) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                
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
                let featuredmedia = post["featured_media"] as! Int
                 
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
                newpost.featuredmedia = String(featuredmedia)
                 
                 posts.append(newpost)
                 
             }
             
             DispatchQueue.main.async {
                 //comp
                self.posts = posts
                 
             }
             
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
    @State var category = Category()
    @State var posts = [Post]()
    var body: some View{
        List(self.posts) { post in
            
        
        NavigationLink(destination: PostDetail(post: post)) {
                PostCell(post: post)
            }
                
        }
        .onAppear(){
            self.getPostbyCategory()
        
        }.id(UUID())
    }
}

struct GeneralPosts: View {
    @State var posts = [Post]()
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
    
    
    func getSliderPosts(){
        var posts = [Post]()
        guard let url = URL(string: WORDPRESS_URL + "/wp-json/wp/v2/posts?_embed&status=publish&categories=" + slideCategory) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                
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
                let featuredmedia = post["featured_media"] as! Int
                 
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
                newpost.featuredmedia = String(featuredmedia)
                 
                 posts.append(newpost)
                 
             }
             
             DispatchQueue.main.async {
                 //comp
                self.posts = posts
                 
             }
             
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
    @ObservedObject var fetcher = PostFetcher()
    @State var slideindex = 0
    @State var sliderPosts = [Post]()
    var body: some View{
        List(fetcher.postArray) { post in
               
              
        NavigationLink(destination: PostDetail(post: post,relatedposts: self.fetcher.postArray)) {
                   PostCell(post: post)
               }
                   
           }.id(UUID().uuidString)
           .onAppear(){
               
           
               }
        /*
        NavigationView{
            
            VStack{
                /*
                TabView(selection: self.$slideindex){
                    ForEach(0...5,id: \.self){index in
                        WebImage(url: URL(string: self.sliderPosts[index]))
                            .resizable()
                            .frame(height: self.slideindex == self.slideindex ?  230 : 180)
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .tag(index)
                    }
                }
                .frame(height: 230)
                .padding(.top,25)
                .animation(.easeOut)
                .onAppear {
                    print("load tabview")
                    self.getSliderPosts()
                }
 */
                
                
            }
                
                
                
                   
        }*/
        }
    }







struct PostCell: View {
    func getMedia(mediaid: String){
        
        guard let url = URL(string: FEATURED_MEDIA_URL + mediaid) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                
                let results = jsonResponse as! [String:Any]
                if let guid = results["guid"] as? [String:Any]{
                    if let rendered = guid["rendered"] as? String{
                        self.thumbnail = rendered
                    }
                }
                
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
    
    
    var post: Post
    @State var thumbnail = String()
    var body: some View {
        HStack{
            
            if self.post.image == "" {
                if thumbnail == ""{
                    Image("wordpress").resizable().frame(width: 100 ,height: 100).cornerRadius(16)
                }else{
                    WebImage(url: URL(string: thumbnail)).resizable().frame(width: 100 ,height: 100).cornerRadius(16)
                }
            }else{
                WebImage(url: URL(string: post.image)).resizable().frame(width: 100 ,height: 100).cornerRadius(16)
            }
            
            
            
            VStack{
                Text(post.title).font(.system(size: 15)).bold().lineLimit(2).frame(maxWidth: .infinity, alignment: .leading)
                Text(Post().parseHTMLText(html: post.content)).font(.system(size: 13)).lineLimit(2).frame(maxWidth: .infinity, alignment: .leading)
                
                HStack{
                    Image(systemName: "calendar")
                    Text(post.date).font(.system(size: 11)).frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Image(systemName: "text.bubble.fill")
                    Text(post.comment)
                }

                
            }
            
            
        }.onAppear {
            if self.post.image == ""{
                self.getMedia(mediaid: self.post.featuredmedia)
            }
        }
    }
}
