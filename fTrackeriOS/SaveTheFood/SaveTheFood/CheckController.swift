//
//  CheckController.swift
//  SaveTheFood
//
//  Created by Philip Tam on 2019-01-26.
//  Copyright © 2019 savethefood. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        SVProgressHUD.show()
        guard let image = image else { return }
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        VisionHandler.shared.detect(data: data.base64EncodedString()) { label in
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "The item: \(label ?? "") has been added to your history!")
            SVProgressHUD.dismiss(withDelay: 3)
        }
    }
}
