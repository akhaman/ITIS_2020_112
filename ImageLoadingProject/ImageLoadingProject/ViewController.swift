//
//  ViewController.swift
//  ImageLoadingProject
//
//  Created by Teacher on 16.11.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum Row {
        case image(title: String, urlString: String)
        case largeImage(title: String, previewUrlString: String, urlString: String)
    }

    private var rows: [Row] = [
        .image(
            title: "Guinea pig",
            urlString: "https://news.clas.ufl.edu/files/2020/06/AdobeStock_345118478-copy-1440x961-1.jpg"
        ),
        .largeImage(
            title: "Large satellite photo",
            previewUrlString: "https://ichef.bbci.co.uk/news/976/cpsprodpb/F3BC/production/_113769326_1.jpg",
            urlString: "https://www.dropbox.com/s/vylo8edr24nzrcz/Airbus_Pleiades_50cm_8bit_RGB_Yogyakarta.jpg?dl=1"
        )
    ]
    
    // MARK: - Navigation
    
    func showLargeImageController(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let controller = storyboard?.instantiateViewController(identifier: "LargeImageController") as! LargeImageController
        controller.imageUrl = url
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - TableViewDataSource, TableViewDelegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ImageCell else {
            fatalError("Could not dequeue cell")
        }
        
        switch rows[indexPath.row] {
        case .image(let title, let urlString):
            cell.title = title
            cell.imageUrl = URL(string: urlString)
        case .largeImage(let title, let previewUrlString, _):
            cell.title = title
            cell.imageUrl = URL(string: previewUrlString)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch rows[indexPath.row] {
        case .largeImage(_, _, let urlString):
            showLargeImageController(urlString: urlString)
        default: break
        }
    }
}

