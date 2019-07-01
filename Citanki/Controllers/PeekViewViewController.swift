//
//  PeekViewViewController.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 23/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit

class PeekViewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image{
            self.imageView.image = image
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
