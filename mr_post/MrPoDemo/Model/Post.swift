//Data model for single user info on fanslist
//depend on jason format

import SwiftUI

let postList = loadPostListData("PostListData_recommend_1.json")

struct PostList: Codable {
    var list = [Post]()
}

//Data Model
struct Post: Codable, Identifiable {
    let id: Int //UserID
    let avatar: String //avatar and img name
    let vip: Bool // if vip
    let name: String
    let date: String
    let text: String //post concept
    let images: [String]//post pic
    
    var isFollowed: Bool// if followed
    var isLiked: Bool// if liked

    var commentCount: Int
    var likeCount: Int
}

extension Post {
    var avatarImage: Image {
        return loadImage(name: avatar)
    }
    
    //be only read property = calculated property
    var commentCountText: String {
        if commentCount <= 0 { return "comment" }
        if commentCount <= 1000 { return "\(commentCount)" }
        return String(format: "%.1fK", Double(commentCount) / 1000)
    }
    
    var likeCountText: String {
        if likeCount <= 0 {return "like"}
        if likeCount < 1000 { return "\(likeCount)"}
        return String(format: "%.1fK", Double(likeCount)/1000)
    }
}

func loadPostListData(_ fileName: String) -> PostList {
    //string -> url
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError( "Can not find \(fileName) in main bundle")
    }
    //get data from url
    guard let data = try? Data(contentsOf: url) else {
        fatalError("Can not find \(url)")
    }
    //parse data
    guard let list = try? JSONDecoder().decode(PostList.self, from: data) else {
        fatalError("Can not parse post list json data")
    }
    return list
}

func loadImage(name: String) -> Image {
    return Image(uiImage: UIImage(named: name)!)
}
