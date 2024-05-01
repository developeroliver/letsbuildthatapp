//
//  ViewController.swift
//  Tinder
//
//  Created by olivier geiger on 01/05/2024.
//

import UIKit
import SnapKit

class TinderHomeViewController: UIViewController {
    
    // MARK: - Properties
    let topStackView = TopBarView()
    let blueView = UIView()
    let buttonsStackView = BottomBarView()
    
    // MARK: - UI
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, blueView, buttonsStackView])
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
}

// MARK: - Helpers
extension TinderHomeViewController {
    
    private func style() {
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
}
