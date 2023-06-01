//
//  ContentView.swift
//  MrPoDemo
//
//  Created by Ge Ding on 2/8/21.
//

import SwiftUI

enum Rank: Int {
    case ace = 1
    case two, three
    case jack, queen, king
    func simpleDescription() -> String {
        switch self {
        case .ace: return "ace"
        case .jack: return "jack"
        default: return String(self.rawValue)
        }
    }
}


struct ContentView: View {
    var body: some View {
        HomeView().environmentObject(UserData())
        //var arr = test()
        Text("hello world")
    }
    
    func test() -> [Int] {
        let apple = 3.422
        let quotation =
        """
        I said "I have \(apple) apple."
        And then I said "I have \(apple) pieces of fruit."
        """
        print(quotation)
        
        //字典
        var emptyArray:[Int] = [1,3,3,4,5]
        
        if let i = emptyArray.firstIndex(of: 3) {
            emptyArray[i] = 8
        }
        print(emptyArray)
        return emptyArray
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//一个变量加上?指这个变量可能为空 = optinal 类型 = 其实是一种枚举类型
//aspect ratio 宽高比
//widget 小控件
//enumeration 枚举
