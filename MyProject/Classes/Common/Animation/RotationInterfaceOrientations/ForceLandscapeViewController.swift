//
//  ForceLandscapeViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2019/4/24.
//  Copyright © 2019 胡浩三雄. All rights reserved.
//

import UIKit

class ForceLandscapeViewController: BaseViewController {

    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "ForceLandscapeViewController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appdelegate.interfaceOrientations = [.landscapeLeft, .landscapeRight]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        appdelegate.interfaceOrientations = .portrait
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
