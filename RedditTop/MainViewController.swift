//
//  ViewController.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tblEntries: UITableView!
    
    var redditEntries : [RedditEntry] = [RedditEntry]()
    var pageSize    = 10
    var currentPage = 0
    
    var loadingPage : Int = -1
    
    let refreshControl = UIRefreshControl()
    
    var selectedEntry : RedditEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblEntries.rowHeight = UITableViewAutomaticDimension
        tblEntries.estimatedRowHeight = 100
        
        refreshControl.addTarget(self,
                                 action: #selector(loadEntries),
                                 for: .valueChanged)
        
        tblEntries.addSubview(refreshControl)
        
        loadEntries()
    }
    
    func loadEntries() {
        
        if(currentPage == loadingPage){
            refreshControl.endRefreshing()
            return;
        }
        
        loadingPage = currentPage
        
        let count = currentPage * pageSize;
        let limit = count + pageSize
        
        let topEndpoint = RedditTopEndpoint(count: count, limit: limit)
        
        let dataTask = RedditService.service.request(endpoint: topEndpoint,
                                      httpMethod: .get)
        { [unowned self, weak table = tblEntries] (top) in
            
            self.redditEntries.append(contentsOf: top.getResponse())
            
            table!.reloadData();
            self.loadingPage = -1;
        }
        
        refreshControl.setRefreshingWithStateOf(dataTask)
    }
    
}

extension MainViewController : UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.redditEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "redditEntryCell") as? RedditEntryTableViewCell
        cell?.setReddit(entry: redditEntries[indexPath.row])
        return cell!;
    }
}

extension MainViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry = redditEntries[indexPath.row]
        performSegue(withIdentifier: "presentRedditDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController;
        let detailViewController = nav.topViewController as? RedditDetailViewController
        detailViewController?.redditEntry = selectedEntry
    }
}



