//
//  PostCellToolBarButton.swift
//  MrPoDemo
//
//  Created by Ge Ding on 2/13/21.
//

import SwiftUI

struct PostCellToolBarButton: View {
    let image: String
    let text: String
    let color: Color
    let action:() -> Void //closure for action
    
    var body: some View {
        Button(action:action) {
            HStack(spacing:5) {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                Text(text)
                    .font(.system(size: 15))
            }
        }
        .foregroundColor(color)
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct PostCellToolBarButton_Previews: PreviewProvider {
    static var previews: some View {
        PostCellToolBarButton(image: "heart", text: "like", color: .red) {
            print("like")
        }
    }
}
