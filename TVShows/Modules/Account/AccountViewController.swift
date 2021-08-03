//
//  AccountViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 02.08.2021..
//

import Foundation
import UIKit
import Alamofire

final class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var profilePhotoImageView: UIImageView!
    @IBOutlet private weak var changeProfilePhotoButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    
    private var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUserDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction private func changeProfilePhotoButtonTap() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction private func closeButtonTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func logoutUser() {
        KeychainManager.shared.deleteKeychainValues()
        UserData.sharedInstance.authInfo = nil
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("Logout"), object: nil)
    }
}

extension AccountViewController {
    
    private func setupUI(){
        logoutButton.applyCornerRadius(of: 21.5)
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.bounds.size.width / 2
    }
    
    private func getUserDetails() {
        self.showLoading()
        APIManager.shared.fetchUserData(
            completion: { [weak self] dataResponse in
                guard let self = self else { return }
                self.hideLoading()
                switch dataResponse.result {
                case .success(let response):
                    self.userEmailLabel.text = response.user.email
                    if let image = response.user.imageUrl {
                        self.profilePhotoImageView.kf.setImage(
                            with: URL(string: image),
                            placeholder: UIImage(named: "ic-profile-placeholder")
                        )
                    }
                case .failure(let error):
                    self.showFailure(with: error)
                }
            }
        )
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePhotoImageView.contentMode = .scaleAspectFit
            profilePhotoImageView.image = image
            APIManager.shared.uploadImage(image)
        }
    }
}

extension AccountViewController: ProgressReporting {
    
}
