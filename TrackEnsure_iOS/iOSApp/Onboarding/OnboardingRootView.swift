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

public class OnboardingRootView: NiblessView, UITextFieldDelegate {

    // MARK: - Properties
    // View Model
    let viewModel: OnboardingViewModel

    // Views
    private var inputStack: UIStackView!
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
    private var hierarchyNotReady: Bool = true

    private var inputCenterYAnchor: NSLayoutConstraint!
    private var nameFieldHeightAnchor: NSLayoutConstraint!

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

        inputStack = UIStackView(arrangedSubviews: [nameField, emailField, passwordField])
        inputStack.axis = .vertical
        inputStack.spacing = 8

        actionButton = UIButton(type: .system)
        actionButton.setTitle("Sign Up", for: .normal)
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
        addSubview(inputStack)
        addSubview(actionButton)
        addSubview(segmentedControl)
    }

    private func activateConstraints() {
        activateConstraintsNameInput()
        activateConstraintsEmailInput()
        activateConstraintsPasswordInput()
        activateConstraintsInputStack()
        activateConstraintsActionButton()
        activateConstraintsSegmentedControl()
    }

    private func activateConstraintsNameInput() {
        let width = nameIcon.widthAnchor.constraint(equalToConstant: inputImageWidth)
        nameFieldHeightAnchor = nameField.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([width, nameFieldHeightAnchor])
    }

    private func activateConstraintsEmailInput() {
        let width = passwordIcon.widthAnchor.constraint(equalToConstant: inputImageWidth)
        let height = passwordField.heightAnchor.constraint(equalToConstant: inputFieldHeight)
        NSLayoutConstraint.activate([width, height])
    }

    private func activateConstraintsPasswordInput() {
        let width = emailIcon.widthAnchor.constraint(equalToConstant: inputImageWidth)
        let height = emailField.heightAnchor.constraint(equalToConstant: inputFieldHeight)
        NSLayoutConstraint.activate([width, height])
    }

    private func activateConstraintsInputStack() {
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        let leading = inputStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        let trailing = inputStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        inputCenterYAnchor = inputStack.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150)
        NSLayoutConstraint.activate([leading, trailing, inputCenterYAnchor])
    }

    private func activateConstraintsActionButton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        let top = actionButton.topAnchor.constraint(equalTo: inputStack.bottomAnchor, constant: 8)
        let leadgin = actionButton.leadingAnchor.constraint(equalTo: inputStack.leadingAnchor)
        let trailing = actionButton.trailingAnchor.constraint(equalTo: inputStack.trailingAnchor)
        let height = actionButton.heightAnchor.constraint(equalToConstant: inputFieldHeight)
        NSLayoutConstraint.activate([top, leadgin, trailing, height])
    }

    private func activateConstraintsSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let bottom = segmentedControl.bottomAnchor.constraint(equalTo: inputStack.topAnchor, constant: -8)
        let leadgin = segmentedControl.leadingAnchor.constraint(equalTo: inputStack.leadingAnchor)
        let trailing = segmentedControl.trailingAnchor.constraint(equalTo: inputStack.trailingAnchor)
        NSLayoutConstraint.activate([bottom, leadgin, trailing])
    }

    private func changeInputCenterYConstraint(offset: CGFloat) {
        inputCenterYAnchor.constant = offset == 0 ? 0 : -150
    }

    private func bindToViewModel() {
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
            emailField.becomeFirstResponder()
            nameField.alpha = 0
            nameFieldHeightAnchor.constant = 0
        case 1:
            nameField.becomeFirstResponder()
            nameField.alpha = 1
            nameFieldHeightAnchor.constant = inputFieldHeight
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
