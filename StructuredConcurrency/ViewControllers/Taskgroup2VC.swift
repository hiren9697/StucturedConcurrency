//
//  Taskgroup2VC.swift
//  StructuredConcurrency
//
//  Created by Hirenkumar Fadadu on 07/04/24.
//

import UIKit

typealias ImageData = (image: UIImage, text: String)

// MARK: - VC
class Taskgroup2VC: ParentVC {
    
    @IBOutlet weak private var tableView: UITableView!
    
    let client: Client = Client()
    var images: [ImageData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - IBAction(s)
extension Taskgroup2VC {
    
    @IBAction func btnDownloadImagesTap() {
        showLoader()
        Task {
            do {
                images = try await downloadImages()
                tableView.reloadData()
                hideLoader()
            } catch {
                print("*** Error in downloading images: \(error) ***")
                hideLoader()
            }
        }
    }
}

// MARK: - Helper method(s)
extension Taskgroup2VC {
    
    private func setupUI() {
        tableView.register(UINib(nibName: "ImageTC",
                                 bundle: nil),
                           forCellReuseIdentifier: "ImageTC")
    }
    
    private func downloadImages() async throws -> [ImageData] {
        var images: [ImageData] = []
        
        try await withThrowingTaskGroup(of: ImageData.self) { group in
            for url in AppConstant.images {
                group.addTask {
                    let data = try await self.client.downloadWrapper(url: url)
                    let image = UIImage(data: data)!
                    return (image, url.absoluteString)
                }
            }
            
            for try await data in group {
                images.append(data)
            }
        }
        
        return images
    }
}

// MARK: - TableView method(s)
extension Taskgroup2VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTC",
                                                       for: indexPath) as? ImageTC else {
            return UITableViewCell()
        }
        cell.updateUI(image: images[indexPath.row].image,
                      text: images[indexPath.row].text)
        return cell
    }
    
    
}
