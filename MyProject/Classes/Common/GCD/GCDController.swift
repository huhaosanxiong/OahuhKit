//
//  GCDController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2019/7/17.
//  Copyright © 2019 胡浩三雄. All rights reserved.
//

import UIKit

class GCDController: BaseViewController {

    
    var count = 50
    
    let semaphore = DispatchSemaphore(value: 1)
    
    let textView: UITextView = {
        
        let view = UITextView()
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "DispatchSemaphore"
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        }

        
        
        
        let queue1 = DispatchQueue(label: "1")
        
        queue1.async {
            self.soldTicket(station: "sz")
        }
        
        let queue2 = DispatchQueue(label: "2")
        
        queue2.async {
            self.soldTicket(station: "gz")
        }
    }
    
    
    
    func soldTicket(station: String) {
        
        while count > 0 {
            
            semaphore.wait()
            
            var log = ""
            
            if count > 0 {
                
                count -= 1
                
                log = "\(station)剩余\(count)张票"
                
                Thread.sleep(forTimeInterval: 0.2)
                
            }else {
                log = "\(station)已售完"
            }
            
            print(log)
            
            DispatchQueue.main.async {
                self.textView.text = self.textView.text + log + "\n"
            }
            
            semaphore.signal()
        }
    }

}
