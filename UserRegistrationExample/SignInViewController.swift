//
//  SignInViewController.swift
//  UserRegistrationExample
//
//  Created by Anil on 1/7/20.
//  Copyright © 2020 kesarwani. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class SignInViewController: UIViewController {
    
    @IBOutlet weak var userNameTextFeild: UITextField!
    @IBOutlet weak var userPasswordTextFeild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
       
        
        //read values from text fields
        var userName = userNameTextFeild.text
        var userPassword = userPasswordTextFeild.text
        
        //check if required fields are empty
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            //Display alert message here
            displayMassage(userMessage: "Required field is missing")
            print("User name \(String(describing: userName)) or passwor \(String(describing: userPassword)) is empty")
        }
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        //position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        //If needed, you can prevent  Activity Indicator from hiding when stopeAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        //start Activity indicator
        myActivityIndicator.startAnimating()
        //add view on subview
        view.addSubview(myActivityIndicator )
        
        //send HTTP Request to Register user
        let myURL = URL(string: "http://localhost:8080/api/users")
        var request = URLRequest(url: myURL!)
        request.httpMethod = "POST"//Compose a query string
        
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["userName":      userName!,
                          "userPassword":   userPassword!
                        ] as [String: String]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error{
            print(error.localizedDescription)
            removeActivityIndicator(activityIndicator: myActivityIndicator)
            displayMassage(userMessage: "something went wrong. Try again.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            //we have remove activity indicator
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil{
                self.displayMassage(userMessage: "Could not suessfully perform this request. please try again later")
                print("Could not suessfully perform.")
                return
            }
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    //Now we can access value of First Name by its Key
                    let accessToken = parseJSON["token"] as? String
                    let userId = parseJSON["id"] as? String
                    print("Access token: \(String(describing: accessToken!))")
                    
                    //Add a string value to keychain:
                    let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                    
                    let saveUserId: Bool = KeychainWrapper.standard.set(userId!, forKey: "userId")
                    
                    print("The access token save result \(saveAccessToken)")
                    print("The user Id save result \(saveUserId)")

                    
                    if (accessToken?.isEmpty)!
                    {
                        //Display an Alert dialog with a friendly error message
                        self.displayMassage(userMessage: "Could not sueesfully perform this request. Please try again later")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homePage
                    }
                    
                    
                } else {
                    self.displayMassage(userMessage: "sueesfully Register a new account. Please proceed to sign in")
                }
                
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    @IBAction func registerNewAccountButtonPressed(_ sender: UIButton) {
        print("register Account button is pressed")
        
        let registerViewController = storyboard?.instantiateViewController(identifier: "RegisterUserViewController") as! RegisterUserViewController
        self.present(registerViewController, animated: true, completion: nil)
    }
    
    
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
        }
    }
    
    func displayMassage(userMessage: String) -> Void{
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            //add action with UIAlert. If I click hit it print something
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                DispatchQueue.main.async{
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }
    
}
