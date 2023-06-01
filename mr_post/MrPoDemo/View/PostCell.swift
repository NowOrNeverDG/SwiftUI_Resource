//
//  PostCell.swift
//  MrPoDemo
//
//  Created by Ge Ding on 2/11/21.
//

import SwiftUI

struct PostCell: View {
    var post: Post
    @EnvironmentObject var userData: UserData
    var bindingPost: Post { userData.post(forId: post.id)! }
    @State var presentComment: Bool = false
    
    var body: some View {
        var post = bindingPost
        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5){
                post.avatarImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(
                        PostVIPBadge(vip: post.vip)
                            .offset(x: 13, y: 13)
                    )
                VStack(alignment: .leading, spacing: 5) {
                    Text(post.name)
                        .font(Font.system(size: 13))
                        .foregroundColor(Color.red)
                        .lineLimit(1)
                    Text(post.date)
                        .font(.system(size:9))
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10)
                
                Spacer()
                
                // follow & unfollow button
                if !post.isFollowed {
                    Spacer()
                    
                    Button (action: {
                        post.isFollowed = true
                        self.userData.update(post)
                    }) {
                        Text("follow")
                            .font(.system(size:13))
                            .foregroundColor(.orange)
                            .frame(width:40, height:25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .stroke(Color.orange,lineWidth: 1)
                            )
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            Text(post.text)
                .font(.system(size: 13))
            
            if !post.images.isEmpty {
                PostImageCell(images: post.images, width: UIScreen.main.bounds.width-70)
            }
            
            Divider()
            
            HStack(spacing: 0) {
                Spacer()
                
                PostCellToolBarButton(image: "message",
                                      text: post.commentCountText,
                                      color: .black) {
                    self.presentComment = true
                }
                .sheet(isPresented: $presentComment, content: {//模态
                    CommentInputView(post: post).environmentObject(self.userData)
                })
                    
                Spacer()
                
                PostCellToolBarButton(image: post.isLiked ? "heart.fill" : "heart",
                                      text: post.likeCountText,
                                      color: post.isLiked ? .red : .black) {
                    if post.isLiked {
                        post.isLiked = false
                        post.likeCount -= 1
                    } else {
                        post.isLiked = true
                        post.likeCount += 1
                    }
                    self.userData.update(post)
                }
                
                Spacer()
            }
            
            Rectangle()
                .padding(.horizontal, -15)
                .frame(height:10)
                .foregroundColor(Color(red: 238/255, green: 238/255, blue: 238/255))
        }
        .padding(.horizontal, 15)
        .padding(.top,15)
        
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        let  userData = UserData()
        return PostCell(post: userData.recommendPostList.list[0]).environmentObject(userData)
    }
}
