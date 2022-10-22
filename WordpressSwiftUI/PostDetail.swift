//
//  PostDetail.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 27.06.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetail: View {
    @State var post = Post()
    @State var comments = [Comment]()
    @State var isCommentClicked = false
    @ObservedObject var fetcher = PostFetcher()
    @State var relatedposts = [Post]()
    @State private var showShareSheet = false
    @State public var sharedItems : [Any] = []
    @State var authorname = "Author Name"
    @State var author_description = String()
    @State var author_avatar = String()
    @State var isFavorite = Bool()
    
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
                        self.post.image = rendered
                    }
                }
                
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
    
    func getAuthorDetails(){
        guard let url = URL(string: AUTHOR_PAGE + post.author_name) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
               //print(jsonResponse) //Response result
                if let results = jsonResponse as? [String:Any]{
                    let results = jsonResponse as! [String:Any]
                    if let authorname = results["name"] as? String{
                        self.authorname = authorname
                    }
                    
                    if let description = results["description"] as? String{
                        self.author_description = description
                    }
                    
                    if let avatar = results["avatar_urls"] as? [String:Any]{
                        if let avatarurl = avatar["96"] as? String{
                            self.author_avatar = avatarurl
                        }
                    }
                }
                
                
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
    
    func getComments(){
        
        guard let url = URL(string: COMMENTS + post.postid) else {return}
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
    var body: some View {
        ZStack{
            if isCommentClicked{
                CommentView(comments: self.comments,postid: self.post.postid)
                
            }else{
                ScrollView(.vertical,showsIndicators: false){
                        VStack{
                            
                            
                            HStack{
                                
                                
                                
                                Text(post.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                Spacer()
                            }.padding(.top)
                            .padding(.horizontal)
                            HStack{
                                Text(self.authorname).bold()
                            }.onAppear {
                                self.getAuthorDetails()
                            }.padding(.leading).foregroundColor(Color.gray)
                            
                            HStack{
                                
                                Text(post.category).foregroundColor(Color.red).fontWeight(.bold)
                                Spacer()
                                Image(systemName: "calendar")
                                Text(post.date)
                            }.padding(.top)
                            .padding(.horizontal)
                            HStack{
                                if self.post.image == ""{
                                    Image("wordpress").resizable().frame(width: 300 ,height: 300).cornerRadius(16)
                                }else{
                                    WebImage(url: URL(string: post.image)).resizable().frame(width: 300 ,height: 300).cornerRadius(16)
                                }
                            }.onAppear {
                                if self.post.image == ""{
                                    self.getMedia(mediaid: self.post.featuredmedia)
                                }
                            }
                            
                            
                            
                            Text(Post().parseHTMLText(html: post.content)).multilineTextAlignment(.leading)
                            .padding(.top)
                            .padding(.horizontal)
                            
                           
                            
                            
                            
                            HStack{
                                Text("Comments")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }.padding(.top)
                            .padding(.horizontal)
                            
                            HStack(spacing: 0){
                                
                                if self.comments.count > 5{
                                    ForEach(0...5,id: \.self){i in
                                        
                                        WebImage(url: URL(string: self.comments[i].avatar))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .offset(x: -CGFloat(i * 20))
                                    }
                                }else if self.comments.count > 0{
                                    ForEach(0...self.comments.count - 1,id: \.self){i in
                                        
                                        WebImage(url: URL(string: self.comments[i].avatar))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .offset(x: -CGFloat(i * 20))
                                    }
                                }
                                
                                
                                Spacer(minLength: 0)
                                
                                Button(action: {self.isCommentClicked = true}) {
                                    
                                    Text("View All")
                                        .fontWeight(.bold)
                                }
                            }// since first is moved -20
                            .padding(.leading,20)
                            .padding(.top)
                                .padding(.horizontal).onAppear {
                                    self.getComments()
                            }
                            
                            // Button..
                            
                            Button(action: {
                                self.isCommentClicked = true
                            }) {
                                
                                Text("Read " + String(self.comments.count) + " comments")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 150)
                                    .background(Color.blue)
                                    .cornerRadius(15)
                            }
                            .padding(.top,25)
                            .padding(.bottom)
                            
                            // Carousel...
                            HStack{
                                if self.relatedposts.count > 5 {
                                    Text("Related Posts")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                
                                
        
                            }
                            .padding(.top)
                            .padding(.horizontal)
                            
                            VStack{
                                if self.relatedposts.count > 5{
                                    PostCell(post: self.relatedposts[0])
                                                                   PostCell(post: self.relatedposts[1])
                                                                   PostCell(post: self.relatedposts[2])
                                                                   PostCell(post: self.relatedposts[3])
                                                                   PostCell(post: self.relatedposts[4])
                                }
                               
                            }
                            
                            
                            
                        }.onAppear {
                            self.getComments()
                        }
                    }
                    
            }
        }.navigationBarItems(trailing:
            HStack {
                
                Button(action: {
                    //share url
                    let activityViewController = SwiftUIActivityViewController()
                    activityViewController.shareImage(uiImage: URL(string: self.post.link)!)

                }) {
                    Image(systemName: "square.and.arrow.up.fill")
                    .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original)).foregroundColor(Color.red)
                }
                
                Button(action: {
                    self.isCommentClicked = true

                }) {
                    Image(systemName: "message.fill").renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original)).foregroundColor(Color.red)
                }.foregroundColor(Color.red)
                
                

                Button(action: {
                    //add favorite
                    
                    
                    if DBManager.sharedInstance.isFavorite(inputpost: self.post){
                        DBManager.sharedInstance.deleteFromDb(object: DBManager.sharedInstance.getindex(inputpost: self.post))
                        self.isFavorite = false
                    }else{
                        let newPost = Favorite()
                        newPost.title = self.post.title
                        newPost.content = self.post.content
                        newPost.author_name = self.post.author_name
                        newPost.category = self.post.category
                        newPost.comment = self.post.comment
                        newPost.date = self.post.date
                        newPost.desc = self.post.desc
                        newPost.featuredmedia = self.post.featuredmedia
                        newPost.postid = self.post.postid
                        newPost.link = self.post.link
                        newPost.image = self.post.image
                        
                        DBManager.sharedInstance.addData(object: newPost)
                        self.isFavorite = true
                        
                    }

                }) {
                    if DBManager.sharedInstance.isFavorite(inputpost: self.post){
                        Image(systemName: "heart.fill").renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original)).foregroundColor(Color.red)
                    }else{
                        Image(systemName: "heart").renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original)).foregroundColor(Color.red)
                    }
                    
                }
            }
        )
        }
        
        
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetail()
    }
}
struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void

    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

class ActivityViewController : UIViewController {

    var URL:URL!

    @objc func shareImage() {
        let vc = UIActivityViewController(activityItems: [URL!], applicationActivities: [])
        vc.excludedActivityTypes =  [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        present(vc,
                animated: true,
                completion: nil)
        vc.popoverPresentationController?.sourceView = self.view
    }
}
struct SwiftUIActivityViewController : UIViewControllerRepresentable {

    let activityViewController = ActivityViewController()

    func makeUIViewController(context: Context) -> ActivityViewController {
        activityViewController
    }
    func updateUIViewController(_ uiViewController: ActivityViewController, context: Context) {
        //
    }
    func shareImage(uiImage: URL) {
        activityViewController.URL = uiImage
        activityViewController.shareImage()
    }
}
