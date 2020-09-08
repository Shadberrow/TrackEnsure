//
//  RecordCreationDetailRootView.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit
import UIKit
import Combine

class RecordCreationDetailRootView: NiblessView, UITextFieldDelegate {

    // MARK: - Properties
    // View Model
    let viewModel: RecordCreationViewModel

    // Subviews
    private var locationAddress: UILabel!
    private var supplierField: UITextField!
    private var typeField: UITextField!
    private var quantityField: UITextField!
    private var priceField: UITextField!
    private var inputStack: UIStackView!
    private var actionButton: UIButton!

    private var hierarchyNotReady: Bool = true
    private var isExpanded: Bool = false

    // Constraints
    private var actionButtonTopAnchor_initial: NSLayoutConstraint!
    private var actionButtonTopAnchor_expanded: NSLayoutConstraint!

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Methods
    init(viewModel: RecordCreationViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else { return }
        setupSubviews()
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false

        combineViewModel()
    }

    private func setupSubviews() {
        locationAddress = UILabel()
        locationAddress.textColor = .label
        locationAddress.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        supplierField = UITextField()
        supplierField.placeholder = "Supplier"
        supplierField.autocorrectionType = .no
        supplierField.autocapitalizationType = .words

        typeField = UITextField()
        typeField.placeholder = "Type"
        typeField.autocorrectionType = .no
        typeField.autocapitalizationType = .words

        quantityField = UITextField()
        quantityField.placeholder = "Quantity"
        quantityField.keyboardType = .numberPad

        priceField = UITextField()
        priceField.placeholder = "Price"
        priceField.keyboardType = .numberPad

        let fields = [supplierField, typeField, quantityField, priceField].compactMap { $0 }

        fields.forEach { field in
            field.textColor = .label
            field.backgroundColor = .secondarySystemBackground
            let view = UIView()
            view.widthAnchor.constraint(equalToConstant: 20).isActive = true
            field.leftView = view
            field.leftViewMode = .always
            field.layer.cornerRadius = 8
            field.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
            field.delegate = self
        }

        inputStack = UIStackView(arrangedSubviews: fields)
        inputStack.axis = .vertical
        inputStack.distribution = .fillEqually
        inputStack.spacing = 8
        inputStack.alpha = 0

        actionButton = UIButton(type: .system)
        actionButton.setTitle("Next", for: .normal)
        actionButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        actionButton.backgroundColor = .systemBlue
        actionButton.layer.cornerRadius = 8
        actionButton.tintColor = .white
        actionButton.addTarget(self, action: #selector(handleAciton), for: .touchUpInside)
    }

    private func constructHierarchy() {
        addSubview(locationAddress)
        addSubview(actionButton)
        addSubview(inputStack)
    }

    private func activateConstraints() {
        activateConstraintsLocationAddress()
        activateConstraintsActionButton()
        activateConstraintsInputStack()
    }

    private func activateConstraintsLocationAddress() {
        locationAddress.translatesAutoresizingMaskIntoConstraints = false
        let top = locationAddress.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)
        let leading = locationAddress.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        NSLayoutConstraint.activate([top, leading])
    }

    private func activateConstraintsActionButton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButtonTopAnchor_initial = actionButton.topAnchor.constraint(equalTo: locationAddress.bottomAnchor, constant: 12)
        actionButtonTopAnchor_expanded = actionButton.topAnchor.constraint(equalTo: inputStack.bottomAnchor, constant: 12)
        let height = actionButton.heightAnchor.constraint(equalToConstant: 44)
        let width = actionButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        let centerX = actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        NSLayoutConstraint.activate([actionButtonTopAnchor_initial, height, width, centerX])
    }

    private func activateConstraintsInputStack() {
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        let top = inputStack.topAnchor.constraint(equalTo: locationAddress.bottomAnchor, constant: 8)
        let leading = inputStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        let trailing = inputStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        let height = inputStack.heightAnchor.constraint(equalToConstant: (45 * 4) + (8 * 3)) // 4 fields with 45p height and 3 spaces between with 8p
        NSLayoutConstraint.activate([top, leading, height, trailing])
    }

    private func combineViewModel() {
        viewModel.addressLabel.receive(on: RunLoop.main).assign(to: \.text, on: locationAddress).store(in: &subscriptions)
        viewModel.isButtonEnabled.receive(on: RunLoop.main).assign(to: \.isEnabled, on: actionButton).store(in: &subscriptions)
        viewModel.supplierSubject.receive(on: RunLoop.main).compactMap { $0 }.assign(to: \.text, on: supplierField).store(in: &subscriptions)
        viewModel.typeSubject.receive(on: RunLoop.main).compactMap { $0 }.assign(to: \.text, on: typeField).store(in: &subscriptions)
        viewModel.amountSubject.receive(on: RunLoop.main).compactMap { $0 }.assign(to: \.text, on: quantityField).store(in: &subscriptions)
        viewModel.priceSubject.receive(on: RunLoop.main).compactMap { $0 }.assign(to: \.text, on: priceField).store(in: &subscriptions)
        viewModel.isDetailSheetOpenSubject.receive(on: RunLoop.main).sink { [weak self] res in
            if res { self?.showInputStackAnimated() }
            self?.isExpanded = res
        }.store(in: &subscriptions)
    }

    private func showInputStackAnimated() {
        actionButtonTopAnchor_initial.isActive = false
        actionButtonTopAnchor_expanded.isActive = true
        supplierField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
            self.inputStack.alpha = 1
            self.layoutIfNeeded()
        })
        isExpanded = true
    }

    @objc private func handleAciton() {
        if isExpanded {
            viewModel.finishRecordCreation()
        } else {
            showInputStackAnimated()
            viewModel.expandDetailView()
        }
    }

    @objc private func handleTextChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        switch sender {
        case supplierField: viewModel.supplierSubject.send(text)
        case typeField: viewModel.typeSubject.send(text)
        case quantityField: viewModel.amountSubject.send(text)
        case priceField: viewModel.priceSubject.send(text)
        default: return }
    }

    // MARK: - Text Field Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !isExpanded { viewModel.expandDetailView() }
        return true
    }
}
