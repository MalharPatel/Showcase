//
//  PostCell.swift
//  Showcase
//
//  Created by Malhar Patel on 8/16/16.
//  Copyright © 2016 Malhar Patel. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    
    var post: Post!
    var request: Request?
    var likeRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.userInteractionEnabled = true
        
        
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }

    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        
        self.descriptionText.text = post.postDesc
        self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            self.showcaseImg.hidden = false
            if img != nil {
                self.showcaseImg.image = img
            } else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"])
                    .response(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) in
                        if error == nil {
                            let img = UIImage(data: data!)!
                            self.showcaseImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                        } else {
                            print(error.debugDescription)
                        }
                })
            }
        } else {
            self.showcaseImg.hidden = true
        }
        
        likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heart-empty")
            } else {
                self.likeImg.image = UIImage(named: "heart-full")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
        })
    }
    
    

}
