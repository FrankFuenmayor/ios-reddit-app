//
//  RedditDetailViewController.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/13/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import UIKit

class RedditDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var redditEntry : RedditEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: redditEntry!.url!))    
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))

    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
