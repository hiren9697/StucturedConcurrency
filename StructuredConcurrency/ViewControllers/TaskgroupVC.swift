//
//  TaskgroupVC.swift
//  StructuredConcurrency
//
//  Created by Hirenkumar Fadadu on 07/04/24.
//

import UIKit

// MARK: - VC
class TaskgroupVC: ParentVC {
    
    @IBOutlet weak private var tableView: UITableView!
    
    let client: Client = Client()
    var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - IBAction(s)
extension TaskgroupVC {
    
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
extension TaskgroupVC {
    
    private func setupUI() {
        tableView.register(UINib(nibName: "ImageTC",
                                 bundle: nil),
                           forCellReuseIdentifier: "ImageTC")
    }
    
    private func downloadImages() async throws -> [UIImage] {
        var images: [UIImage] = []
        
        try await withThrowingTaskGroup(of: Data.self) { group in
            for url in AppConstant.images {
                group.addTask {
                    try await self.client.downloadWrapper(url: url)
                }
            }
            
            for try await data in group {
                if let image = UIImage(data: data) {
                    images.append(image)
                }
            }
        }
        
        return images
    }
}

// MARK: - TableView method(s)
extension TaskgroupVC: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.updateUI(image: images[indexPath.row], text: "Don't know")
        return cell
    }
    
    
}
