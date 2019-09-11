//
//  DashBoardController.swift
//  MyProject
//
//  Created by huhsx on 2019/9/11.
//  Copyright © 2019 胡浩三雄. All rights reserved.
//

import UIKit

class DashBoardController: BaseViewController {

    private lazy var dashBoard: DashBoardView = {
        
        let view = DashBoardView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        
        return view
    }()
    
    private lazy var actionButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("开始测试", for: .normal)
        button.setTitle("停止测试", for: .selected)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(actionButtonClick(button:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "DashBoard"
        view.backgroundColor = .black
        
        view.addSubview(dashBoard)
        view.addSubview(actionButton)
        
        dashBoard.snp.makeConstraints { make in
            make.width.height.equalTo(view.snp.width)
            make.left.equalTo(view)
            make.top.equalTo(view.snp.top).offset(150)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(dashBoard.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.left.equalTo(view).offset(15)
            make.height.equalTo(50)
        }
        
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(sliderValue(slider:)), for: .valueChanged)
        view.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.top.equalTo(dashBoard.snp.bottom).offset(-30)
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(100)
        }
    }
    
    @objc func actionButtonClick(button: UIButton) {
        
        button.isSelected = !button.isSelected
        
        if button.isSelected {
            dashBoard.startAnimation()
        }else {
            dashBoard.stopAnimation()
        }
        
    }
    
    @objc func sliderValue(slider: UISlider) {
        print("\(slider.value)")
        dashBoard.setProgress(value: CGFloat(slider.value))
    }

}
