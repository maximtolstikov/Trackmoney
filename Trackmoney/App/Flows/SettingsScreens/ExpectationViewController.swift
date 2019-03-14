//
//  ExpectationViewController.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 13/03/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

enum ExpectationType {
    case archiving
    case restoring
}

class ExpectationViewController: UIViewController {

    // MARK: - Private properties
    
    let expectationType: ExpectationType
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.startAnimating()
        return indicator
    }()
    
    private let expectationLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    init(type: ExpectationType) {
        self.expectationType = type
        super.init(nibName:nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addIndicator()
        setBackground()
        addTextLabel()
    }
    
    // MARK: - Configure controller
    
    private func setBackground() {
        view.backgroundColor = .white
    }
    
    private func addIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    private func addTextLabel() {
        view.addSubview(expectationLable)
        expectationLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        expectationLable
            .centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        setTextLabel()
    }
    
    private func setTextLabel() {
        
        switch expectationType {
        case .archiving:
            expectationLable.text = "Archiving..."
        case .restoring:
            expectationLable.text = "Restoring..."
        }
    }
   
}
