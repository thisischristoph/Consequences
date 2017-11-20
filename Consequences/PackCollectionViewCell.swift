//
//  PackCollectionViewCell.swift
//  Consequences
//
//  Created by Christopher Harrison on 16/11/2017.
//  Copyright © 2017 Christopher Harrison. All rights reserved.
//

import UIKit

class PackCollectionViewCell: UICollectionViewCell {
    
    
    
    var backgroundPack: UIImageView!
    var foregroundPack: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let cellWidth = self.frame.width
        let cellHeight = self.frame.height
        
        let backgroundPackWidth = cellWidth*0.8
        let backgroundPackHeight = backgroundPackWidth*1.6
        let backgroundPackX = (cellWidth/2) - (backgroundPackWidth/2)
        let backgroundPackY = (cellHeight/2)-(backgroundPackHeight/2)
        
        backgroundPack = UIImageView(frame: CGRect(x: backgroundPackX, y: backgroundPackY, width: backgroundPackWidth, height: backgroundPackHeight))
        backgroundPack.backgroundColor = .lightGray
        backgroundPack.layer.cornerRadius = backgroundPack.bounds.width/8
        backgroundPack.clipsToBounds = false
        backgroundPack.layer.shadowColor = UIColor.black.cgColor
        backgroundPack.layer.shadowOpacity = 1
        backgroundPack.layer.shadowOffset = CGSize(width: 0.0, height: 3)
        backgroundPack.layer.shadowRadius = cellWidth*0.03
        backgroundPack.layer.shadowPath = UIBezierPath(roundedRect: backgroundPack.bounds, cornerRadius: backgroundPack.layer.cornerRadius).cgPath
        backgroundPack.layer.borderColor = UIColor.gray.cgColor
        backgroundPack.layer.borderWidth = 2.5
        contentView.addSubview(backgroundPack)
        
        let foregroundPackWidth = backgroundPackWidth
        let foregroundPackHeight = backgroundPackHeight
        let foregroundPackX = backgroundPackX
        let foregroundPackY = backgroundPackY
        
        foregroundPack = UIImageView(frame: CGRect(x: foregroundPackX, y: foregroundPackY, width: foregroundPackWidth, height: foregroundPackHeight))
        foregroundPack.backgroundColor = .red
        foregroundPack.layer.cornerRadius = backgroundPack.layer.cornerRadius
        contentView.addSubview(foregroundPack)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
