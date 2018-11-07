//
//  GithubRepoListCell.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/10/26.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class GithubRepoListCell: UITableViewCell {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let orangizeLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var model: GithubRepository = GithubRepository(){
        
        didSet {
            avatarImageView.kf.setImage(with: URL(string: model.owner?["avatar_url"] as! String))
            titleLabel.text = model.name
            orangizeLabel.text = model.full_name
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(orangizeLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.left.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.width.equalTo(avatarImageView.snp.height).multipliedBy(1.618)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.top.equalTo(avatarImageView.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-5)
            make.height.equalTo(avatarImageView.snp.height).multipliedBy(0.5)
        }
        
        orangizeLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.bottom.equalTo(avatarImageView.snp.bottom)
            make.right.equalTo(contentView.snp.right).offset(-5)
            make.height.equalTo(avatarImageView.snp.height).multipliedBy(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
