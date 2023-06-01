//
//  HomeNavigationBar.swift
//  MrPoDemo
//
//  Created by Ge Ding on 2/14/21.
//

import SwiftUI

private let kLableWidth: CGFloat = 60
private let kButtonHeight: CGFloat = 24

struct HomeNavigationBar: View {
    //@state: 说明变量是现view的一个状态，当变量改变时view就会更新
    @Binding var leftPercent: CGFloat // 0 for left, 1 for right
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Button (action: {
                print("Click camera button")
            }) {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFill()
                    .frame(width: kButtonHeight, height: kButtonHeight)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            VStack(spacing: 3) {
                HStack(spacing: 0) {
                    Text("推荐")
                        .bold()//字体加粗
                        .frame(width: kLableWidth, height: kButtonHeight)
                        .padding(.top, 5)
                        .opacity(Double(1 - leftPercent * 0.5))//透明度
                        .onTapGesture{//点击响应事件
                            withAnimation { self.leftPercent = 0 }
                        }
                    
                    Spacer()
                    
                    Text("热门")
                        .bold()
                        .frame(width: kLableWidth, height: kButtonHeight)
                        .padding(.top, 5)
                        .opacity(Double(0.5 + leftPercent * 0.5))
                        .onTapGesture {
                            withAnimation { self.leftPercent = 1 }
                        }
                }
                .font(.system(size: 20))
                
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(.orange)
                        .frame(width: 30, height: 4)
                        .offset(x: (geometry.size.width/2 - 15) + geometry.size.width * ( self.leftPercent - 0.5 ) + kLableWidth * (0.5 - self.leftPercent))
                }
                .frame(height: 6)
            }
            .frame(width: UIScreen.main.bounds.width * 0.5)
            
            Spacer()
            
            Button (action: {
                print("Click add button")
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: kButtonHeight, height: kButtonHeight)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                    .foregroundColor(.orange)
            }
        }
        .frame(width:UIScreen.main.bounds.width)
    }
}

struct HomeNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavigationBar(leftPercent: .constant(0))
    }
}
