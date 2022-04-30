//
//  EventDetailsViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/13/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EventDetailsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var PostTextlabel: UITextField!
    @IBOutlet weak var PostTV: UITableView!
    @IBOutlet weak var EventDescriptionLable: UILabel!
    @IBOutlet weak var EventLocationLabel: UILabel!
    @IBOutlet weak var EventDateLabel: UILabel!
    @IBOutlet weak var EventNameLable: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var event : Event!
    var posts: [Post] = []
    var ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.FormatLook(self)
        EventNameLable.text = event.eventName
        EventDateLabel.text = event.date
        EventLocationLabel.text = event.location
        EventDescriptionLable.text = event.description
        PostTV.delegate = self
        PostTV.dataSource = self
        ObservePosts()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    //MARK: Making and Reading Post
    func ObservePosts(){
        let postRef = Database.database().reference().child("chatRoom/\(event.id)/post")
        
        postRef.observe(.value) { [weak self] snapShot in
            var tempPost = [Post]()
            
            for child in snapShot.children{
                if let childrenSnapShot = child as? DataSnapshot,
                   let dict = childrenSnapShot.value as? [String:Any],
                   let postAuthor = dict["postAuthor"] as? String,
                   let postText = dict["postText"] as? String,
                   let posterUID = dict["posterUID"] as? String
                {
                    let post = Post(childrenSnapShot.key, postText, postAuthor, posterUID)
                    tempPost.append(post)
                }
                
            }
            
            self?.posts = tempPost
            self?.PostTV.reloadData()
        }
        
    }
    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        if PostTextlabel != nil{
            let postText = PostTextlabel.text
            let postAuthor = Auth.auth().currentUser!.displayName
            let posterUID = Auth.auth().currentUser!.uid
            
            guard let key = Database.database().reference().child("events/\(event.id)").childByAutoId().key else{ return}
            
            let PostObject = [
                "postAuthor" : postAuthor!,
                "postText" : postText!,
                "posterUID" : posterUID
            ] as [String : Any]
            
            let childUpdate = ["chatRoom/\(event.id)/post/\(key)" : PostObject,
                               "users/profile/\(posterUID)/chatRooms/\(event.id)/post/\(key)": PostObject]
            ref.updateChildValues(childUpdate) { [weak self] Error, ref in
                if Error != nil{
                    print(Error!.localizedDescription)
                }
                else{
                    self?.PostTextlabel.text = nil
                    self?.PostTV.reloadData()
                }
            }
        }
    }
    
    //MARK: Keyboard
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -300 // Move view 300 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension EventDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post_cell", for: indexPath) as! PostTableViewCell
        cell.set(post: posts[indexPath.row])
        if indexPath.row % 2 == 0{
            cell.view.backgroundColor = UIColor(rgb:  0x5398c5 )
        }
        else{
            cell.view.backgroundColor = UIColor(rgb: 0x977096)
        }
        
        return cell
    }
    
    
    
}
