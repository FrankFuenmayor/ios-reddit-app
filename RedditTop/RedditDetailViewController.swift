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
    @IBOutlet weak var btnClose: UIBarButtonItem!
    @IBOutlet weak var btnShare: UINavigationItem!
    
    var redditEntry : RedditEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: redditEntry!.url!))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cerrar",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(shareAction))                
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func shareAction() {
        let activities = [
            UIActivityType.message,
            UIActivityType.postToFacebook,
            UIActivityType.postToTwitter,
        ]
        
        let activityViewController = UIActivityViewController.init(activityItems: activities,
                                                     applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
}
