//
//  Extension.swift
//  MechineTest
//
//  Created by Mani on 3/11/21.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}
extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UITableViewCell: ReusableView {}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
}

extension UIGestureRecognizer {
    
    typealias Action = ((UIGestureRecognizer) -> ())
    
    private struct Keys {
        static var actionKey = "ActionKey"
    }
    
    private var block: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &Keys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        get {
            let action = objc_getAssociatedObject(self, &Keys.actionKey) as? Action
            return action
        }
    }
    
    @objc func handleAction(recognizer: UIGestureRecognizer) {
        block?(recognizer)
    }
    
    convenience public  init(block: @escaping ((UIGestureRecognizer) -> ())) {
        self.init()
        self.block = block
        self.addTarget(self, action: #selector(handleAction(recognizer:)))
    }
}

extension UIViewController{

    // Global Alert
    // Define Your number of buttons, styles and completion
    public func openAlert(title: String,
                          message: String,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]){

        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }
}

extension UITextField {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.text)
    }
}
extension UIScrollView {
    func scrollVerticallyToFirstResponderSubview(keyboardFrameHight: CGFloat) {
        guard let firstResponderSubview = findFirstResponderSubview() else { return }
        scrollVertically(toFirstResponder: firstResponderSubview,
                         keyboardFrameHight: keyboardFrameHight, animated: true)
    }
    
    private func scrollVertically(toFirstResponder view: UIView,
                                  keyboardFrameHight: CGFloat, animated: Bool) {
        let scrollViewVisibleRectHeight = frame.height - keyboardFrameHight
        let maxY = contentSize.height - scrollViewVisibleRectHeight
        if contentOffset.y >= maxY { return }
        var point = view.convert(view.bounds.origin, to: self)
        point.x = 0
        point.y -= scrollViewVisibleRectHeight/2
        if point.y > maxY {
            point.y = maxY
        } else if point.y < 0 {
            point.y = 0
        }
        setContentOffset(point, animated: true)
    }
}

extension UIView {
    func findFirstResponderSubview() -> UIView? { getAllSubviews().first { $0.isFirstResponder } }
    func getAllSubviews<T: UIView>() -> [T] { UIView.getAllSubviews(from: self) as [T] }
    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }
}

