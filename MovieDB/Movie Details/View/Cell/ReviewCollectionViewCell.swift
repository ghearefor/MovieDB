//
//  ReviewCollectionViewCell.swift
//  MovieDB
//
//  Created by MacBook on 22/04/22.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblReviewerName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    static var identifier : String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgAvatar.layer.cornerRadius = 10
        imgAvatar.layer.masksToBounds = true
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.white.cgColor
        parentView.layer.cornerRadius = 10
        parentView.layer.masksToBounds = true
    }

    func bind(review: MovieReviews) {
        if review.authorDetails?.avatarPath?.isEmpty ?? true {
            imgAvatar.image = UIImage(systemName: "person")?.withTintColor(.darkGray)
        } else {
            imgAvatar.load(url: MovieAPI.endpoint.getImageOriginUrl(path: review.authorDetails?.avatarPath ?? "").path)
        }
        
        lblReviewerName.text = review.authorDetails?.username
        lblReview.text = review.content
    }
}
