//
//  ViewController.swift
//  DBExample
//
//  Created by Shivaji Tanpure on 22/05/18.
//  Copyright © 2018 Shivaji Tanpure. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    let dbmanager = DBManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        dbmanager.createDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionLogin(_ sender: Any) {
        
        dbmanager.saveData(name:textUserName.text!, password:textPassword.text!)
        //OR
        //dbmanager.insert(name:textUserName.text!, password:textPassword.text!)
        dbmanager.readData()
    }

}

