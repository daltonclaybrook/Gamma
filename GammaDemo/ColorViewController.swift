//
//  ViewController.swift
//  Gamma
//
//  Created by Dalton Claybrook on 1/3/18.
//  Copyright © 2018 Dalton Claybrook. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    @IBOutlet private var colorStackView: UIStackView!
    private var colors: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: colors)
    }
    
    func configure(with colors: [UIColor]) {
        self.colors = colors
        guard isViewLoaded else { return }
        
        colorStackView.arrangedSubviews.forEach {
            colorStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        colors.forEach {
            let view = UIView()
            view.backgroundColor = $0
            colorStackView.addArrangedSubview(view)
        }
    }
}

