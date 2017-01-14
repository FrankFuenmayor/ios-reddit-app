//
//  Entry.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation

struct RedditEntry : CustomStringConvertible {

    var author : String?
    var title : String?
    var creationDate : Date?
    var thumbnail : URL?
    var subReddit : String?
    var commentCount : Int?
    var url:URL?
    var name:String?
    
    var description: String {
        return "author: \(author), title: \(title), creationDate: \(creationDate), thumbnail: \(thumbnail),  commentCount: \(commentCount), subReddit: \(subReddit), name: \(name)"
    }
    
    init(author:String?,
         title:String?,
         creationDate:Date?,
         thumbnail:URL?,
         subReddit:String?,
         commentCount:Int?,
         url:URL?,
         name:String?) {
        
        self.title = title
        self.author = author
        self.creationDate = creationDate
        self.commentCount = commentCount
        self.subReddit = subReddit
        self.thumbnail = thumbnail?.scheme != nil ? thumbnail : nil
        self.url = url?.scheme != nil ? url : nil
        self.name = name
    }
    
    static func redditEntry(fromJson jsonObject:Any?) -> RedditEntry {
        assert(jsonObject is [String:AnyObject], "Invalid JSON Object")
        
        let data = jsonObject as! [String:AnyObject]
        
        let thumbnail = URL(string: data["thumbnail"] as? String ?? "")
        let url       = URL(string: data["url"] as? String ?? "")
        
        let entry = RedditEntry(
            author: data["author"] as? String,
            title: data["title"] as? String,
            creationDate: Date(),
            thumbnail: thumbnail,
            subReddit: data["subreddit"] as? String,
            commentCount: data["num_comments"] as? Int,
            url: url,
            name:data["name"] as? String)
        
        return entry
    }
    
}
