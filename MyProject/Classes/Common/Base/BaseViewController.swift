//
//  BaseViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/5/21.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = (self.navigationController?.viewControllers.count)! > 1 ? false:true
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.automatic
        } else {
            // Fallback on earlier versions
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = (self.navigationController?.viewControllers.count)! > 1 ? true:false
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.automatic
        } else {
            // Fallback on earlier versions
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        if (navigationController != nil) && (navigationController?.viewControllers.count)! > 1 {
            self.navigationItem.hidesBackButton = true;
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: Icon.arrowBack, style: UIBarButtonItem.Style.plain, target: self, action: #selector(goback(button:)))
            self.navigationItem.leftItemsSupplementBackButton = true;
            
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        }
        
        bindViewModel()
        
        initSubviews()
    }
    
    func initSubviews() {
        
    }

    func bindViewModel() {
        /*
        //async 0->9 在同一个线程上
        //sync 0->9 在main主线程上执行
        let serQueue = DispatchQueue.init(label: "name")
        
        //async 随机 每个线程地址不一样
        //sync 0->9 在main主线程上执行
        let conQueue = DispatchQueue.init(label: "name", attributes: .concurrent)
        
        for i in 0..<10 {
            serQueue.async {
                let thread = Thread.current
                DLog("\(i), \(thread)")
            }
        }
        */
    }
    
    @objc func goback(button : UIButton){
        
        if (navigationController?.viewControllers.count)!>1 {
            navigationController?.popViewController(animated: true)
        }
        print("back")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
