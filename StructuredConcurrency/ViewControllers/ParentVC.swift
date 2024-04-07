//
//  ParentVC.swift
//  StructuredConcurrency
//
//  Created by Hirenkumar Fadadu on 07/04/24.
//

import UIKit

// MARK: - VC
class ParentVC: UIViewController {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        activity.color = .gray
        return activity
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - UI Helper method(s)
extension ParentVC {
    
    private func addActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    internal func showLoader() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    internal func hideLoader() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
}
