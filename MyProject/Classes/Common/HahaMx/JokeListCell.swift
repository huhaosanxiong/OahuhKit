//
//  JokeListCell.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/11/2.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

let SCREENWIDTH = UIScreen.main.bounds.size.width

class JokeListCell: UITableViewCell {
    
    static let widthRatio = 0.8
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let publishTimeLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    let contentLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var model: JokeModel = JokeModel(){
        
        didSet{
            
            let imagePath = imageDomain + model.pic.path + imageQuality.middle.quality + model.pic.name
            
            avatarImageView.kf.setImage(with: URL(string: model.user_pic))
            usernameLabel.text = model.user_name
            publishTimeLabel.text = model.time
            contentLabel.text = model.content
            contentImageView.kf.setImage(with: URL(string: imagePath))
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(publishTimeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(contentImageView)
        
        avatarImageView.snp.makeConstraints { make in
            make.left.top.equalTo(contentView).offset(10)
            make.width.height.equalTo(30)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.top.equalTo(avatarImageView.snp.top)
        }
        
        publishTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(usernameLabel.snp.left)
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(15)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        contentImageView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.width.equalTo(contentView.snp.width).multipliedBy(JokeListCell.widthRatio)
            make.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        DLog("prepareForReuse")
    }

}
