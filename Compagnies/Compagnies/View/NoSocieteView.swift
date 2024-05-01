//
//  NoSocieteView.swift
//  Compagnies
//
//  Created by olivier geiger on 01/05/2024.
//

import UIKit
import SnapKit

class NoSocieteView: UIView {
    
    // MARK: - UI
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Pas de société de disponible...\n\nVeuillez créer une société en utilisant le bouton ajouter en haut à droite."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Medium", size: 18)
        label.numberOfLines = 0
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
    
    // MARK: - Setup
    private func layout() {
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 32, left: 16, bottom: 16, right: 16))
        }
    }
}

