

import UIKit

class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextFeild: UITextField!
    @IBOutlet weak var lastNameTextFeild: UITextField!
    @IBOutlet weak var emailAddressTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var repeatPasswordTextFeild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        print("cancel button is pressed")
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("signIn button is pressed")
        
        //validate required field are not empty
        if (firstNameTextFeild.text?.isEmpty)! ||
            (lastNameTextFeild.text?.isEmpty)! ||
            (passwordTextFeild.text?.isEmpty)! ||
            (repeatPasswordTextFeild.text?.isEmpty)!
        {
            
            //Display alert message and return
            displayMassage(userMessage: "All field are required")
            return
        }
        
        
        //vaildate password
        
        if (passwordTextFeild.text?.elementsEqual(repeatPasswordTextFeild.text!) != true)

        {
            
            //Display alert message and return
            displayMassage(userMessage: "All field are required")
            return
        }
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        //position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        //If needed, you can prevent  Activity Indicator from hiding when stopeAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        //start Activity indicator
        myActivityIndicator.startAnimating()
        
        //add view on subview
        view.addSubview(myActivityIndicator )
        
        
        
        //send HTTP Request to Register user
        let myURL = URL(string: "https://localhost:8080/api/users")
        var request = URLRequest(url: myURL!)
        request.httpMethod = "POST"//Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["firstName": firstNameTextFeild.text!,
                          "lastName":  lastNameTextFeild.text!,
                          "userName":  emailAddressTextFeild.text!,
                          "userPassword": passwordTextFeild.text!,
            ] as [String: String]
        
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error{
            print(error.localizedDescription)
            displayMassage(userMessage: "something went wrong. Try again.")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)

            if error != nil{
                self.displayMassage(userMessage: "Could not suessfully perform. please try again later")
                print("Could not suessfully perform.")
                return
            }
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    
                    let userId = parseJSON["userId"] as? String
                    print("userId: \(userId!)")
                    if (userId?.isEmpty)!{
                        self.displayMassage(userMessage: "Could not sueesfully perform this request. Please try again later")
                        return
                    } else{
                        self.displayMassage(userMessage: "sueesfully Register a new account. Please proceed to sign in")
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
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


