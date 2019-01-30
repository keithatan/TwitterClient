//
//  LoginViewController.swift
//  Twitter
//
//  Created by Keith Tan on 1/28/19.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        
        let loginURL = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: loginURL, success: {
            UserDefaults.standard.set(true, forKey: "loggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            print ("Failed")
        })
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
