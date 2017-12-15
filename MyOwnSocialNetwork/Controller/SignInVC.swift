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
import GoogleSignIn

var globalstuff = true

class SignInVC: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate{

    @IBOutlet weak var emailField: FancyText!
    @IBOutlet weak var pwdField: FancyText!
    

    var once = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        if once {
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID){
            print("JESS: ID found in keychain")
            if once {
                once = false
            } else {
                once = true
            }
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
    
    //GMAILLLLL:::
    
    func FirebaseAuth(_ credential:AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("++++++++++++++++Firebase Authentication Error++++++++++++")
            } else {
                print("Authentication completed with Firebase")
                
                let userData = [ "provider": credential.provider ]
                self.completeSignIn(id: (user?.uid)!,userData: userData )

            }
            })
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        if let email = emailField.text ,let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user,error) in
                if error == nil {
                    print("++++++++++++++++++EMail:User authenticated with the Firebase *********+++++++")
                    
                    let userData = ["provider":user?.providerID]
                    
                    self.completeSignIn(id: (user?.uid)!,userData: userData as! Dictionary<String, String>)

                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("+++++++++++Unable to authenticate with Firebase +++++++++")
                        } else {
                            print("ü+++++++++successfully authenticated ++++++++++++")
                            let userData = ["provider":user?.providerID]
                            self.completeSignIn(id: (user?.uid)!,userData: userData as! Dictionary<String, String>)

                        }
                        })
                }
                
            })
        }
    }
    
    func completeSignIn(id: String,userData: Dictionary<String,String> ) {
        DataService.ds.createFirebaseDBUser(id: id, userData: userData)
        let KeychainWrapperResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("The REsult of the keychain wrapper is \(KeychainWrapperResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    
    
    
    
    //Handles the GOGLE sign in process
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print("Some Error\(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        self.FirebaseAuth(credential)
    }
    
    //Just as the stack view guy is telling
    @IBAction func googlePlusButtonTouchUpInside(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()

    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    }
    
    











