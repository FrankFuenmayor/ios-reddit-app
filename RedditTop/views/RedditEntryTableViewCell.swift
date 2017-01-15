//
//  RedditEntryTableViewCell.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import UIKit

///Celda utilizada para presentar las distintas entradas en la tabla.
class RedditEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    @IBOutlet weak var lblSubReddit: UILabel!
    @IBOutlet weak var lblComentarios: UILabel!
    
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    
    let dateFormatter = DateFormatter()
    
    func setReddit(entry:RedditEntry) -> Void {
        
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        
        lblTitle.text = entry.title
        lblAuthor.text = entry.author
        lblComentarios.text = "Comentarios \(entry.commentCount!)"
        lblSubReddit.text = entry.subReddit?.uppercased()
        imgThumbnail.image = nil;
        lblFecha.text = string(from: entry.creationDate!)
        imgWidth.constant = 0
        
        
        
        if let thumbnailUrl = entry.thumbnail {
            imgWidth.constant = 100
            imgThumbnail.setImageWith(thumbnailUrl);
        }
    }
    
    func string(from date:Date) -> String {
        
        let components = Set<Calendar.Component>([Calendar.Component.day,
                          Calendar.Component.hour,
                          Calendar.Component.minute])
        var dateCmp = Calendar.current.dateComponents(components, from: date, to: Date())
        
        if let days = dateCmp.day,
            days == 0 {
            if let hour = dateCmp.hour, let minute = dateCmp.minute {
                if hour == 0 {
                    return "Hace \(abs(minute)) min\(abs(minute) > 0 ? "s":"" )"
                } else {
                    return "Hace \(abs(hour)) hora\(abs(hour) > 0 ? "s":"")"
                }
            }
        }
        
        return dateFormatter.string(from: date)
    }
}
