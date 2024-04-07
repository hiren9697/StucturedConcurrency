//
//  SimpleSyntaxVC.swift
//  StructuredConcurrency
//
//  Created by Hirenkumar Fadadu on 07/04/24.
//

import UIKit

// MARK: - VC
class SimpleSyntaxVC: ParentVC {
    
    @IBOutlet weak private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IBAction(s)
extension SimpleSyntaxVC {
    
    @IBAction func btnDownloadImage() {
        downloadImage()
    }
}

// MARK: - API call
extension SimpleSyntaxVC {
    
    func downloadImage() {
        showLoader()
        Task {
            do {
                let result = try await URLSession.shared.data(from: AppConstant.images.first!)
                guard let image = UIImage(data: result.0) else {
                    print("*** Couldn't construct image from Data ***")
                    return
                }
                imageView.image = image
                hideLoader()
            } catch {
                print("*** Received error while downloading image: \(error) ***")
                hideLoader()
            }
        }
    }
}
