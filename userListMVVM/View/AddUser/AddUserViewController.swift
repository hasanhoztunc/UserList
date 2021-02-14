//
//  AddUserViewController.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 10.02.2021.
//

import UIKit
import RxSwift

final class AddUserViewController: UIViewController, Storyboardable {
    
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var userLastNameTextField: UITextField!
    @IBOutlet private weak var userDateOfBirthTextField: UITextField!
    @IBOutlet private weak var userEmailTextField: UITextField!
    @IBOutlet private weak var userPhoneTextField: UITextField!
    @IBOutlet private weak var userNoteTextView: UITextView!
    @IBOutlet private weak var saveUpdateButton: UIButton!
    
    private var viewModel: AddUserViewPresentable!
    var viewModelBuilder: AddUserViewPresentable.ViewModelBuilder!
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = viewModelBuilder((
            userName: userNameTextField.rx.text.orEmpty.asDriver(),
            userLastName: userLastNameTextField.rx.text.orEmpty.asDriver(),
            userDateOfBirth: userDateOfBirthTextField.rx.text.orEmpty.asDriver(),
            userEmail: userEmailTextField.rx.text.orEmpty.asDriver(),
            userPhone: userPhoneTextField.rx.text.orEmpty.asDriver(),
            userNote: userNoteTextView.rx.text.orEmpty.asDriver(),
            saveUser: saveUpdateButton.rx.controlEvent(.touchUpInside)
        ))
        
        setupBindings()
    }
}

extension AddUserViewController {
    
    func setupBindings() {
        let user = self.viewModel.output.user
            .filter({ $0 != nil })
            .map({ $0! })
            
            user.map({
                $0.userName
            })
            .drive(userNameTextField.rx.text)
            .disposed(by: bag)
        
        user.map({
                $0.userLastName
            })
            .drive(userLastNameTextField.rx.text)
            .disposed(by: bag)
        
        user.map({
                $0.userDateOfBirth
            })
            .drive(userDateOfBirthTextField.rx.text)
            .disposed(by: bag)
        
        user.map({
                $0.userEmail
            })
            .drive(userEmailTextField.rx.text)
            .disposed(by: bag)

        user.map({
                $0.userPhone
            })
            .drive(userPhoneTextField.rx.text)
            .disposed(by: bag)
        
        user.map({
                $0.userNote
            })
            .drive(userNoteTextView.rx.text)
            .disposed(by: bag)
        
        self.viewModel.output.title
            .drive(rx.title)
            .disposed(by: bag)
    }
}
