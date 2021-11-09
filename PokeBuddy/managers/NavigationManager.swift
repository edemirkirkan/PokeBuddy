//
//  NavigationManager.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 17.08.2021.
//

import Foundation
import UIKit

class NavigationManager {
        static func createMainTabBarController() -> UITabBarController {
            return MainTabBarController()
        }
        static func createNavigationController(viewController: UIViewController) -> UINavigationController {
            return UINavigationController(rootViewController: viewController)
        }
        static func present(from: UIViewController, to: UITabBarController) {
            to.modalPresentationStyle = .fullScreen
            from.present(to, animated: false)
        }
        static func present(from: UIViewController, to: UIViewController) {
            to.modalPresentationStyle = .fullScreen
            from.present(to, animated: false)
        }
        static func displayMainTabBarScreen(from: UIViewController) {
                present(from: from, to: createMainTabBarController())
        }
    
        static func showMessagePrompt(_ message: String, controller: UIViewController) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okMessage = ResourcesManager.getString(forKey: "okay_message")
            let okAction = UIAlertAction(title: okMessage, style: .default, handler: nil)
            alert.addAction(okAction)
            controller.present(alert, animated: false, completion: nil)
        }
    
        static func showMessagePromptAndNavigate(_ title: String, _ message: String, controller: UIViewController, toControler: UIViewController) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okMessage = ResourcesManager.getString(forKey: "okay_message")
            let okAction = UIAlertAction(title: okMessage, style: .default) { (action:UIAlertAction!) in
                NavigationManager.present(from: controller, to: createNavigationController(viewController: toControler))
            }
            alert.addAction(okAction)
            controller.present(alert, animated: false, completion: nil)
        }
    
        
        static func showConfirmationPrompt(_ title: String, _ message: String, controller: UIViewController, leftAction: UIAlertAction, rightAction: UIAlertAction) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(leftAction)
            alert.addAction(rightAction)
            controller.present(alert, animated: false, completion: nil)
        }

        static func showTextInputPrompt(withMessage message: String, controller: LoginViewController,
                                   completionBlock: @escaping ((Bool, String?) -> Void)) {
            let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let cancelMessage = ResourcesManager.getString(forKey: "cancel_message")
            prompt.view.tintColor = UIColor(named: "PokeBuddy TextTitle")
            let cancelAction = UIAlertAction(title: cancelMessage, style: .cancel) { _ in
              completionBlock(false, nil)
            }
            weak var weakPrompt = prompt
            let okMessage = ResourcesManager.getString(forKey: "okay_message")
            let okAction = UIAlertAction(title: okMessage, style: .default) { _ in
              guard let text = weakPrompt?.textFields?.first?.text else { return }
              completionBlock(true, text)
            }
            prompt.addTextField(configurationHandler: nil)
            prompt.addAction(cancelAction)
            prompt.addAction(okAction)
            controller.present(prompt, animated: true, completion: nil)
          }
}
