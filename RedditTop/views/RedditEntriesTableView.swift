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
    
    var redditEntries = [RedditEntry]()
    var pageSize    = 10
    
    var lastRequest : URLSessionTask?
    
    var selectedListing : RedditListing = RedditListing.top {
        didSet(listing){
            changeTo(listing: listing)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 100
        
        delegate = self
        dataSource = self
    }
    
    /** Este metodo genera un request al Reddit y posteriormente llena la tabla con
     los datos
     */
    func load(listing:RedditListing) {
        
        let firstLoad = redditEntries.count  == 0
        let topEndpoint = RedditEnpoint.endpoint(listing: selectedListing)
        
        lastRequest = RedditService.service.request(endpoint: topEndpoint,
                                                    httpMethod: .get)
        { [unowned self] (top) in
            self.load(entries: top.getResponse(), replace: firstLoad)
        }
    }
    
    /** este metodo llena el modelo con el arreglo y refresca la tabla 
     de manera apropiada
     */
    func load(entries newEntries:[RedditEntry], replace:Bool = true){
        
        if replace {
            redditEntries.removeAll()
            redditEntries.append(contentsOf: newEntries)
            reloadData()
            return
        }
        
        let from = redditEntries.count;
        redditEntries.append(contentsOf: newEntries)
        
        var rows = [IndexPath]()
        for row in from..<self.redditEntries.count {
            rows.append(IndexPath(row: row, section: 0))
        }
        
        self.insertRows(at: rows, with: .fade)
    }
    
    /** Cancela cualquier solicitud actual si existe una, limpia el modelo
     y llama a load(listing) para cargar la tabla con nueva informacion
    */
    private func changeTo(listing:RedditListing){
        
        let shouldCancel = lastRequest?.state != .completed && lastRequest?.state != .canceling
        
        if shouldCancel {
            lastRequest?.cancel()
        }
        redditEntries.removeAll()
        reloadData()
        load(listing: listing)
    }
}

extension RedditEntriesTableView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //invocar el metodod de reddit delegate
        redditDelegate?.redditEntriesTableView(tableView: self,
                                               didSelectEntry: redditEntries[indexPath.row])
    }
}

// MARK: UIKit metodods necesatios para la vista

extension RedditEntriesTableView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView , numberOfRowsInSection section: Int) -> Int {
        
        let loadingCell = lastRequest?.state == URLSessionTask.State.running ? 1 : 0
        
        return redditEntries.count + loadingCell;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isLodiadingCellIndex = indexPath.row == redditEntries.count
        
        if isLodiadingCellIndex {
            return tableView.dequeueReusableCell(withIdentifier: "loadingCell")!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "redditEntryCell") as! RedditEntryTableViewCell
        cell.setReddit(entry: self.redditEntries[indexPath.row])
        return cell;
    }
}


extension RedditEntriesTableView : UIScrollViewDelegate {
    ///Implementacion del pull refresh de la tabla
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let area = self.contentSize.height - self.bounds.size.height;
        let updatePull = self.contentOffset.y >= area
        
        if (updatePull) {
            load(listing: selectedListing)
        }
    }
}
