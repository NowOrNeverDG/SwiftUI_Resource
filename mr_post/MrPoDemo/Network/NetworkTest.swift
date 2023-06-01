//
//  NetworkTest.swift
//  MrPoDemo
//
//  Created by Ge Ding on 3/18/21.
//

import SwiftUI
import Alamofire

///let url = "https://raw.githubusercontent.com/xiaoyouxinqing/PostDemo/master/PostDemo/Resources/PostListData_recommend_1.json"

struct NetworkTest: View {
    @State private var text = ""
    var body: some View {
        VStack {
            Text(text).font(.title)
            
            Button(action: {self.startLoad()}) {
                Text("Start").font(.largeTitle)
            }
            
            Button(action:{self.text = ""}) {
                Text("Clear").font(.largeTitle)
            }
        }
    }
    
    ///为什么不func startLoad() -> Result<Data,error>?
    ///发出网络请求之后会等待网络完成，获得结果，不管是数据还是错误信息，这样很耗时，所以需要异步（放在子线程）
    func startLoad() {
        NetworkManager.shared.requestGet(path: "PostListData_recommend_1.json", parameters: nil) { (result) in
            switch result {
            case let .success(data):
                guard let list = try? JSONDecoder().decode(PostList.self, from: data) else {
                    self.updateText("Can not parse data")
                    return
                }
                self.updateText("Post count \(list.list.count)")
            case let .failure(error):
                self.updateText(error.localizedDescription)
            }
        }
    }
    
    func updateText(_ text: String) {
        self.text = text;
    }
}

struct NetworkTest_Previews: PreviewProvider {
    static var previews: some View {
        NetworkTest()
    }
}
