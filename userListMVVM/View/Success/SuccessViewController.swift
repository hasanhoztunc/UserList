//
//  SuccessViewController.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 12.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SuccessViewController: UIViewController, Storyboardable {

    private var viewModel: SuccessViewPresentable!
    var viewModelBuilder: SuccessViewPresentable.ViewModelBuilder!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewModel = viewModelBuilder((
            dismiss: view.rx.tapGesture(),
            ()
        ))
    }
}
