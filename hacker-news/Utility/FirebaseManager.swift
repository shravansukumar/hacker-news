//
//  FirebaseManager.swift
//  hacker-news
//
//  Created by Shravan Sukumar on 23/06/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    // MARK: - Constants and Variables
    fileprivate let rootReference = Database.database(url: "https://hacker-news.firebaseio.com/").reference().child("v0/topstories").queryLimited(toFirst: 50)
    fileprivate let itemReference = Database.database(url: "https://hacker-news.firebaseio.com/").reference().child("v0/item")
    fileprivate var storiesSnapshot = [DataSnapshot]()
    fileprivate var commentsSnapshot = [DataSnapshot]()
    
    // MARK: - Public Methods
    func fetchHackerNews(_ callback: @escaping ([DataSnapshot])->()) {
        Database.database().goOnline()
        rootReference.observeSingleEvent(of: .value) { snapshot in
            let storyId = snapshot.value as! [Int]
            for id in storyId {
                self.itemReference.child("\(id)").observeSingleEvent(of: .value) { snap in
                    self.storiesSnapshot.append(snap)
                    if self.storiesSnapshot.count == 50 {
                        callback(self.storiesSnapshot)
                    }
                }
            }
        }
    }
    
    func fetchComments(for ids: [Int], _ callback: @escaping ([DataSnapshot])->()) {
        commentsSnapshot.removeAll()
        print(ids.count)
        print(ids)
        for id in ids {
            itemReference.child("\(id)").observeSingleEvent(of: .value) { snapshot in
                self.commentsSnapshot.append(snapshot)
                print(self.commentsSnapshot.count)
                if self.commentsSnapshot.count == ids.count {
                    callback(self.commentsSnapshot)
                }
            }
        }
    }
}
