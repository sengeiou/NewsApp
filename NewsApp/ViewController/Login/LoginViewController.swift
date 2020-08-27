//
//  LoginViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/27/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class LoginViewController: BaseViewController {
    // MARK: - UI Components
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var contactPointTextField: ATCTextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var separatorLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - internal properties
    private let backgroundColor = HelperDarkMode.mainThemeBackgroundColor
    private let tintColor = UIColor(hexString: "#ff5a66")
    
    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let textFieldColor = UIColor.black
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
    
    private let separatorFont = UIFont.boldSystemFont(ofSize: 14)
    private let separatorTextColor = UIColor(hexString: "#464646")
    private let signUpButtonColor = UIColor(hexString: "#414665")
    private let signUpButtonBorderColor = UIColor(hexString: "#B0B3C6")
    private var viewModel:LoginViewModel
    
    init(viewModel:LoginViewModel = LoginViewModelImpl() ) {
        self.viewModel = viewModel
        super.init(basicViewModel: viewModel.basicViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindData()
        self.setupView()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {
            let contentSize = CGSize(width: self.view.frame.width, height: 600)

            self.scrollView.contentSize = contentSize


        }
    }
    // MARK: - private
    private func bindData() {
        self.viewModel.success
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] listArticles in
                guard let self = self else { return }
                self.view.makeToast("Login Successfully!")
            }).disposed(by: rx.disposeBag)
        self.viewModel.showToast
                 .subscribeOn(MainScheduler.instance)
                 .subscribe(onNext: {[weak self] message in
                     guard let self = self else { return }
                     self.view.makeToast(message)
                 }).disposed(by: rx.disposeBag)
    }
    private func setupView(){
        view.backgroundColor = backgroundColor
        backButton.setImage(UIImage.localImage("arrow-back-icon", template: true), for: .normal)
        backButton.tintColor = UIColor(hexString: "#282E4F")
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        titleLabel.font = titleFont
        titleLabel.text = "Log In"
        titleLabel.textColor = tintColor
        
        contactPointTextField.configure(color: textFieldColor,
                                        font: textFieldFont,
                                        cornerRadius: 55/2,
                                        borderColor: textFieldBorderColor,
                                        backgroundColor: backgroundColor,
                                        borderWidth: 1.0)
        contactPointTextField.placeholder = "E-mail"
        contactPointTextField.textContentType = .emailAddress
        contactPointTextField.clipsToBounds = true
        
        passwordTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 55/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .emailAddress
        passwordTextField.clipsToBounds = true
        
        separatorLabel.font = separatorFont
        separatorLabel.textColor = separatorTextColor
        separatorLabel.text = "OR"
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.configure(color: backgroundColor,
                              font: buttonFont,
                              cornerRadius: 55/2,
                              backgroundColor: tintColor)
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.configure(color: signUpButtonColor,
                               font: buttonFont,
                               cornerRadius: 55/2,
                               borderColor: signUpButtonBorderColor,
                               backgroundColor: backgroundColor,
                               borderWidth: 1)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapLoginButton() {
        self.viewModel.login(name: self.contactPointTextField.text, password: self.passwordTextField.text)
    }
    
    @objc func didTapSignUpButton() {
        let signUpVC = SignUpViewController()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
    
}


