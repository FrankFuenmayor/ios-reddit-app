//
//  RedditEntriesTableViewModel.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/15/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation

///Delegado para comunicar la tabla y modelo
protocol RedditEntriesTableViewModelDelegate : class {
    
    ///Se llama cuando se carga el modelo
    func redditEntriesTableViewModelDidLoad(_ entries:[RedditEntry],
                                            from:Int,
                                            to:Int)
    
    ///Se llama al solicitar los items al API
    func redditEntriesTableViewModelBeginLoad(_ from:Int)
    
}

class RedditEntriesTableViewModel {
    
    weak var delegate : RedditEntriesTableViewModelDelegate?
    
    fileprivate var redditEntries = [RedditEntry]()
    fileprivate var lastRequest : URLSessionTask?
    fileprivate var currentListing : RedditListing?;
    
    fileprivate(set) var isLoading = false
    
    /**
    Cargar con el listado especifico
     - parameters:
        - listing: el listado a cargar
        - afterEntry: solicitar entradas posteriores a la entrada indicada
    */
    func load(_ listing:RedditListing, afterEntry: RedditEntry? = nil) {
        
        if listing != currentListing {
            redditEntries.removeAll()
        }
        currentListing = listing
        
        let fromIndex = redditEntries.count
        
        let endpoint = RedditEnpoint.endpoint(listing)
        
        if let after = afterEntry {
            endpoint.after(after)
        }
        
        lastRequest = RedditService.service.request(endpoint,
                                                    httpMethod: .get)
        { [unowned self] (endpoint) in
            self.isLoading = false
            self.redditEntries.append(contentsOf: endpoint.getResponse())
            self.delegate?.redditEntriesTableViewModelDidLoad(self.redditEntries,
                                                              from: fromIndex,
                                                              to: fromIndex + (endpoint.getResponse().count - 1))
        }
        isLoading = true
        delegate?.redditEntriesTableViewModelBeginLoad(fromIndex)
        
    }
    
    ///Carga la siguiente pagina
    func loadNextPage(){
        assert(currentListing != nil, "call load(listing:) first")
        load(currentListing!,
             afterEntry: redditEntries.last)
    }
    
    /**
     Cantidad de entradas en el modelo
     - returns: Int: la cantidad de entradas en el modelo
     */
    func entriesCount() -> Int {
        return redditEntries.count
    }
    
    /**
     - parameter index: el indice del item.
     - returns: el item en el indice indicado
     */
    func entryAt(_ index:Int) -> RedditEntry {
        return redditEntries[index]
    }
}
