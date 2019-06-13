//
//  WelcomeViewController.swift
//  ToDo
//
//  Created by tanabe.nobuyuki on 2019/06/11.
//  Copyright © 2019 tanabe.nobuyuki. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "認証", style: .plain, target: self, action: #selector(rightBarButtonDidTap))
    }
    
    
    
    var isNewUser = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Welcome"
        callAuthProcess()
    }
    
    @objc func rightBarButtonDidTap() {
        callAuthProcess()
    }
    
    
    
    func callAuthProcess() {
        let alertController = UIAlertController(title: "Login to Realm Cloud", message: "Supply a nice nickname!", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [unowned self]
            alert -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            let passTextField = alertController.textFields![1] as UITextField
            let creds = SyncCredentials.usernamePassword(username: nameTextField.text!, password: passTextField.text!, register: self.isNewUser)
            
            SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
                if let _ = user {
                    self?.navigationController?.pushViewController(ItemsViewController(), animated: true)
                } else if let error = err {
                    let alert = UIAlertController(title: "\(self!.isNewUser ? "登録" : "ログイン")失敗", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            })
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "A Name for your user"
        })
        
        alertController.addTextField(configurationHandler: { textField -> Void in
            textField.isSecureTextEntry = true
            textField.placeholder = "Enter a password"
        })
        
        let selectableAlertController = UIAlertController(title: "ログイン or 登録", message: "選択してください", preferredStyle: .alert)
        selectableAlertController.addAction(UIAlertAction(title: "登録", style: .default, handler: { [ unowned self] alert -> Void in
            self.isNewUser = true
            self.present(alertController, animated: true, completion: nil)
        }))
        selectableAlertController.addAction(UIAlertAction(title: "ログイン", style: .default, handler: { [unowned self] alert -> Void in
            self.isNewUser = false
            self.present(alertController, animated: true, completion: nil)
        }))
        
        
        
        
        if let _ = SyncUser.current {
            // We have already logged in here!
            self.navigationController?.pushViewController(ItemsViewController(), animated: true)
        } else {
            
            self.present(selectableAlertController, animated: true, completion: nil)
        }
    }
    
    
}
