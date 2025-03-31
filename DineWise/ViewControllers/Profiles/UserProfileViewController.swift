//
//  UserProfileViewController.swift
//  DineWise
//
//  Created by Muhammad Mahad on 2025-03-25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserProfileViewController: UIViewController {

    @IBOutlet var userNameLabel: UILabel! // Connect this in storyboard
    
    @IBAction func  unwindToUserProfileVC(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData() // Fetch user data when screen loads
    }

    // Fetch Logged-in User's Name
    func fetchUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                let name = data["name"] as? String ?? "No Name"
                self.userNameLabel.text = "Welcome, \(name)"
            }
        }
    }

    // Navigate to FavouritesViewController
    @IBAction func favouritesTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    // Navigate to MyReviewViewController
    @IBAction func reviewsTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyReviewsViewController") as! MyReviewsViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    // Sign Out Functionality
    @IBAction func signOutTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            print("User signed out")
            
            // Navigate to Login Screen (Assuming LoginViewController exists)
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "CustomerLoginController") as! CustomerLoginController
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true)
            
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
