//
//  Story.swift
//  hacker-news
//
//  Created by Shravan Sukumar on 23/06/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation


struct Story {
    var id: Int
    var title: String
    var url: String?
    var by: String
    var score: Int
    var commentIds: [Int]?
    
    init(id: Int, title: String, url: String?, by: String, score: Int, commentIds: [Int]?) {
        self.id = id
        self.title = title
        self.url = url
        self.by = by
        self.score = score
        self.commentIds = commentIds
    }
}
