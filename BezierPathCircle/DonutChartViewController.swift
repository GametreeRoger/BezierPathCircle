//
//  DonutChartViewController.swift
//  BezierPathCircle
//
//  Created by 張又壬 on 2021/12/22.
//

import UIKit

class DonutChartViewController: UIViewController {
    @IBOutlet weak var donutChartView: UIView!
    
    @IBOutlet weak var randomButton: UIButton!
    
    static let ANIMATION_DURATION: CGFloat = 1.4
    
    let aDegree = CGFloat.pi / 180
    let lineWidth: CGFloat = 40
    let radius: CGFloat = 50
    var startDegree: CGFloat = 270
    var percentages: [CGFloat] = [30, 30, 40]
    let percentageCount = 3
    var percentageIndex = 0
    
    let percentageDonuts: [CAShapeLayer] = {
        var layerArray = [CAShapeLayer]()
        for i in 0..<3 {
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
            layerArray.append(layer)
        }
        return layerArray
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for (index, _) in percentages.enumerated() {
            percentageDonuts[index].lineWidth = lineWidth
            donutChartView.layer.addSublayer(percentageDonuts[index])
        }
        addSlice()
    }
    
    func getDonutChartViewCenter() -> CGPoint {
        return CGPoint(x: donutChartView.bounds.width / 2, y: donutChartView.bounds.width / 2)
    }
    
    func getDuration(percent: CGFloat) -> CFTimeInterval {
        let percentage = percent / 100.0
        return CFTimeInterval(percentage / 1.0 * DonutChartViewController.ANIMATION_DURATION)
    }
    
    func addSlice() {
        let center = getDonutChartViewCenter()
        let percent = percentages[percentageIndex]
        let endDegree = startDegree + 360 * percent / 100
        let percentagePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
        percentageDonuts[percentageIndex].path = percentagePath.cgPath
        startDegree = endDegree
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = getDuration(percent: percent)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.delegate = self
        percentageDonuts[percentageIndex].strokeEnd = 1
        percentageDonuts[percentageIndex].add(animation, forKey: nil)
        
    }
    
    @IBAction func onRandom(_ sender: Any) {
        var newPercentages = [CGFloat]()
        let first = CGFloat.random(in: 1..<99)
        newPercentages.append(first)
        let second = CGFloat.random(in: 1..<(100 - first))
        newPercentages.append(second)
        newPercentages.append(100 - first - second)
        percentages = newPercentages
        
        startDegree = 270
        percentageIndex = 0
        percentageDonuts.forEach { layer in
            layer.path = nil
        }
        addSlice()
    }
    

}

extension DonutChartViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            percentageIndex += 1
            if percentageIndex < percentages.count {
                addSlice()
            }
        }
    }
}
