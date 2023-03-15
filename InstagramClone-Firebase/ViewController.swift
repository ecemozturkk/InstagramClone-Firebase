//
//  ViewController.swift
//  InstagramClone-Firebase
//
//  Created by Ecem Öztürk on 13.03.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    // MARK: Kullanıcı girişi
    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { auth, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Please enter your username and password.")
        }
    }
    //MARK: Yeni kullanıcı kayıt
    @IBAction func signUpClicked(_ sender: Any) {
        // email ve şifre var mı kontrolü
        if emailText.text != "" && passwordText.text != "" {
            //Auth sınıfından auth objesi oluşturur
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error") //localizedDescription = Firebase'in hata mesajı
                } else { //kullanıcının başarılı bir şekilde oluşturulması
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput:"Error", messageInput:"Please enter your username and password.")
        }
        
        
    }
    // MARK: Alert pop-up'ı
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

