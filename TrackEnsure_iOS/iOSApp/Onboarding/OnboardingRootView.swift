//
//  OnboardingRootView.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 02.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import TrackEnsureUIKit
import TrackEnsureKit
import Combine
import YVAnchor

public class OnboardingRootView: NiblessView, UITextFieldDelegate {

    // MARK: - Properties
    // View Model
    let viewModel: OnboardingViewModel

    // Views
    private var nameField: UITextField!
    private var nameIcon: UIImageView!
    private var emailField: UITextField!
    private var emailIcon: UIImageView!
    private var passwordField: UITextField!
    private var passwordIcon: UIImageView!
    private var actionButton: UIButton!
    private var segmentedControl: UISegmentedControl!

    private let inputImageWidth: CGFloat = 35
    private let inputFieldHeight: CGFloat = 45
    private let inputSpacingSize: CGFloat = 8
    private var hierarchyNotReady: Bool = true

    private var actionButtonBotAnchor: NSLayoutConstraint!
    private var nameFieldTopAnchor: NSLayoutConstraint!

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Methods
    public init(frame: CGRect = .zero,
         viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }

    deinit { print("DEINIT: ", String(describing: self)) }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else { return }
        setupSubviews()
        constructHierarchy()
        activateConstraints()
        bindToViewModel()
        handleKeyboardNotifications()
        hierarchyNotReady = false
    }

    private func setupSubviews() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEdit)))

        let imageConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 18, weight: .regular))

        nameIcon = UIImageView(image: UIImage(systemName: "person", withConfiguration: imageConfiguration))
        nameIcon.tintColor = .label
        nameIcon.contentMode = .scaleAspectFit

        emailIcon = UIImageView(image: UIImage(systemName: "envelope", withConfiguration: imageConfiguration))
        emailIcon.tintColor = .label
        emailIcon.contentMode = .scaleAspectFit

        passwordIcon = UIImageView(image: UIImage(systemName: "lock", withConfiguration: imageConfiguration))
        passwordIcon.tintColor = .label
        passwordIcon.contentMode = .scaleAspectFit

        nameField = UITextField()
        nameField.placeholder = "Name"
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .words
        nameField.textColor = .label
        nameField.backgroundColor = .secondarySystemBackground
        nameField.leftView = nameIcon
        nameField.leftViewMode = .always
        nameField.returnKeyType = .next
        nameField.layer.cornerRadius = 8
        nameField.addTarget(self, action: #selector(handleNameChanged), for: .editingChanged)
        nameField.delegate = self
        nameField.alpha = 0

        emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.textColor = .label
        emailField.keyboardType = .emailAddress
        emailField.backgroundColor = .secondarySystemBackground
        emailField.leftView = emailIcon
        emailField.leftViewMode = .always
        emailField.returnKeyType = .next
        emailField.layer.cornerRadius = 8
        emailField.addTarget(self, action: #selector(handleEmailChanged), for: .editingChanged)
        emailField.delegate = self

        passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.textColor = .label
        passwordField.isSecureTextEntry = true
        passwordField.backgroundColor = .secondarySystemBackground
        passwordField.leftView = passwordIcon
        passwordField.leftViewMode = .always
        passwordField.returnKeyType = .done
        passwordField.layer.cornerRadius = 8
        passwordField.addTarget(self, action: #selector(handlePasswordChanged), for: .editingChanged)
        passwordField.delegate = self

        actionButton = UIButton(type: .system)
        actionButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        actionButton.backgroundColor = .secondarySystemBackground
        actionButton.layer.cornerRadius = 8
        actionButton.tintColor = .label
        actionButton.addTarget(self, action: #selector(handleAciton), for: .touchUpInside)

        segmentedControl = UISegmentedControl(items: ["Sign In", "Sign Up"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
    }

    private func constructHierarchy() {
        addSubview(segmentedControl)
        addSubview(nameField)
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(actionButton)
    }

    private func activateConstraints() {
        activateConstraintsSegmentedControl()
        activateConstraintsNameInput()
        activateConstraintsEmailInput()
        activateConstraintsPasswordInput()
        activateConstraintsActionButton()
    }

    private func activateConstraintsNameInput() {
        nameIcon.width(inputImageWidth)
        nameFieldTopAnchor = nameField.pin(.top, to: emailField.top)
        nameField.pin(.leading, to: self.leading, constant: 16)
        nameField.pin(.trailing, to: self.trailing, constant: 16)
        nameField.height(inputFieldHeight)
    }

    private func activateConstraintsEmailInput() {
        emailIcon.width(inputImageWidth)
        emailField.pin(.bottom, to: passwordField.top, constant: inputSpacingSize)
        emailField.pin(.leading, to: nameField.leading)
        emailField.pin(.trailing, to: nameField.trailing)
        emailField.height(inputFieldHeight)
    }

    private func activateConstraintsPasswordInput() {
        passwordIcon.width(inputImageWidth)
        passwordField.pin(.bottom, to: actionButton.top, constant: inputSpacingSize)
        passwordField.pin(.leading, to: nameField.leading)
        passwordField.pin(.trailing, to: nameField.trailing)
        passwordField.height(inputFieldHeight)
    }

    private func activateConstraintsActionButton() {
        actionButtonBotAnchor = actionButton.pin(.bottom, to: self.bottom, constant: UIScreen.main.bounds.size.height / 2.3)
        actionButton.pin(.leading, to: nameField.leading)
        actionButton.pin(.trailing, to: nameField.trailing)
        actionButton.height(inputFieldHeight)
    }

    private func activateConstraintsSegmentedControl() {
        segmentedControl.pin(.bottom, to: nameField.top, constant: inputSpacingSize)
        segmentedControl.pin(.leading, to: nameField.leading)
        segmentedControl.pin(.trailing, to: nameField.trailing)
    }

    private func changeInputCenterYConstraint(offset: CGFloat) {
        actionButtonBotAnchor.constant = offset == 0 ? -(UIScreen.main.bounds.size.height / 2.3) : -(UIScreen.main.bounds.size.height / 2)
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.layoutSubviews()
        })
    }

    private func bindToViewModel() {
        viewModel.buttonTitlePublisher.sink { [weak self] in self?.actionButton.setTitle($0, for: .normal) }.store(in: &subscriptions)
        viewModel.isButtonEnabled.assign(to: \.isEnabled, on: actionButton).store(in: &subscriptions)
        viewModel.beginEditingSubject.sink { [weak self] in self?.beginEditing() }.store(in: &subscriptions)
    }

    private func handleKeyboardNotifications() {
        let keyboardWillOpen = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
            .map { $0.height }


        let keyboardWillHide =  NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }


        _ = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main).sink { [weak self] in self?.changeInputCenterYConstraint(offset: $0) }
    }

    public func beginEditing() {
        emailField.becomeFirstResponder()
    }

    @objc private func handleNameChanged(_ sender: UITextField) {
        viewModel.nameSubject.send(sender.text)
    }

    @objc private func handleEmailChanged(_ sender: UITextField) {
        viewModel.emailSubject.send(sender.text)
    }

    @objc private func handlePasswordChanged(_ sender: UITextField) {
        viewModel.passwordSubject.send(sender.text)
    }

    @objc private func handleSegmentChange(_ sender: UISegmentedControl) {
        viewModel.onboardingModeSubject.send(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            nameFieldTopAnchor.constant = 0
            emailField.becomeFirstResponder()
            nameField.alpha = 0
        case 1:
            nameFieldTopAnchor.constant = -(inputFieldHeight + inputSpacingSize)
            nameField.becomeFirstResponder()
            nameField.alpha = 1
        default: return }
    }

    @objc private func handleAciton() {
        switch segmentedControl.selectedSegmentIndex {
        case 0: viewModel.signIn()
        case 1: viewModel.signUp()
        default: return }
    }

    @objc private func endEdit() {
        endEditing(true)
    }

    // MARK: - Text Field Delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            emailField.becomeFirstResponder()
            return true
        case emailField:
            passwordField.becomeFirstResponder()
            return true
        case passwordField:
            if !actionButton.isEnabled { return false }
            passwordField.resignFirstResponder()
            handleAciton()
            return true
        default: return false }
    }
}
