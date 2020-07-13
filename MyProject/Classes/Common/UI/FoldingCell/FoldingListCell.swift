//
//  FoldingCell.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/11/7.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import Foundation

class FoldingListCell: FoldingCell {
    
    static let itemHeight = 130
    static let space = 10
    static let count = 2
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        imageView.image = Asset.img1145.image
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = ColorHex("#ff6666")
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        } else {
            label.font = UIFont.systemFont(ofSize: 10)
        }
        label.text = "GAMING: OVERWATCH"
        return label
    }()
    
    let subTitleLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = ColorHex("#ff9999")
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.thin)
        } else {
            label.font = UIFont.systemFont(ofSize: 10)
        }
        label.text = "HERO: Angela Ziegler & Fareeha·Amari"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        itemCount = FoldingListCell.count
        
        containerView = createContainerView()
        foregroundView = createForegroundView()
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        //设置折叠时的背景颜色
        backViewColor = ColorHex("#ffdddd")
        
        setupSubviews()
        
        //override super func
        commonInit()
        
        
        
    }
    
    func setupSubviews() {
        
        
        /*折叠时的view*/
        foregroundView.addSubview(avatarImageView)
        foregroundView.addSubview(usernameLabel)
        foregroundView.addSubview(subTitleLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.left.equalTo(foregroundView).offset(FoldingListCell.space)
            make.bottom.equalTo(foregroundView.snp.bottom).offset(-FoldingListCell.space)
            make.width.equalTo(avatarImageView.snp.height).multipliedBy((100.0/63.0))
        }
        usernameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(FoldingListCell.space)
            make.top.equalTo(avatarImageView.snp.top)
            make.right.equalTo(foregroundView.snp.right).offset(-FoldingListCell.space)
            make.height.equalTo(avatarImageView.snp.height).multipliedBy(0.5)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(FoldingListCell.space)
            make.bottom.equalTo(avatarImageView.snp.bottom)
            make.right.equalTo(foregroundView.snp.right).offset(-FoldingListCell.space)
            make.height.equalTo(avatarImageView.snp.height).multipliedBy(0.5)
        }
        
        
        /*未折叠时的view*/
        
        let view1 = FoldingCellContainerView.init(frame: CGRect.zero)
        let view2 = FoldingCellContainerView.init(frame: CGRect.zero)

        
        containerView.addSubview(view1)
        containerView.addSubview(view2)

        
        view1.snp.makeConstraints { make in
            make.left.top.equalTo(containerView)
            make.right.equalTo(containerView)
            make.height.equalTo(FoldingListCell.itemHeight)
        }
        
        view2.snp.makeConstraints { make in
            make.top.equalTo(view1.snp.bottom)
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.height.equalTo(FoldingListCell.itemHeight)
        }
        
        
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.2, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: Configure

extension FoldingListCell {
    
    private func createForegroundView() -> RotatedView {
        
        let foregroundView = RotatedView()
        foregroundView.backgroundColor = UIColor.white
        foregroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(foregroundView)
        
        // add constraints
        foregroundView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(FoldingListCell.space)
            make.right.equalTo(contentView).offset(-FoldingListCell.space)
            make.height.equalTo(FoldingListCell.itemHeight)
        }
        
        // add identifier
        let top = NSLayoutConstraint.init(item: foregroundView,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: CGFloat(FoldingListCell.space))

        top.identifier = "ForegroundViewTop"
        foregroundView.superview?.addConstraint(top)
        foregroundView.layoutIfNeeded()
        foregroundViewTop = top
        return foregroundView
    }
    
    private func createContainerView() -> UIView {
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // add constraints
        containerView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(FoldingListCell.space)
            make.right.equalTo(contentView).offset(-FoldingListCell.space)
            make.height.equalTo(FoldingListCell.itemHeight*itemCount)
        }
        
        // add identifier
        let top = NSLayoutConstraint.init(item: containerView,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: contentView,
                                          attribute: .top,
                                          multiplier: 1.0,
                                          constant: CGFloat(FoldingListCell.space))
        
        top.identifier = "ContainerViewTop"
        containerView.superview?.addConstraint(top)
        containerView.layoutIfNeeded()
        containerViewTop = top
        return containerView
    }
}



class FoldingCellContainerView: UIView {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        imageView.image = Asset.wallhaven578223.image
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = ColorHex("#ff6666")
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        } else {
            label.font = UIFont.systemFont(ofSize: 10)
        }
        label.text = "GAMING: OVERWATCH"
        return label
    }()
    
    let subTitleLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = ColorHex("#ff9999")
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.thin)
        } else {
            label.font = UIFont.systemFont(ofSize: 10)
        }
        label.text = "HERO: D.VA, TRACER etc."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(avatarImageView)
        self.addSubview(usernameLabel)
        self.addSubview(subTitleLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(FoldingListCell.space)
            make.bottom.equalTo(self.snp.bottom).offset(-FoldingListCell.space)
            make.width.equalTo(avatarImageView.snp.height).multipliedBy((100.0/63.0))
        }
        usernameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(FoldingListCell.space)
            make.top.equalTo(avatarImageView.snp.top)
            make.right.equalTo(self.snp.right).offset(-FoldingListCell.space)
            make.height.equalTo(avatarImageView.snp.height).multipliedBy(0.5)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(FoldingListCell.space)
            make.bottom.equalTo(avatarImageView.snp.bottom)
            make.right.equalTo(self.snp.right).offset(-FoldingListCell.space)
            make.height.equalTo(avatarImageView.snp.height).multipliedBy(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

