//
//  Constants.swift
//  StructuredConcurrency
//
//  Created by Hirenkumar Fadadu on 07/04/24.
//

import UIKit

struct AppConstant {
    static let images: [URL] = [
        URL(string: "https://reqres.in/img/faces/7-image.jpg")!,
        URL(string: "https://reqres.in/img/faces/8-image.jpg")!,
        URL(string: "https://reqres.in/img/faces/9-image.jpg")!,
        URL(string: "https://reqres.in/img/faces/10-image.jpg")!,
        URL(string: "https://reqres.in/img/faces/11-image.jpg")!,
        URL(string: "https://reqres.in/img/faces/12-image.jpg")!
    ]
}

class Client {
    
    func downloadImage(url: URL, completion: @escaping (Result<Data, Error>)-> Void) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func downloadWrapper(url: URL) async throws -> Data {
        return try await withUnsafeThrowingContinuation { continuation in
            downloadImage(url: url) { result in
                continuation.resume(with: result)
            }
        }
    }

}
