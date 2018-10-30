//
//  PushTransitionViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/10/29.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class PushTransitionViewController: UIViewController {
    
    var dismissButton: UIButton = {
        let button = UIButton.init(type: UIButtonType.system)
        button.setTitle("Dimiss", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
    
    var pushButton: UIButton = {
        let button = UIButton.init(type: UIButtonType.system)
        button.setTitle("Push", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        return button
    }()
    
    var label: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Transition"
        label.textColor = .black
        
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        initSubviews()
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pushAction() {
        let vc = PopTransitionViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func initSubviews() {
        view.addSubview(dismissButton)
        view.addSubview(pushButton)
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-30)
            make.top.equalTo(view).offset(30)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.left.equalTo(50)
            make.width.height.equalTo(50)
        }
        
        pushButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-50)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(50)
        }
        
        dismissButton.layer.cornerRadius = 25
        pushButton.layer.cornerRadius = 25
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
