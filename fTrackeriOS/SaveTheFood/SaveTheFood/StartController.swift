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
        
           setupNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func cameraPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToCamera", sender: self)
    }
    
    func setupNav() {
        
        
        guard let nav = navigationController else {return}
        
        nav.navigationBar.layer.masksToBounds = false
        nav.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        nav.navigationBar.layer.shadowOpacity = 0.8
        nav.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        nav.navigationBar.layer.shadowRadius = 2
        
        nav.navigationBar.barTintColor = UIColor(hexString: "FFE7FE")
        nav.navigationBar.tintColor = UIColor.black
        
        guard let font = UIFont(name: "Helvetica", size: 21) else {return}
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "FFE7FE"), NSAttributedString.Key.font: font as Any]
        nav.navigationBar.titleTextAttributes = textAttributes
        
        
    }
    
}

