//
//  JobCell.swift
//  ToyRxGithubJobs
//
//  Created by Faiz Mokhtar AD0502 on 31/10/2020.
//

import UIKit

class JobCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    var viewModel: JobCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(_ viewModel: JobCellViewModel) {
        titleLabel.text = viewModel.title
        companyLabel.text = viewModel.company
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(companyLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            companyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            companyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            companyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            companyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}
