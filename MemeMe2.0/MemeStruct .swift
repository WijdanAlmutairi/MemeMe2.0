//
//  MemeStruct .swift
//  MemeMe1.0
//
//  Created by MAC on 17/11/2018.
//  Copyright © 2018 Dan. All rights reserved.
//

import Foundation
import UIKit


struct Meme {
    var topTextString: String
    var bottomTextString: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topTextString: String, bottomTextString: String, originalImage: UIImage, memedImage:UIImage){
        self.topTextString = topTextString
        self.bottomTextString = bottomTextString
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
