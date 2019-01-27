//
//  ViewController.swift
//  SaveTheFood
//
//  Created by Philip Tam on 2019-01-26.
//  Copyright © 2019 savethefood. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class StartController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func cameraPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToCamera", sender: self)
    }
    
}

