//
//  LottieViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/9/14.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LottieViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Lottie"
        
        let toggle = LOTAnimatedSwitch.init(named: "Switch")
        toggle.setProgressRangeForOffState(fromProgress: 0, toProgress: 0.5)
        toggle.setProgressRangeForOnState(fromProgress: 0.5, toProgress: 1)
        
        toggle.rx.isOn.asObservable().subscribe( onNext:{
            DLog("The switch is \($0)")
        }).disposed(by: disposeBag)
        
        
        let heart = LOTAnimatedSwitch.init(named: "TwitterHeart")
        heart.rx.isOn.asObservable().subscribe( onNext:{
            DLog("The heart is \($0)")
        }).disposed(by: disposeBag)
        
        
        view.addSubview(toggle)
        view.addSubview(heart)
        
        toggle.center = CGPoint.init(x: self.view.bounds.width/2.0, y: 150)
        heart.center = CGPoint.init(x: self.view.bounds.width/2.0, y: 350)
        heart.bounds = CGRect.init(x: 0, y: 0, width: 200, height: 200)
        
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


extension Reactive where Base: LOTAnimatedSwitch {
    
    /// Reactive wrapper for `isOn` property.
    public var isOn: ControlProperty<Bool> {
        return value
    }
    
    /**
     Reactive wrapper for `isOn` property.
     
     **⚠️ Versions prior to iOS 10.2 were leaking `UISwitch`s, so on those versions
     underlying observable sequence won't complete when nothing holds a strong reference
     to UISwitch.⚠️**
     */
    public var value: ControlProperty<Bool> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { uiSwitch in
                uiSwitch.isOn
        }, setter: { uiSwitch, value in
            uiSwitch.isOn = value
        }
        )
    }
    func controlPropertyWithDefaultEvents<T>(
        editingEvents: UIControl.Event = [.allEditingEvents, .valueChanged],
        getter: @escaping (Base) -> T,
        setter: @escaping (Base, T) -> ()
        ) -> ControlProperty<T> {
        return controlProperty(
            editingEvents: [.allEditingEvents, .valueChanged],
            getter: getter,
            setter: setter
        )
    }
    
    
}


