//
//  CheckController.swift
//  SaveTheFood
//
//  Created by Philip Tam on 2019-01-26.
//  Copyright © 2019 savethefood. All rights reserved.
//

import UIKit

class CheckController: UIViewController {

    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.flatWhite()
        // Do any additional setup after loading the view.
        self.imageView.image = image
        self.navigationItem.title = "Check"
    }
    
    @IBAction func runProcess(_ sender: Any) {
        guard let image = image else { return }
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        VisionHandler.shared.detect(data: data.base64EncodedString()) { label in
            self.presentAlert(label: label ?? "")
        }
    }

    func presentAlert(label: String) {
        let alert = UIAlertController(title: "Sent", message: "The item: \(label) has been added to your history!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss",style: .cancel, handler: { (_) in
            
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    

}
