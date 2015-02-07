//
//  ViewController.swift
//  OnOffButton
//
//  Created by Aristóteles on 10/11/14.
//  Copyright (c) 2014 Rafael Machado. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func changeButtonState(sender: OnOffButton) {
        sender.checked = !sender.checked
    }
}