//
//  KeyboardNotifications.swift
//  MechineTest
//
//  Created by Mani on 3/12/21.
//

import Foundation
import UIKit

protocol KeyboardNotificationsDelegate: class {
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide(notification: NSNotification)
    func keyboardDidShow(notification: NSNotification)
    func keyboardDidHide(notification: NSNotification)
}

extension KeyboardNotificationsDelegate {
    func keyboardWillShow(notification: NSNotification) {}
    func keyboardWillHide(notification: NSNotification) {}
    func keyboardDidShow(notification: NSNotification) {}
    func keyboardDidHide(notification: NSNotification) {}
}

class KeyboardNotifications {

    fileprivate var _isEnabled: Bool
    fileprivate var notifications: [NotificationType]
    fileprivate weak var delegate: KeyboardNotificationsDelegate?
    fileprivate(set) lazy var isKeyboardShown: Bool = false

    init(notifications: [NotificationType], delegate: KeyboardNotificationsDelegate) {
        _isEnabled = false
        self.notifications = notifications
        self.delegate = delegate
    }

    deinit { if isEnabled { isEnabled = false } }
}

// MARK: - enums

extension KeyboardNotifications {

    enum NotificationType {
        case willShow, willHide, didShow, didHide

        var selector: Selector {
            switch self {
                case .willShow: return #selector(keyboardWillShow(notification:))
                case .willHide: return #selector(keyboardWillHide(notification:))
                case .didShow: return #selector(keyboardDidShow(notification:))
                case .didHide: return #selector(keyboardDidHide(notification:))
            }
        }

        var notificationName: NSNotification.Name {
            switch self {
                case .willShow: return UIResponder.keyboardWillShowNotification
                case .willHide: return UIResponder.keyboardWillHideNotification
                case .didShow: return UIResponder.keyboardDidShowNotification
                case .didHide: return UIResponder.keyboardDidHideNotification
            }
        }
    }
}

// MARK: - isEnabled

extension KeyboardNotifications {

    private func addObserver(type: NotificationType) {
        NotificationCenter.default.addObserver(self, selector: type.selector, name: type.notificationName, object: nil)
    }

    var isEnabled: Bool {
        set {
            if newValue {
                for notificaton in notifications { addObserver(type: notificaton) }
            } else {
                NotificationCenter.default.removeObserver(self)
            }
            _isEnabled = newValue
        }

        get { _isEnabled }
    }

}

// MARK: - Notification functions

extension KeyboardNotifications {

    @objc func keyboardWillShow(notification: NSNotification) {
        delegate?.keyboardWillShow(notification: notification)
        isKeyboardShown = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        delegate?.keyboardWillHide(notification: notification)
        isKeyboardShown = false
    }

    @objc func keyboardDidShow(notification: NSNotification) {
        isKeyboardShown = true
        delegate?.keyboardDidShow(notification: notification)
    }

    @objc func keyboardDidHide(notification: NSNotification) {
        isKeyboardShown = false
        delegate?.keyboardDidHide(notification: notification)
    }
}
