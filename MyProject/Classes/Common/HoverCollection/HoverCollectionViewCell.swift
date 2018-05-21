//
//  HoverCollectionViewCell.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/5/21.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit

class HoverCollectionViewCell: UICollectionViewCell {
    
    var imgView : UIImageView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        imgView = UIImageView()
        imgView.backgroundColor = UIColor.qmui_random()
        self.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
