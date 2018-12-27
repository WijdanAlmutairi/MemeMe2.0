//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by MAC on 08/12/2018.
//  Copyright © 2018 Dan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var passedImage = UIImageView()
    @IBOutlet weak var imageDetail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageDetail.image = passedImage.image
    }
    

}
