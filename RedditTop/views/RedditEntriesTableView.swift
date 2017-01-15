//
//  RedditEntriesTableView.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/13/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import UIKit

///protocolo usado por  RedditEntriesTableView
protocol RedditTableViewDelegate
{
    /**
     * Este metodo es llamado por RedditEntriesTableView cada vez que el usuario selecciona
     * una elemento de la tabla
     */
    func redditEntriesTableView(tableView:RedditEntriesTableView,
                                didSelectEntry entry:RedditEntry);
}

class RedditEntriesTableView: UITableView {
    
    var redditDelegate : RedditTableViewDelegate?
    
    var selectedListing : RedditListing = RedditListing.top {
        didSet {
            load(listing: selectedListing)
        }
    }
    
    var model = RedditEntriesTableViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 100
        
        delegate = self
        dataSource = self
        
        model.delegate = self
    }
    
    /** Este metodo genera un request al Reddit y posteriormente llena la tabla con
     los datos
     */
    func load(listing:RedditListing) {
        model.load(listing: listing)
    }
}

extension RedditEntriesTableView : RedditEntriesTableViewModelDelegate {
    
    func redditEntriesTableViewModelBeginLoad(from: Int) {
        if from == 0 {
            reloadData()
        }
    }
    
    func redditEntriesTableViewModelDidLoad(entries:[RedditEntry],
                                            from:Int,
                                            to:Int) {
        if from == 0 {
            reloadData()
            return
        }
        
        var rows = [IndexPath]()
        
        for row in from...to {
            rows.append(IndexPath(row: row, section: 0))
        }
        
        self.insertRows(at: rows, with: .fade)
    }
}

extension RedditEntriesTableView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //invocar el metodod de reddit delegate
        redditDelegate?.redditEntriesTableView(tableView: self,
                                               didSelectEntry: model.entryAt(index: indexPath.row))
    }
}

// MARK: UIKit metodods necesatios para la vista

extension RedditEntriesTableView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView , numberOfRowsInSection section: Int) -> Int {
        
        if shouldPresentLoadingCell() {
            return 1;
        }
        
        return model.entriesCount();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shouldPresentLoadingCell() {
            return loadingCell()
        } else {
            return entryCell(forRowAt:  indexPath)
        }
    }
    
    func shouldPresentLoadingCell() -> Bool {
        return model.isLoading && model.entriesCount() == 0;
    }

    func entryCell(forRowAt indexPath:IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "redditEntryCell") as! RedditEntryTableViewCell
        cell.setReddit(entry: model.entryAt(index: indexPath.row))
        return cell;
    }

    func loadingCell() -> UITableViewCell {
        let cell =  dequeueReusableCell(withIdentifier: "loadingCell") as! RedditLoadingCellTableViewCell
        cell.setListing(selectedListing)
        return cell
    }        
}


extension RedditEntriesTableView : UIScrollViewDelegate {
    ///Implementacion del pull refresh de la tabla
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let area = self.contentSize.height - self.bounds.size.height;
        let updatePull = self.contentOffset.y >= area
        
        if (updatePull && !model.isLoading) {
            model.loadNextPage()
        }
    }
}
