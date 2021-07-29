//
//  UserDetailViewController.swift
//  MechineTest
//
//  Created by Mani on 3/11/21.
//

import UIKit
import Kingfisher

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
        
    var ModelData: Datum?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        overrideUserInterfaceStyle = .light
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userName.text = (ModelData?.firstName ?? "")+" "+(ModelData?.lastName ?? "")
        userEmail.text = ModelData?.email
        
        let url = URL(string: ModelData?.avatar ?? "")
        
        if let avatar = ModelData?.avatar, let data = Data(base64Encoded: avatar) {
            let decodedimage = UIImage(data: data)
            profileImageView.image = decodedimage
        }else{
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        profileContainerView.layer.cornerRadius = profileContainerView.frame.height/2
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileContainerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        profileContainerView.layer.shadowOpacity = 0.2
        profileContainerView.layer.shadowOffset = .zero
        profileContainerView.layer.shadowRadius = 10
    }
    

    
}
