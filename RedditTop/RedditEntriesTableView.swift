//
//  RedditEntriesTableView.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/13/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import UIKit

protocol RedditTableViewDelegate
{
    func redditEntriesTableView(tableView:RedditEntriesTableView,
                                didSelectEntry entry:RedditEntry);
}


class RedditEntriesTableView: UITableView {

    var redditDelegate : RedditTableViewDelegate?
    
    var redditEntries = [RedditEntry]()
    var pageSize    = 10
    
    var isLoading : Bool = false
    var lastRequest : URLSessionTask?
    
    
    var selectedListing : RedditListing = RedditListing.top {
        didSet(listing){
            lastRequest?.cancel()
            redditEntries.removeAll()
            reloadData()
            load(listing: listing)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentInset = UIEdgeInsets.zero
        
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 100
        
        delegate = self
        dataSource = self
        
        load(listing: .top)
    }
    
    func load(listing:RedditListing) {
        
        if(isLoading){
            return;
        }
        
        isLoading = true
        
        let firstLoad = redditEntries.count  == 0
        
        let topEndpoint = RedditEnpoint.endpoint(listing: selectedListing)
        
        lastRequest = RedditService.service.request(endpoint: topEndpoint,
                                                    httpMethod: .get)
        { [unowned self] (top) in
            self.isLoading = false
            let from = self.redditEntries.count;
            self.redditEntries.append(contentsOf: top.getResponse())
            
            if firstLoad {
                self.reloadData()
            } else {
                var rows = [IndexPath]()
                for row in from..<self.redditEntries.count {
                    rows.append(IndexPath(row: row, section: 0))
                }
                print(rows)
                self.insertRows(at: rows, with: .fade)
            }
        }
    }
}

extension RedditEntriesTableView : UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView , numberOfRowsInSection section: Int) -> Int {
        return redditEntries.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "redditEntryCell") as? RedditEntryTableViewCell
        cell?.setReddit(entry: self.redditEntries[indexPath.row])
        return cell!;
    }
}

extension RedditEntriesTableView : UITableViewDelegate {    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        redditDelegate?.redditEntriesTableView(tableView: self,
                                               didSelectEntry: redditEntries[indexPath.row])
    }
}

extension RedditEntriesTableView : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let area = self.contentSize.height - self.bounds.size.height;
        let updatePull = self.contentOffset.y >= area
        
        if (updatePull) {
            load(listing: selectedListing)
        }
    }
}
