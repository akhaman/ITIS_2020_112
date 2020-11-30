//
//  LargeImageController.swift
//  ImageLoadingProject
//
//  Created by Руслан Ахмадеев on 29.11.2020.
//

import UIKit

class LargeImageController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private lazy var largeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    var imageUrl: URL? {
        didSet {
            loadImage()
        }
    }
    
    private func setupImageView(with data: Data) {
        let image = UIImage(data: data)
        largeImage.image = image
        scrollView.addSubview(largeImage)
        NSLayoutConstraint.activate([
            largeImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            largeImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            largeImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            largeImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    // MARK: - Helpers
    
    private func handleData(from url: URL) -> Data? {
        guard let reader = try? FileHandle(forReadingFrom: url) else { return nil }
        let data = reader.readDataToEndOfFile()
        return data
    }
    
    private func loadImage() {
        guard let imageUrl = imageUrl else { return }
        
        let configuration = URLSessionConfiguration.default
        let queue = OperationQueue()
        
        let session = URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: queue)
        
        let task = session.downloadTask(with: imageUrl)
        task.resume()
    }
}

// MARK: - URLSessionDownloadDelegate

extension LargeImageController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let data = handleData(from: location) else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.setupImageView(with: data)
            self?.progressView.removeFromSuperview()
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        let progress = totalBytesWritten / totalBytesExpectedToWrite
        
        DispatchQueue.main.async {
            self.progressView.setProgress(Float(progress), animated: true)
        }
    }
}
