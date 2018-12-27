//
//  SentMemesCollectionViewController.swift
//  MemeMe1.0
//
//  Created by MAC on 02/12/2018.
//  Copyright © 2018 Dan. All rights reserved.
//

import Foundation
import UIKit


class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "SentMemes", style: .plain, target: nil, action: nil)
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView!.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let currentMeme: Meme = memes[indexPath.row]
        cell.memeImage.image = currentMeme.memedImage
        
        return cell 
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)as! MemeCollectionViewCell
        let destination = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        destination.passedImage.image = cell.memeImage.image
        navigationController?.pushViewController(destination, animated: true)
    }
    
     @objc func addMeme(_ sender: Any) {
        
        let memeController: MemeViewController = self.storyboard?.instantiateViewController(withIdentifier:"MemeVC") as! MemeViewController
        memeController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeController, animated: true)
    }

}
