//
//  CategoryHeaderView.swift
//  MovieDB
//
//  Created by MacBook on 23/04/22.
//

import UIKit

class CategoryHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    
    static var identifier : String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
}
