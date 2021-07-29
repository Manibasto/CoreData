//
//  AddNewUserController.swift
//  MechineTest
//
//  Created by Mani on 3/12/21.
//

import UIKit

class AddNewUserController: UIViewController {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var userImageContainer: UIView!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var firstNameTextFeild: UITextField!
    @IBOutlet weak var lastNameTextFeild: UITextField!
    @IBOutlet weak var emailTextFeild: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    private lazy var keyboard = KeyboardNotifications(notifications: [.willHide, .willShow], delegate: self)
    
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.title = "Add New Users"
        setupLayout()
        let endEditingRecoganizer = UITapGestureRecognizer { recognizer in
            self.view.endEditing(true)
        }
        view.addGestureRecognizer(endEditingRecoganizer)
        
        let profileClickListner = UITapGestureRecognizer { recognizer in
            
            let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            actionsheet.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { (action) -> Void in
                self.imagePicker.cameraAsscessRequest()
            }))
            
            actionsheet.addAction(UIAlertAction(title: "Choose Exisiting Photo", style: .default, handler: { (action) -> Void in
                self.imagePicker.photoGalleryAsscessRequest()
            }))
            actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                
            }))
            self.present(actionsheet, animated: true, completion: nil)
        }
        userImageContainer.addGestureRecognizer(profileClickListner)
        
        
        
    }
    
    
    func setupLayout(){
        _ = [firstNameTextFeild, lastNameTextFeild, emailTextFeild].map {
            $0?.borderStyle = .none
            $0?.layer.cornerRadius = 10
            $0?.layer.borderWidth = 1.0
            $0?.layer.borderColor = UIColor.lightGray.cgColor
            $0?.delegate = self
        }
        saveBtn.layer.borderWidth = 1.0
        saveBtn.layer.borderColor = UIColor.lightGray.cgColor
        saveBtn.layer.cornerRadius = 10
    }
    override func viewDidLayoutSubviews() {
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImageContainer.layer.cornerRadius = userImageContainer.frame.height/2
        userImageContainer.layer.masksToBounds = true
        userImageContainer.backgroundColor = .black
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        let fistName = firstNameTextFeild.text
        let lastName = lastNameTextFeild.text
        let email = emailTextFeild.text
        
        if fistName?.count == 0 {
            openAlert(title: "", message: "please enter first name", alertStyle: .alert, actionTitles: ["Cancel"], actionStyles: [.cancel], actions: [
            {_ in
                 print("okay click")
            },
       ])
        }else if lastName?.count == 0 {
            
            openAlert(title: "", message: "please enter last name", alertStyle: .alert, actionTitles: ["Cancel"], actionStyles: [.cancel], actions: [
                {_ in
                     print("okay click")
                },
           ])
            
        }else if email?.count == 0 {
            openAlert(title: "", message: "please enter email name", alertStyle: .alert, actionTitles:["Cancel"], actionStyles: [.cancel], actions: [
                {_ in
                     print("okay click")
                },
           ])
        }else if !emailTextFeild.isValidEmail() {
            openAlert(title: "", message: "please enter valid email name", alertStyle: .alert, actionTitles: ["Cancel"], actionStyles: [.cancel], actions: [
                {_ in
                     print("okay click")
                },
           ])
        }else{
            if let imageData = userImage.image?.pngData() {
                let base64 = imageData.base64EncodedString()
                Singleton.shared.userDetail.append(Datum(avatar: base64, email: email, firstName: fistName, id: 0, lastName: lastName))
                save(data: Datum(avatar: base64, email: email, firstName: fistName, id: 0, lastName: lastName))
            }else{
                Singleton.shared.userDetail.append(Datum(avatar: "", email: email, firstName: fistName, id: 0, lastName: lastName))
                save(data: Datum(avatar: "", email: email, firstName: fistName, id: 0, lastName: lastName))
            }
            NotificationCenter.default.post(name: reload, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }    
}




extension AddNewUserController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextFeild {
            lastNameTextFeild.becomeFirstResponder()
        } else if textField == lastNameTextFeild {
            emailTextFeild.becomeFirstResponder()
        }else {
            emailTextFeild.resignFirstResponder()
        }
        return true
    }
}


extension AddNewUserController: KeyboardNotificationsDelegate{
    func keyboardWillShow(notification: NSNotification) {
        guard   let userInfo = notification.userInfo as? [String: Any],
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollview.contentInset.bottom = keyboardFrame.height
        scrollview.scrollVerticallyToFirstResponderSubview(keyboardFrameHight: keyboardFrame.height)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollview.contentInset.bottom = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboard.isEnabled = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboard.isEnabled = false
    }
}

extension AddNewUserController:  ImagePickerDelegate{
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        userImage.image = image
        imagePicker.dismiss()
    }
    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}
