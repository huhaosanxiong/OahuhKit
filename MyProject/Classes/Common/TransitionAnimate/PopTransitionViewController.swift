//
//  PopTransitionViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/10/29.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class PopTransitionViewController: UIViewController {
    
    var label: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.text = "Transition"
        label.textColor = .black
        
        return label
    }()
    
    var popButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.system)
        button.setTitle("Pop", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(popAction), for: .touchUpInside)
        return button
    }()
    
    @objc func popAction() {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray
        
        view.addSubview(label)
        view.addSubview(popButton)
        
//        label.snp.makeConstraints { make in
//            make.center.equalTo(view.snp.center)
//        }
        label.sizeToFit()
        label.center = view.center
        
        popButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-50)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(50)
        }
        popButton.layer.cornerRadius = 25
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

