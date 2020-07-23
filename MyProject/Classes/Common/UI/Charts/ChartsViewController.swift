//
//  ChartsViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/7/19.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: BaseViewController {
    
    //折线图
    var chartView : LineChartView!

    lazy var scrollerView :UIScrollView = {
        
        let scroll = UIScrollView.init(frame: self.view.bounds)
        
        self.view.addSubview(scroll)
        
        return scroll
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Charts"
        
    }
    
    override func initSubviews() {
        
        chartView = LineChartView()
        chartView.delegate = self
        self.scrollerView.addSubview(chartView)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        
        //添加限制线
        let litmitLine = ChartLimitLine(limit: 80, label: "限制线")
        litmitLine.lineWidth = 2
        litmitLine.lineColor = UIColor.green
        litmitLine.lineDashLengths = [5.0,5.0] //虚线样式
        litmitLine.labelPosition = .topRight  // 限制线位置
        litmitLine.valueTextColor = UIColor.brown
        litmitLine.valueFont = UIFont.systemFont(ofSize: 12)
        chartView.leftAxis.addLimitLine(litmitLine)
        chartView.leftAxis.drawLimitLinesBehindDataEnabled = true  //设置限制线绘制在折线图的后面
        
        //设置折线图描述及图例样式
        chartView.chartDescription?.text = "折线图" //折线图描述
        chartView.chartDescription?.textColor = UIColor.cyan  //描述字体颜色
        chartView.legend.form = .line  // 图例的样式
        chartView.legend.formSize = 20  //图例中线条的长度
        
        chartView.animate(xAxisDuration: 1)  //设置动画时间
        
        chartView.snp.makeConstraints { make in
            make.center.equalTo(self.view.snp.center)
            make.width.height.equalTo(self.view.bounds.size.width)
        }
        
        var data = [ChartDataEntry]()
        
        for i in 0..<20 {
            let y = arc4random()%100
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            data.append(entry)
        }
        
        //20个数据作为一条折线里的数据
        let chartDataSet = LineChartDataSet.init(entries: data, label: "line 1")
        chartDataSet.drawCircleHoleEnabled = false  //不绘制转折点内圆
        chartDataSet.drawCirclesEnabled = false //不绘制转折点
        //一根折线
        let chartData = LineChartData.init(dataSets: [chartDataSet])
        
        chartView.data = chartData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ChartsViewController : ChartViewDelegate {
    
    
}

