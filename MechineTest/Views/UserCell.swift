//
//  UserCell.swift
//  MechineTest
//
//  Created by Mani on 3/11/21.
//

import UIKit
import Kingfisher

class UserCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }
    
    func setup(){
        self.selectionStyle = .none
        avatarIcon.layer.cornerRadius = avatarIcon.frame.height/2
        avatarIcon.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 10
    }
    
    func configure(withModel: Datum) {
        let name = (withModel.firstName ?? "")+" "+(withModel.lastName ?? "")
        userName.text = name
        email.text = withModel.email
        let url = URL(string: withModel.avatar ?? "")
        if let avatar = withModel.avatar, let data = Data(base64Encoded: avatar) {
            let decodedimage = UIImage(data: data)
            avatarIcon.image = decodedimage
        }else{
            avatarIcon.kf.indicatorType = .activity
            avatarIcon.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .transition(.fade(1)),
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
    
}
