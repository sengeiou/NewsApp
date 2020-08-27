//
//  SignUpViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/27/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class SignUpViewController: BaseViewController {
    // MARK: - UI Components
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nameTextField: ATCTextField!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var confirmPasswordTextField: ATCTextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    
    // MARK: - internal properties
    private var viewModel:SignUpViewModel
    
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let backgroundColor: UIColor = HelperDarkMode.mainThemeBackgroundColor
    private let textFieldColor = UIColor.black
    
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
    @IBOutlet weak var scrollView: UIScrollView!

    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    init(viewModel:SignUpViewModel = SignUpViewModelImpl() ) {
        self.viewModel = viewModel
        super.init(basicViewModel: viewModel.basicViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.hideKeyboardWhenTappedAround()
        self.bindData()
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
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.showAlert(with: "Registration successfully completed!", allowCancel: false, completionOK: {
                    self.navigationController?.popViewController(animated: true)
                }, completionCancel: nil)
            }).disposed(by: rx.disposeBag)
        self.viewModel.errorValidattion
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] text in
                guard let self = self else { return }
                self.errorLabel.text = text
            }).disposed(by: rx.disposeBag)
        
        Observable.combineLatest(passwordTextField.rx.text.asObservable(), confirmPasswordTextField.rx.text.asObservable())
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] listArticles in
                guard let self = self else { return }
                self.errorLabel.text = ""
            }).disposed(by: rx.disposeBag)
    }
    private func setupView(){
        view.backgroundColor = backgroundColor
        let color = UIColor(hexString: "#282E4F")
        backButton.tintColor = color
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        titleLabel.font = titleFont
        titleLabel.text = "Sign Up"
        titleLabel.textColor = tintColor
        
        nameTextField.configure(color: textFieldColor,
                                font: textFieldFont,
                                cornerRadius: 40/2,
                                borderColor: textFieldBorderColor,
                                backgroundColor: backgroundColor,
                                borderWidth: 1.0)
        nameTextField.placeholder = "Full Name"
        nameTextField.clipsToBounds = true
        
        
        passwordTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 40/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clipsToBounds = true

        
        confirmPasswordTextField.configure(color: textFieldColor,
                                           font: textFieldFont,
                                           cornerRadius: 40/2,
                                           borderColor: textFieldBorderColor,
                                           backgroundColor: backgroundColor,
                                           borderWidth: 1.0)
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.clipsToBounds = true
        
        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signUpButton.configure(color: backgroundColor,
                               font: buttonFont,
                               cornerRadius: 40/2,
                               backgroundColor: UIColor(hexString: "#334D92"))
        
    }
    // MARK: - Action
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapSignUpButton() {
        self.viewModel.signUp(name: self.nameTextField.text,
                              password: self.passwordTextField.text,
                              confirmpassword: self.confirmPasswordTextField.text)
    }
    
}
