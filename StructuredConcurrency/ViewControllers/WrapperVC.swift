//
//  WrapperVC.swift
//  StructuredConcurrency
//
//  Created by Hirenkumar Fadadu on 07/04/24.
//

import UIKit

// MARK: - VC
class WrapperVC: ParentVC {
    
    @IBOutlet weak private var imageView: UIImageView!
    
    let client = Client()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IBAction(s)
extension WrapperVC {
    
    @IBAction func btnDownloadImage() {
        downloadImage()
    }
}

// MARK: - API call
extension WrapperVC {
    
    func downloadImage() {
        showLoader()
        Task {
            do {
                let result = try await client.downloadWrapper(url: AppConstant.images.first!)
                guard let image = UIImage(data: result) else {
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

