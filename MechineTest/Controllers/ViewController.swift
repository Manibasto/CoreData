//
//  ViewController.swift
//  MechineTest
//
//  Created by Mani on 3/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userTable: UITableView!
    
    var dataSource: DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.title = "Users"
        userTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: userTable.frame.width, height: 0))
        userTable.separatorStyle = .none
        dataSource = DataModel()
        dataSource?.delegate = self
        dataSource?.requestData()
        NotificationCenter.default.addObserver(forName: reload, object: nil, queue: .main) { (notify) in
            self.userTable.reloadData()
        }
        Singleton.shared.retrive()
    }
    
    func setupTableView(){
        userTable.delegate = self
        userTable.dataSource = self
        userTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dataSource = nil
    }
    
    @IBAction func addUser(_ sender: UIBarButtonItem) {
        let controller = AppStoryboard.Main.viewController(viewControllerClass: AddNewUserController.self)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

extension ViewController: DataModelDelegate{
    
    func didRecieveDataUpdata(data: [Datum]) {
        
        if Singleton.shared.userDetail.count == 0 {
            data.forEach { (model) in
                Singleton.shared.userDetail.append(Datum(avatar: model.avatar, email: model.email, firstName: model.firstName, id: model.id, lastName: model.lastName))
            }
            Singleton.shared.saveData()
        }
        setupTableView()
    }
    
    func didFailUpdateWithError(error: Error) {
        setupTableView()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.shared.userDetail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeueReusableCell(for: indexPath)
        let Model = Singleton.shared.userDetail[indexPath.row]
        cell.configure(withModel: Model)
        cell.tag = indexPath.row
        cell.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellClicked(sender:)))
        cell.addGestureRecognizer(tap)
        
//        let tapRecognizer = UITapGestureRecognizer { recognizer in
//            if let index = recognizer.view?.tag {
//                let controller = AppStoryboard.Main.viewController(viewControllerClass: UserDetailViewController.self)
//                controller.ModelData = Singleton.shared.userDetail[index]
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
//        }
//        cell.addGestureRecognizer(tapRecognizer)
        return cell
    }
    
    @objc func cellClicked(sender: UITapGestureRecognizer){
        if let index = sender.view?.tag {
            let controller = AppStoryboard.Main.viewController(viewControllerClass: UserDetailViewController.self)
            controller.ModelData = Singleton.shared.userDetail[index]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
