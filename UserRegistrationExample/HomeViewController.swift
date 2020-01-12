

import UIKit
import SwiftKeychainWrapper

class HomeViewController: UIViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "userId")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = homePage
    }
    
    
    @IBAction func loadMemberProfile(_ sender: UIButton) {
        
        loadMemberProfile()
    }
    
    func loadMemberProfile(){
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let userId: String? = KeychainWrapper.standard.string(forKey: "userId")
        
        //send HTTP Request to Register user
        let myURL = URL(string: "http://localhost:8080/api/users")
        var request = URLRequest(url: myURL!)
        request.httpMethod = "GET" //Compose a query string
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Aurthorization")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil
            {
                self.displayMassage(userMessage: "Could not suessfully perform this request. Please try later.")
            }
        }
        do {
            
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
            if let parseJSON = json {
                
                DispatchQueue.main.async {
                    let firstName: String? = parseJSON["firstName"] as? String
                    let lastName: String? = parseJSON["lastName"] as? String
                    
                    if firstName?.isEmpty != true && lastName?.isEmpty != true{
                        self.fullNameLabel.text = firstName! + "" + lastName!
                        
                    }else{
                        self.displayMassage(userMessage: "Could not successfully perform this reuest. Please try again later.")
                    }
                } 
                
            }
        } catch{
            
            self.displayMassage(userMessage: "Could not suessfully perform. please try again later")
            print("Error")
        }
        
        task.resume()
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
