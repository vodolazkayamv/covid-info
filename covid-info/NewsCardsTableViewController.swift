//
//  NewsCardsTableViewController.swift
//  covid-info
//
//  Created by Masha Vodolazkaya on 01/04/2020.
//  Copyright © 2020 Masha Vodolazkaya. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class NewsCardsTableViewController : UITableViewController {
    var articles : [NewsArticle] = [] {
        didSet {
            print(articles.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
       
        let cardView : UIView = cell.viewWithTag(10) as! UIView
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.systemIndigo.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 3.0

        let article = articles[indexPath.row]
        let titleLabel = cell.viewWithTag(2) as! UILabel
        titleLabel.text = article.title
        
        if let update : Date = article.publishedAt {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            formatter.locale = Locale.current
            
            let upstring = formatter.string(from: update)
            
            let label : UILabel = cell.viewWithTag(3) as! UILabel
            label.text = upstring
        }
        
        
        let descriptionLabel = cell.viewWithTag(4) as! UILabel
        descriptionLabel.text = article.description
        
        let imageView : UIImageView = cell.viewWithTag(11) as! UIImageView
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.image = UIImage.init(named: "placeholder")
        if article.urlToImage.contains("http") {
            imageView.downloadImageFrom(link:  article.urlToImage, contentMode: .scaleAspectFill)
        } else {
            let urlString = "https" + article.urlToImage
            imageView.downloadImageFrom(link: urlString, contentMode: .scaleAspectFill)

        }
        
        
       return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        
        if let url = URL(string: article.url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
}

extension UIImageView {
    func load(url: URL?) {
        guard let url = url else {return}
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        guard let url = URL(string: link) else {return}
        URLSession.shared.dataTask( with: url, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}
