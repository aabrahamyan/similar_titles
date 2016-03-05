//
//  STSimilarsTableViewCell.swift
//  SimilarTitles
//
//  Created by Armen Abrahamyan on 1/30/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import UIKit

class STSimilarsTableViewCell: UITableViewCell {

    // Could have been used cell title, but added custom one from maitanability perspecitves
    @IBOutlet weak var imageTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
