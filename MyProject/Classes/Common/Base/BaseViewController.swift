//
//  BaseViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/5/21.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var rightBarButtonImage: UIImage = UIImage(){
        didSet{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightBarButtonImage, style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightButtonAction(button:)))
        }
    }
    
    
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

    }
    
    @objc func goback(button : UIButton){
        
        if (navigationController?.viewControllers.count)!>1 {
            navigationController?.popViewController(animated: true)
        }
        print("back")
    }
    
    @objc func rightButtonAction(button : UIButton){
        print("right")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        DLog("\(self) deinit")
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
