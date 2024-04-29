//
//  CustomHeaderView.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//

import UIKit
import SnapKit

class CustomHeaderView: UIView {
    
    // MARK: - UI
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
        imageView.tintColor = UIColor.darkBlue
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkBlue
        label.font = UIFont(name: "AvenirNext-Bold", size: 18)
        label.text = "Noms"
        return label
    }()
    
    //MARK: - LifeCycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
    }
}

// MARK: - Helpers
extension CustomHeaderView {
    
    private func layout() {
        addSubview(iconImageView)
        addSubview(nameLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
