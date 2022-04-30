//
//  PostTableViewCell.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/28/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var PostTextLabel: UILabel!
    @IBOutlet weak var AuthorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    weak var post: Post?
    
    func set(post: Post){
        self.post = post
        AuthorLabel.text = post.Author
        PostTextLabel.text = post.postText
    }
    
}
