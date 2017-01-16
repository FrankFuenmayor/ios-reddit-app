//
//  RedditEntriesTableViewModel.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/15/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation

protocol RedditEntriesTableViewModelDelegate : class {
    
    func redditEntriesTableViewModelDidLoad(entries:[RedditEntry],
                                            from:Int,
                                            to:Int)
    
    func redditEntriesTableViewModelBeginLoad(from:Int)
    
}

class RedditEntriesTableViewModel {
    
    weak var delegate : RedditEntriesTableViewModelDelegate?
    
    private var redditEntries = [RedditEntry]()
    private var lastRequest : URLSessionTask?
    private var currentListing : RedditListing?;
    
    private(set) var isLoading = false
    
    func load(listing:RedditListing, afterEntry: RedditEntry? = nil) {
        
        if listing != currentListing {
            redditEntries.removeAll()
        }
        currentListing = listing
        
        let fromIndex = redditEntries.count
        
        let endpoint = RedditEnpoint.endpoint(listing: listing)
        
        if let after = afterEntry {
            endpoint.after(entry: after)
        }
        
        lastRequest = RedditService.service.request(endpoint: endpoint,
                                                    httpMethod: .get)
        { [unowned self] (endpoint) in
            self.isLoading = false
            self.redditEntries.append(contentsOf: endpoint.getResponse())
            self.delegate?.redditEntriesTableViewModelDidLoad(entries: self.redditEntries,
                                                              from: fromIndex,
                                                              to: fromIndex + (endpoint.getResponse().count - 1))
        }
        isLoading = true
        delegate?.redditEntriesTableViewModelBeginLoad(from: fromIndex)
        
    }
    
    func loadNextPage(){
        assert(currentListing != nil, "call load(listing:) first")
        load(listing: currentListing!,
             afterEntry: redditEntries.last)
    }
    
    func entriesCount() -> Int {
        return redditEntries.count
    }
    
    func entryAt(index:Int) -> RedditEntry {
        return redditEntries[index]
    }
}
