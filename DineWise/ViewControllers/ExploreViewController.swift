//
//  ExploreViewController.swift
//  DineWise
//
//  Created by Muhammad Mahad on 2025-03-22.
//

import UIKit
import AVKit
import FirebaseFirestore
import SDWebImage

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var mediaItems: [Media] = [] // Stores images & videos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchMediaFromFirestore()
    }
    
    // MARK: - Firestore Fetching
    func fetchMediaFromFirestore() {
        let db = Firestore.firestore()
        db.collection("restaurants").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            for document in documents {
                let restaurantID = document.documentID
                
                // Fetch Images
                if let media = Media(documentID: restaurantID, data: document.data()) {
                    self.mediaItems.append(media)
                }
                
                // Fetch Videos
                db.collection("restaurants").document(restaurantID).collection("videos").getDocuments { videoSnapshot, error in
                    if let videoDocs = videoSnapshot?.documents {
                        for videoDoc in videoDocs {
                            if let media = Media(documentID: videoDoc.documentID, data: videoDoc.data()) {
                                self.mediaItems.append(media)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - CollectionView Setup
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCollectionViewCell
        let item = mediaItems[indexPath.row]
        
        if item.type == .image {
            cell.configureImage(url: item.url)
        } else {
            cell.configureVideo(url: item.url)
        }
        
        return cell
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


