//
//  SentMemesTableViewController.swift
//  MemeMe1.0
//
//  Created by MAC on 02/12/2018.
//  Copyright © 2018 Dan. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "SentMemes", style: .plain, target: nil, action: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 124 // Set maximum height needed for the table row
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView!.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let currentMeme: Meme = memes[indexPath.row]
        cell.imageView?.image = currentMeme.memedImage
        cell.textLabel?.text = "\(currentMeme.topTextString)...\(currentMeme.bottomTextString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let destination = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        destination.passedImage.image = cell.imageView?.image
        navigationController?.pushViewController(destination, animated: true)
    }
    
   @objc func addMeme(_ sender: Any) {
        
        let memeController: MemeViewController = self.storyboard?.instantiateViewController(withIdentifier:"MemeVC") as! MemeViewController
            memeController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(memeController, animated: true)
    }
    
}


 
