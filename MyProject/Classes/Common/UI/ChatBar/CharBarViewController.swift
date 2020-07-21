//
//  CharBarViewController.swift
//  MyProject
//
//  Created by huhsx on 2020/7/21.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

class CharBarViewController: BaseViewController {
    
    let manager = ChatBarDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "CharBar"
        
        view.backgroundColor = ColorHex("#E0E0E0")
    }
    
    override func initSubviews() {
        
        let charBar = ChatBarView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - ChatBarHeight, width: SCREEN_WIDTH, height: ChatBarHeight))
        
        
        view.addSubview(charBar)
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
