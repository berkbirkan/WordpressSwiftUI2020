//
//  FavoriteView.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 6.07.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import SwiftUI

struct FavoriteView: View {
    @State var posts = [Post]()
    
    var body: some View {
        NavigationView{
            
            
            
            List(self.posts) { post in
                    
                
                NavigationLink(destination: PostDetail(post: post)) {
                    
                        PostCell(post: post)
                    }
                        
            }.onAppear {
                for post in DBManager.sharedInstance.getDataFromDB(){
                    var newPost = Post()
                    newPost.title = post.title
                    newPost.content = post.content
                    newPost.author_name = post.author_name
                    newPost.category = post.category
                    newPost.comment = post.comment
                    newPost.date = post.date
                    newPost.desc = post.desc
                    newPost.featuredmedia = post.featuredmedia
                    newPost.postid = post.postid
                    newPost.link = post.link
                    newPost.image = post.image
                    self.posts.append(newPost)
                }
            }.navigationBarTitle("Favorites")
            
        }.navigationBarTitle("Favorites")
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
