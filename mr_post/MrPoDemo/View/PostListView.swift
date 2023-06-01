//
//  PostListView.swift
//  MrPoDemo
//
//  Created by Ge Ding on 2/13/21.
//

import SwiftUI

struct PostListView: View {
    let category: PostListCategory//PostListView的复用
    @EnvironmentObject var userData: UserData

    var body: some View {
        List {
            ForEach(userData.postList(for: category).list) { post in
                ZStack{
                    PostCell(post: post)

                    NavigationLink(destination: PostDetailView(post: post)) {
                        EmptyView()
                    }
                    .frame(width: 0, height: 0, alignment: .center)
                }
                .listRowInsets(EdgeInsets())
            }
        }
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            PostListView(category: .recommend)
                .navigationTitle("Title")
                .navigationBarHidden(true)
        }
        .environmentObject(UserData())
    }
}
