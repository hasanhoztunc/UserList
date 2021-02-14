//
//  UserListViewController.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import UIKit
import RxSwift
import RxDataSources

final class UserListViewController: UIViewController, Storyboardable {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    private let addNavigationButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        let image = UIImage(named: "ic-button-background")!
        addButton.setBackgroundImage(image, for: .normal, barMetrics: .default)
        
        return addButton
    }()
    
    private var viewModel: UsersListViewPresentable!
    var viewModelBuilder: UsersListViewPresentable.ViewModelBuilder!
    
    private static let CellId = "UserCell"
    
    private let bag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<UserItemSection>(configureCell: { (_, tableView, indexPath, item) in
        let userCell = tableView.dequeueReusableCell(withIdentifier: UserListViewController.CellId, for: indexPath) as! UserCell
        userCell.configure(userViewModel: item)
        
        return userCell
    }, canEditRowAtIndexPath: { _,_ in
        return true
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = viewModelBuilder((
            searchText: searchTextField.rx.text.orEmpty.asDriver(),
            userSelect: tableView.rx.modelSelected(UserViewModel.self).asDriver(),
            userDelete: tableView.rx.itemDeleted.asDriver(),
            userAdd: addNavigationButton.rx.tap
        ))
        
        setupUI()
        setupBindings()
    }
}

private extension UserListViewController {
    
    func setupUI() {
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: UserListViewController.CellId)
        title = "Kişiler"
        
        self.navigationItem.rightBarButtonItem = addNavigationButton
    }
    
    func setupBindings() {
        self.viewModel.output.users
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}
