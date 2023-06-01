//
//  HomeView.swift
//  MrPoDemo
//
//  Created by Ge Ding on 2/15/21.
//

import SwiftUI

struct HomeView: View {
    @State var leftPercent: CGFloat = 0
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
        //UIScrollView.appearance().isPagingEnabled = true
    }
    
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                HScrollViewController(pageWidth: geometry.size.width,
                                      contentSize: CGSize(width: geometry.size.width * 2,
                                                          height: geometry.size.height),
                                      leftPercent: self.$leftPercent)
                {
                    HStack(spacing: 0) {
                    PostListView(category: .recommend)
                        .frame(width: UIScreen.main.bounds.width)

                    PostListView(category: .hot)
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)//忽略安全区
            .navigationBarItems(leading: HomeNavigationBar(leftPercent: $leftPercent))
            .navigationBarTitle("首页")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())//修改ipad上的样式和iPhone一样，ipad默认双界面
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserData())
    }
}
