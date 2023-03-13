//
//  SettingsViewController.swift
//  InstagramClone-Firebase
//
//  Created by Ecem Öztürk on 13.03.2023.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
}
