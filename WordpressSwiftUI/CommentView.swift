//
//  CommentView.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 6.07.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import SCLAlertView

struct CommentView: View {
    func postComment(){
        let alert = SCLAlertView()
        let authorname = alert.addTextField("Name")
        let email = alert.addTextField("E-mail")
        let content = alert.addTextField("Your comment")
        
        alert.addButton("Send") {
            
            
            let deneme = WORDPRESS_URL + "/wp-json/wp/v2/comments?author_name="
            let deneme2 = deneme + authorname.text! + "&author_email="
            let deneme3 = deneme2 + email.text! + "&content=" + content.text! + "&post="
            guard let url = URL(string: deneme3 + self.postid) else {return}
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do{
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    
                    //let jsonArray = jsonResponse as? [[String: Any]]
                    
                    print("RESULT COMMENT:")
                //    print(jsonResponse)
                    let result = jsonResponse as! [String:Any]
                    let message = result["message"] as! String
                    
                    
                    
                    DispatchQueue.main.async {
                        
                        SCLAlertView().showInfo("Message", subTitle: message)
                        
                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            task.resume()
            
        }
        
        alert.showEdit("Post Comment", subTitle: "Post comment")
    }
    @State var comments = [Comment]()
    @State var commentStr = String()
    @State var postid = String()
    var body: some View {
        VStack{
            if self.comments.count == 0{
                Image(systemName: "text.bubble.fill")
            }else{
                List(self.comments) { comment in
                    CommentCell(comment: comment)
                        
                }
            }
            
            HStack{
                TextField("Write something...", text: $commentStr).cornerRadius(16)
                Button(action: {
                    print(self.commentStr)
                    self.postComment()

                }) {
                    Image(systemName: "paperplane")
                    .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                }
            }
        }
    }
}

struct CommentCell: View {
    @State var comment = Comment()
    var body: some View{
        VStack{
            HStack{
                WebImage(url: URL(string: comment.avatar)).resizable().frame(width: 50 ,height: 50).cornerRadius(16)
                Text(comment.author_name).foregroundColor(Color.blue)
                Spacer()
                Image(systemName: "calendar")
                Text(comment.date)
            }
            
            Text(Post().parseHTMLText(html: comment.content))
            
           
            
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
