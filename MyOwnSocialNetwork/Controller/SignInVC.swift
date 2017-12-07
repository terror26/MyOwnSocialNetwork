//
//  ViewController.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 04/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper
class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyText!
    @IBOutlet weak var pwdField: FancyText!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID){
            print("JESS: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    @IBAction func facebookBtnPressed(_ sender: AnyObject) {
    
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self){
            (result,error) in
            if error != nil {
                print("++++++++++++++++++Not Able To authenticate with the facebook+++++++++++")
            } else if result?.isCancelled == true {
                print("+++++++++++++USer Cancelled the Facebook Authentication++++++++++++++++")
            } else {
                print("+++++++++++++++++++++++++++++++Authenticated Successfully++++++++++++++")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.FirebaseAuth(credential)
            }
        }
    }
    
    func FirebaseAuth(_ credential:AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("++++++++++++++++Firebase Authentication Error++++++++++++")
            } else {
                print("Authentication completed with Firebase")
                self.completeSignIn(id: (user?.uid)!)
            }
            })
    }
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        if let email = emailField.text ,let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user,error) in
                if error == nil {
                    print("++++++++++++++++++EMail:User authenticated with the Firebase *********+++++++")
                    self.completeSignIn(id: (user?.uid)!)

                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("+++++++++++Unable to authenticate with Firebase +++++++++")
                        } else {
                            print("ü+++++++++successfully authenticated ++++++++++++")
                            self.completeSignIn(id: (user?.uid)!)

                        }
                        })
                }
                
            })
        }
    }
    
    func completeSignIn(id: String) {
        let KeychainWrapperResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("The REsult of the keychain wrapper is \(KeychainWrapperResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}












