//
//  LoginView.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 29.09.2021.
//

import UIKit

class LoginView: UIView {
    private var viewController: LoginViewController?
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var btnGoogleSignIn: UIView?
    @IBOutlet weak var btnAppleSignIn: UIView?
    @IBOutlet weak var btnFacebookSignIn: UIView?
    @IBOutlet weak var loadingScreen: UIView?
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
        self.setupView()
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        addSubview(contentView!)
        contentView?.frame = bounds
        contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ResourcesManager.setBackgroundColor(view: self.contentView!)
        self.configureGoogleButtonStyle()
        self.configureAppleButtonStyle()
        self.configureFacebookButtonStyle()
        self.configureGestures()
    }
    
    func configureController(controller: LoginViewController) {
        self.viewController = controller
    }
    
    private func configureGoogleButtonStyle() {
        btnGoogleSignIn?.layer.cornerRadius = CGFloat(10)
        btnGoogleSignIn?.layer.masksToBounds = true
        btnGoogleSignIn?.layer.borderWidth = 1
        btnGoogleSignIn?.layer.borderColor = (UIColor(named: "PokeBuddy Seperator"))?.cgColor
    }
    private func configureAppleButtonStyle() {
        btnAppleSignIn?.layer.cornerRadius = CGFloat(10)
        btnAppleSignIn?.layer.masksToBounds = true
    }
    
    private func configureFacebookButtonStyle() {
        btnFacebookSignIn?.layer.cornerRadius = CGFloat(10)
        btnFacebookSignIn?.layer.masksToBounds = true
    }
    
    private func configureGestures() {
        let btnGoogleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onGoogleSignInButtonClicked(sender:)))
        self.btnGoogleSignIn?.addGestureRecognizer(btnGoogleTapGesture)
        let btnAppleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onAppleSignInButtonClicked(sender:)))
        self.btnAppleSignIn?.addGestureRecognizer(btnAppleTapGesture)
    }
    
    @objc func onGoogleSignInButtonClicked(sender: UITapGestureRecognizer)  {
        viewController?.onGoogleSignInButtonClicked()
    }
    
    @objc func onAppleSignInButtonClicked(sender: UITapGestureRecognizer)  {
        viewController?.onAppleSignInButtonClicked()
    }
}
