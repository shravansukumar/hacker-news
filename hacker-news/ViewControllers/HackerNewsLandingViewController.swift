//
//  HackerNewsLandingViewController.swift
//  hacker-news
//
//  Created by Shravan Sukumar on 23/06/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SafariServices

class HackerNewsLandingViewController: UITableViewController {
    
    // MARK: - Constants and Variables
    let manager = FirebaseManager()
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "plainCell"
    var stories = [Story]()
    var searchedStories = [Story]()
    var isSearching = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logout()
        setupNavigation()
        fetchNews()
        setupSearchBar()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Private Methods
    private func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
            
        }
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "News"
        navigationItem.largeTitleDisplayMode = .always
//        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationController?.navigationItem.leftBarButtonItem = nil
    }
    
    private func fetchNews() {
        manager.fetchHackerNews() { [unowned self] items in
            self.extract(stories: items)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true
        navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func extract(stories: [DataSnapshot]) {
        let storiesCopy = stories.filter { ($0.value as? [String:Any])!["type"] as? String == "story" }
        for story in storiesCopy {
            let value = story.value as! [String:Any]
            self.stories.append(Story.init(id: value["id"] as! Int, title: value["title"] as! String, url: value["url"] as? String, by: value["by"] as! String, score: value["score"] as! Int, commentIds: value["kids"] as? [Int]))
        }
    }
    
    private func handleTap(of selectedStory: Story) {
        var commentsExists = false
        var linkExists = false
        if let commments = selectedStory.commentIds, commments.count > 0 {
            commentsExists = true
        }
        if let url = selectedStory.url, url.count > 0 {
            linkExists = true
        }
        if linkExists && commentsExists {
            showActionSheet(selectedStory)
        } else if linkExists {
            open(link: selectedStory.url!)
        } else if commentsExists {
            showComments(for: selectedStory)
        }
    }
    
    private func showActionSheet(_ story: Story) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let openLinkButton = UIAlertAction(title: "Open Link...", style: .default) { action in
            self.open(link: story.url!)
        }
        let commentsButton = UIAlertAction(title: "Show Comments", style: .default) { action in
            self.showComments(for: story)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(openLinkButton)
        actionSheet.addAction(commentsButton)
        actionSheet.addAction(cancelButton)
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    private func open(link: String) {
        let webViewController = SFSafariViewController(url: URL(string: link)!)
        webViewController.delegate = self
        present(webViewController, animated: true, completion: nil)
    }
    
    private func showComments(for story: Story) {
        let commentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "commentsViewController") as! CommentsViewController
            commentViewController.commentIds = story.commentIds!
            self.navigationController?.pushViewController(commentViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HackerNewsLandingViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchedStories.count : stories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as UITableViewCell?
        let story = isSearching ? searchedStories[indexPath.row] : stories[indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text = story.title
        cell?.detailTextLabel?.text = "\(story.score) points by \(story.by) (\(story.commentIds?.count ?? 0) comments)"
        return cell!
    }
}

// MARK: - UITableViewDelegate
extension HackerNewsLandingViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStory = isSearching ? searchedStories[indexPath.row] : stories[indexPath.row]
        handleTap(of: selectedStory)
    }
}

// MARK: - UISearchResultsUpdating
extension HackerNewsLandingViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.count > 0 {
                isSearching = true
                searchedStories = stories.filter { $0.title.range(of: searchText, options: .caseInsensitive) != nil }
                tableView.reloadData()
            } else {
                isSearching = false
                tableView.reloadData()
                searchedStories.removeAll()
            }
        }
    }
}

// MARK: - SFSafariViewControllerDelegate
extension HackerNewsLandingViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
