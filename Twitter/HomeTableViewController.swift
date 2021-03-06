//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Keith Tan on 1/30/19.
//

import UIKit

class HomeTableViewController: UITableViewController {
    let sideMenu = SideMenuViewController()
    
    fileprivate let menuWidth: CGFloat = 300
    fileprivate var isMenuOpened: Bool = false
    
    var tweets = [NSDictionary]()
    var userInfo = NSDictionary()
    var tweetNum: Int!
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuController()
        let panGesture = UIPanGestureRecognizer(target:self, action: #selector(handlePan))
        self.view.addGestureRecognizer(panGesture)
        
        self.tweetNum = 20;
        self.loadTweets();
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    @objc func setupMenuController(){
        //ideMenu.view.backgroundColor = .yellow
        sideMenu.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: self.view.frame.height)
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(sideMenu.view)
        // Must have this so the other view will work
        addChild(sideMenu)
    }
    
    fileprivate func performAnimations(transform:CGAffineTransform){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut,
                       animations: {
                        self.sideMenu.view.transform = transform
                        self.navigationController?.view.transform = transform
        }, completion: nil)
        
        
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.view)
        // Slide menu into the screen
        
        if (gesture.state == .changed) {
            // Adding bounds to movement
            var x = translation.x
            x = min(menuWidth, x)
            x = max(0,x)
            
            if (isMenuOpened == true){
                x+=menuWidth
            }
            
            // Handles the movement
            self.sideMenu.view.transform = CGAffineTransform(translationX: translation.x, y: 0)
            self.navigationController?.view.transform = CGAffineTransform(translationX: translation.x, y: 0)
        }
        else if (gesture.state == .ended){
            handlePanEnd(gesture: gesture)
        }
    }
    
    fileprivate func handlePanEnd(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.view)
        // Check location to figure out movement
        
        if isMenuOpened {
            
            if (abs(translation.x) < menuWidth / 2) {
                handleOpen()
            }
            else {
                handleClose()
            }
            
        }
        else{
            if translation.x < menuWidth / 2{
                handleClose();
            }
            else{
                handleOpen()
            }
            
        }
    }
    
    
    @objc func handleOpen(){
        self.isMenuOpened = true
        self.performAnimations(transform:CGAffineTransform(translationX: self.menuWidth, y: 0))
    }
    
    @objc func handleClose(){
        self.isMenuOpened = false
        self.performAnimations(transform: .identity)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "loggedIn")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadTweets(){
        let URL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": self.tweetNum]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: URL, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweets.removeAll()
            
            for tweet in tweets{
                self.tweets.append(tweet)
            }
            
            self.tableView.reloadData();
            self.myRefreshControl.endRefreshing();
        }, failure: { (Error) in
            print("Error")
        })
    }
    
    func loadMoreTweets(){
        let URL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        self.tweetNum+=20
        let myParams = ["count": self.tweetNum]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: URL, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweets.removeAll()
            
            for tweet in tweets{
                self.tweets.append(tweet)
            }
            
            self.tableView.reloadData();
        }, failure: { (Error) in
            print("Error")
        })


    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell" ,for: indexPath) as! TweetCell
        
        
        
        cell.tweetLabel.text = tweets[indexPath.row]["text"] as? String
        
        let user = tweets[indexPath.row]["user"] as! NSDictionary
        
        cell.usernameLabel.text = user["name"] as? String
        
        // Different way of setting an image alternatively from AlamofireImage
        
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweets[indexPath.row]["favorited"] as! Bool)
        cell.tweetID = tweets[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweets[indexPath.row]["retweeted"] as! Bool)
        
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweets.count{
            loadMoreTweets();
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
