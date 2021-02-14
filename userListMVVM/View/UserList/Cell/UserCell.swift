//
//  UserCell.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet private weak var userNameLastNameLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var userDateOfBirthLabel: UILabel!
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var userPhoneLabel: UILabel!
    @IBOutlet private weak var userNoteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let margins = UIEdgeInsets(top: 10, left: 27, bottom: 10, right: 6)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 8
    }
    
    func configure(userViewModel viewModel: UserViewPresentable) {
        
        self.userNameLastNameLabel.text = viewModel.userNameLastname
        self.userDateOfBirthLabel.text = viewModel.userDateOfBirth
        self.userEmailLabel.text = viewModel.userEmail
        self.userPhoneLabel.text = viewModel.userPhone
        if viewModel.userNote == nil {
            guard let notStackView = self.viewWithTag(100) else { return }
            stackView.removeArrangedSubview(notStackView, shouldRemoveFromSuperView: true)
            return
        } else {
            self.userNoteLabel.text = viewModel.userNote
        }
    }
}
