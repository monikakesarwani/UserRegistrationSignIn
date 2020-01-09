//
//  SignInViewController.swift
//  UserRegistrationExample
//
//  Created by Anil on 1/7/20.
//  Copyright © 2020 kesarwani. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var userNameTextFeild: UITextField!
    @IBOutlet weak var userPasswordTextFeild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        print("sign In Button is pressed")
    }
    
    @IBAction func registerNewAccountButtonPressed(_ sender: UIButton) {
        print("register Account button is pressed")
        
        let registerViewController = storyboard?.instantiateViewController(identifier: "RegisterUserViewController") as! RegisterUserViewController
        self.present(registerViewController, animated: true, completion: nil)
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
