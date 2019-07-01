//
//  PhotoTextViewController.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 19/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit

class PhotoTextViewController: UIViewController {
    
    
    
    let imageOld = UIImage(imageLiteralResourceName: "camera")
    @IBOutlet weak var myImageView: UIImageView!
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailsDeckViewController.delegate = self
        myImageView.image = imageOld
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openCamera))
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(gesture)
        
        
        
    }
    
    @IBAction func drawInImage(_ sender: Any) {
        
        performSegue(withIdentifier: "chooseQuote", sender: nil)
        
    }
    
    @objc func openCamera(){
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func viewPhotos(_ sender: Any) {
        
        performSegue(withIdentifier: "viewPhotos", sender: nil)
        
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        let alertController = UIAlertController(title: "Your photo was save", message: nil, preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.savePhotoInFileManager()
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAlertAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func savePhotoInFileManager(){
        let imageName = UUID().uuidString
        print("New PhotoName: \(imageName)")
        let fileManager = FileManager.default
        
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        let image = myImageView.image!
        
        let data = image.pngData()
        
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    func drawText(_ text:String, inImage image:UIImage, atPoint point:CGPoint) -> UIImage{
        let textConverter = text as NSString
        
        let textColor: UIColor = UIColor.white
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 180)!
        
//        let font:UIFont = UIFont.boldSystemFont(ofSize: 150)
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let rect:CGRect = CGRect(x: point.x, y: point.y, width: image.size.width, height: image.size.height)
        
        textConverter.draw(in: rect, withAttributes: [.font:textFont,.foregroundColor:textColor])
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseQuote"{
            let destination = segue.destination as! UINavigationController
            let controller = destination.topViewController as! DecksViewController
            controller.chooseQuote = true
        }
        
    }
}

extension PhotoTextViewController: DetailsDeckViewControllerDelegate{
    func parsingCard(quote: Quote) {
        let text = """
        '\(quote.body)'
        -\(quote.author)
        """
        let image = drawText(text, inImage: myImageView.image!, atPoint: CGPoint(x: 2, y: 2))
        
        myImageView.image = image
    }
   
}

extension PhotoTextViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        
        myImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
}


