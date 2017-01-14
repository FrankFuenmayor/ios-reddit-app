//
//  ViewController.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tblEntries: RedditEntriesTableView!
    @IBOutlet weak var sgmListing: UISegmentedControl!

    var selectedEntry : RedditEntry?
    let availableListing : [RedditListing] = [.top, .new, .rising]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblEntries.redditDelegate = self;
        
        sgmListing.addTarget(self, action: #selector(changeListing(segmented:)), for: .valueChanged)
    }
    
    func changeListing(segmented:UISegmentedControl){
        tblEntries.selectedListing = availableListing[segmented.selectedSegmentIndex]
    }
}

extension MainViewController : RedditTableViewDelegate {
    func redditEntriesTableView(tableView: RedditEntriesTableView, didSelectEntry entry: RedditEntry) {
        selectedEntry = entry
        performSegue(withIdentifier: "presentRedditDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController;
        let detailViewController = nav.topViewController as? RedditDetailViewController
        detailViewController?.redditEntry = selectedEntry
    }
}
