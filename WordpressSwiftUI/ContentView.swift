//
//  ContentView.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 26.06.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            TabView {
                LastPosts()
                 .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                  }
                Categories()
                .tabItem {
                   Image(systemName: "list.dash")
                   Text("Categories")
                 }
                FavoriteView().tabItem {
                  Image(systemName: "heart.fill")
                  Text("Favorites")
                }.navigationBarTitle("Favorites")
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Loader: View{
    @State var isAnimated = false
    var body: some View{
        VStack{
            Circle().trim(from: 0, to: 0.8).stroke(AngularGradient(gradient: .init(colors: [.red,.orange]), center: .center),style: StrokeStyle(lineWidth: 8,lineCap: .round)).frame(width: 45,height: 45).rotationEffect(.init(degrees: self.isAnimated ? 360:0)).animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
        }.onAppear {
            self.isAnimated.toggle()
        }
    }
}
