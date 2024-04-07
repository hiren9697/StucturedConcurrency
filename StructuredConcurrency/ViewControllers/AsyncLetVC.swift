//
//  AsyncLetVC.swift
//  StructuredConcurrency
//
//  Created by Hirenkumar Fadadu on 07/04/24.
//

import UIKit

// MARK: - VC
class AsyncLetVC: ParentVC {
    
    @IBOutlet weak private var firstImageView: UIImageView!
    @IBOutlet weak private var secondImageView: UIImageView!
    
    let client = Client()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IBAction(s)
extension AsyncLetVC {
    
    @IBAction func btnDownloadImage() {
        downloadImages()
    }
}

// MARK: - API call
extension AsyncLetVC {
    
    // First approach
    /*
    func downloadImages() {
        showLoader()
        Task {
            do {
                let twoData = try await downloadTwoImages()
                
                guard let firstImage = UIImage(data: twoData.0),
                      let secondImage = UIImage(data: twoData.1) else {
                    print("*** Couldn't construct images from data  ***")
                    return
                }
                firstImageView.image = firstImage
                secondImageView.image = secondImage
                hideLoader()
            } catch {
                print("*** Received error while downloading image: \(error) ***")
                hideLoader()
            }
        }
    }
    
    func downloadTwoImages() async throws-> (Data, Data) {
        async let data1 = URLSession.shared.data(from: AppConstant.images.first!)
        async let data2 = URLSession.shared.data(from: AppConstant.images[1])
        
        return (try await data1.0, try await data2.0)
    }
     */
    
    // Second approach
    func downloadImages() {
        Task {
            do {
                async let data1 = await URLSession.shared.data(from: AppConstant.images.first!)
                async let data2 = await URLSession.shared.data(from: AppConstant.images[1])
                
                // 1. First approach
                /*
                let images = try await [data1, data2]
                guard let firstImage = UIImage(data: images.first!.0),
                      let secondImage = UIImage(data: images[1].0) else {
                    return
                }
                 */
                
                // 2. Second approach
                guard let firstImage = try await UIImage(data: data1.0),
                      let secondImage = try await UIImage(data: data2.0) else {
                    return
                }
                firstImageView.image = firstImage
                secondImageView.image = secondImage
                hideLoader()
            } catch {
                print("*** Received error while downloading image: \(error) ***")
                hideLoader()
            }
        }
    }
}


