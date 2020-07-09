//
//  WaveLodingViewController.swift
//  MyProject
//
//  Created by huhsx on 2020/7/7.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

class WaveLodingViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    // MARK: View
    private lazy var lightWaveView: WaveView = {
        var view = WaveView()
        view.backgroundColor = .clear
        view.fillColor = randomColor(hue: .blue, luminosity: .light)
        
        return view
    }()
    
    private lazy var darkWaveView: WaveView = {
        var view = WaveView()
        view.phiModifier = 1 // 调整初相，防止和另一个波浪完全重合
        view.backgroundColor = .clear
        view.fillColor = randomColor(hue: .blue, luminosity: .dark)
        
        return view
    }()
    
    var progress: CGFloat = 0
    
    var displayLink: CADisplayLink?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Wave"
        
        view.backgroundColor = randomColor()
        
        let switchButton = UISwitch()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switchButton)

        switchButton.rx.isOn.asObservable()
            .subscribe(onNext: {[weak self] (status) in

                guard let s = self else { return }
                
                DLog("switch status = \(status)")
                
                if status {

                    s.startAnimation()
                }else {

                    s.stopAnimation()
                }
                
            }).disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopAnimation()
    }
    
    override func initSubviews() {
        
        view.addSubview(lightWaveView)
        view.addSubview(darkWaveView)
        
        let frame = CGRect(x: (SCREEN_WIDTH - 200) / 2.0, y: 200, width: 200, height: 200)
        
        lightWaveView.frame = frame
        darkWaveView.frame = frame
        
        let lightMask = CircleView()
        lightMask.frame = lightWaveView.bounds
        lightWaveView.mask = lightMask

        let darkMask = CircleView()
        darkMask.frame = darkWaveView.bounds
        darkWaveView.mask = darkMask
        
    }
    
    private func startAnimation() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(refreshAction))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    private func stopAnimation() {
        
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc func refreshAction() {

        if progress > 1 {
            progress = 0
        }else {
            progress += 0.001
        }
        
        lightWaveView.progress = progress
        darkWaveView.progress = progress
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
