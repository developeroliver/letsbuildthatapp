//
//  CompanyCell.swift
//  Compagnies
//
//  Created by olivier geiger on 29/04/2024.
//

import UIKit
import SnapKit

class CompanyCell: UITableViewCell {
    
    // MARK: - Properties
    var company: Company? {
        didSet {
            nameFoundedLabel.text = company?.name
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            
            if let name = company?.name, let founded = company?.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM yyyy"
                dateFormatter.locale = Locale(identifier: "FR")
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                let dateString = "\(name) - founded: \(dateFormatter.string(from: founded))"
                nameFoundedLabel.text = dateString
            } else {
                nameFoundedLabel.text = company?.name
            }
        }
    }
    
    // MARK: - UI
    let companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:  "select_photo_empty")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    lazy var nameFoundedLabel: UILabel = {
        let label = UILabel()
        label.text = "COMPANY NAME"
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        return label
    }()
    
    //MARK: - LifeCycle Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension CompanyCell {
    
    private func setup() {
        
    }
    
    private func layout() {
        addSubview(companyImageView)
        addSubview(nameFoundedLabel)
        
        companyImageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        nameFoundedLabel.snp.makeConstraints { make in
            make.leading.equalTo(companyImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
    }
}
