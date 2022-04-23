//
//  UIImageView+Extensions.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import UIKit

extension UIImageView {
    func load(url: String) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
