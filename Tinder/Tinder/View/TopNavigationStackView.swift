//
//  TopBarView.swift
//  Tinder
//
//  Created by olivier geiger on 01/05/2024.
//

import UIKit
import SnapKit

class TopBarView: UIView {
    
    // MARK: - UI
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            settingsButton,
            UIView(),
            fireImageView,
            UIView(),
            messageButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        return stackView
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    lazy var fireImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app_icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Life Cycle
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
extension TopBarView {
    
    private func layout() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settingsButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        messageButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        fireImageView.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
    }
}
