//
//  PhotosViewController.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 23/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var images:[UIImage] = []
    var shakeEnabled: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        shakeEnabled = false
        
        let nibCell = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        
        collectionView.register(nibCell, forCellWithReuseIdentifier: "cell")
        if self.traitCollection.forceTouchCapability == .available{
            registerForPreviewing(with: self, sourceView: collectionView)
        }
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCells))
        navigationItem.rightBarButtonItem = editButton

        
        getImages()
        
    }
    
    @objc func editCells(){
        if !shakeEnabled{
            shakeEnabled = true
            collectionView.reloadData()
        }else{
            shakeEnabled = false
            collectionView.reloadData()
        }
    }
    
    func getImages(){
        let fileManager = FileManager.default
        let imagesPath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        do{
            let photosPath = try fileManager.contentsOfDirectory(atPath: imagesPath as String)
            photosPath.forEach { (photoID) in
                let imageIDPath = imagesPath.appendingPathComponent(photoID)
                let image = UIImage(contentsOfFile: imageIDPath)
                images.append(image!)
            }
            
        }catch{
            print("error: \(error.localizedDescription)")
        }
    }
    
    func deleteImage(position:Int){
        let fileManager = FileManager.default
        let imagesPath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        do{
            let photosPath = try fileManager.contentsOfDirectory(atPath: imagesPath as String)
            let photoRemove = photosPath[position]
            try fileManager.removeItem(atPath: imagesPath.appendingPathComponent(photoRemove))
        }catch{
            print("error: \(error.localizedDescription)")
        }
        
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

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.imageView.image = images[indexPath.row]
        cell.indexPath = indexPath
        PhotoCollectionViewCell.delegate = self
        if shakeEnabled{
            cell.shakeIcons()
        }else{
            cell.stopShakingIcons()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let windowRect = self.view.window?.frame
        let w = (windowRect!.width / 2.0) - 20
        let h = windowRect!.height / 2.8
        
        let size = CGSize(width: w, height: h)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        let edge = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 20)
        
        return edge
        
    }
    
    
    
    
    
}

extension PhotosViewController: UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location), let cell = collectionView.cellForItem(at: indexPath) else{return nil}
        
        previewingContext.sourceRect = cell.frame
        
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "peekPhoto") as? PeekViewViewController else{return nil}
        let image = images[indexPath.row]
        viewController.image = image
        
        return viewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        }
    
}

extension PhotosViewController:CellActionDelegate{
    func removeCell(_ cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        
        collectionView.performBatchUpdates({
            self.images.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            self.deleteImage(position: indexPath.row) 
        }, completion: nil)
        
    }
    
    
}
