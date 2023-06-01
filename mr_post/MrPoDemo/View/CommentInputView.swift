//
//  CommentInputView.swift
//  MrPoDemo
//
//  Created by Ge Ding on 2/18/21.
//

import SwiftUI

struct CommentInputView: View {
    let post: Post
    @State private var text: String = ""
    @State private var showEmptyTextHUD: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userData: UserData
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        VStack(spacing: 0) {
            CommentTextView(text: $text,beginEdittingOnAppear: true)
            
            HStack(spacing:0) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("取消").padding()
                })
                
                Spacer()
                
                Button(action: {
                    if self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {//判断文本是否为空
                        self.showEmptyTextHUD = true
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                            self.showEmptyTextHUD = false
                        }
                        return
                    }
                    print(self.text)
                    var post = self.post
                    post.commentCount += 1
                    self.userData.update(post)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("发送").padding()
                })
                .font(.system(size: 18))
                .foregroundColor(.black)
            }
            .overlay(
                Text("评论不能为空")
                    .scaleEffect(showEmptyTextHUD ? 1 : 0.5)//缩放效果
                    .animation(.spring(dampingFraction: 0.5))//回弹效果
                    .opacity(showEmptyTextHUD ? 1: 0)
                    .animation(.easeInOut)
            )
            
        }
        .padding(.bottom, keyboardResponder.keyboardHeight)
        .edgesIgnoringSafeArea(keyboardResponder.keyboardShow ? .bottom : [])
    }
    
}

struct CommentInputView_Previews: PreviewProvider {
    static var previews: some View {
        CommentInputView(post: UserData().recommendPostList.list[0])
    }
}
