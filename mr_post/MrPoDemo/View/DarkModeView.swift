//
//  DarkModeView.swift
//  MrPoDemo
//
//  Created by Ge Ding on 3/18/21.
//

import SwiftUI

struct DarkModeView: View {
    var body: some View {
        VStack {
            //默认颜色并且自己适应夜间模式
            Text("Default SwiftUI")
                .bold()
            //.label: UIColor system default label color && fit to darkmode automatically
            Text("Label UIColor")
                .bold()
                .foregroundColor(Color(.label))
            Text("secondaryLabel UIColor")
                .bold()
                .foregroundColor(Color(.secondaryLabel))
            //color property(.yellow) can fit to darkmode in a part of.
            Text("Color.yellow")
                .bold()
                .foregroundColor(.yellow)
            //systemcolor(belong to UIcolor) fit darkmode auto.
            Text("UIColor.systemYellow")
                .bold()
                .foregroundColor(Color(.systemBlue))
            //custom color from
            Text("Custom")
                .bold()
                .foregroundColor(Color(.custom))
            //color category (xcassets)
            Text("assetcolor")
                .bold()
                .foregroundColor(Color("wholeColor"))
            //image category (xcassets)
            Image("testIcon")
        }
    }
}

extension UIColor {
    static let custom = UIColor { trait in
        switch trait.userInterfaceStyle {
        case.dark: return .green
        default: return .label
        }
    }
}
struct DarkModeView_Previews: PreviewProvider {
    static var previews: some View {
        DarkModeView()
    }
}


