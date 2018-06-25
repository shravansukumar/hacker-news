//
//  CommentsViewController.swift
//  hacker-news
//
//  Created by Shravan Sukumar on 23/06/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: - Constants and Variables
    let manager = FirebaseManager()
    var commentIds = [Int]()
    var comments = [String]()
    let cellIdentifier = "plainCell"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigation()
        fetchComments()
    }
    
    // MARK: - Private Methods
    private func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Comments"
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    private func fetchComments() {
        manager.fetchComments(for: commentIds) { [unowned self] snapshot in
            print(snapshot)
            self.extract(comments: snapshot)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func extract(comments: [DataSnapshot]) {
        for comment in comments {
            if let dictionary = comment.value as? [String:Any], let text = dictionary["text"] as? String {
                self.comments.append(text)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as UITableViewCell?
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.attributedText = comments[indexPath.row].htmlAttributedString(size: 11)
        return cell!
    }
}
