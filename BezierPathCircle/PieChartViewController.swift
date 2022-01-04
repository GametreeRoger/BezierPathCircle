//
//  PieChartViewController.swift
//  BezierPathCircle
//
//  Created by 張又壬 on 2022/1/3.
//

import UIKit

class PieChartViewController: UIViewController {

    @IBOutlet weak var pieChartView: UIView!
    static let ANIMATION_DURATION = 1.5
    let aDegree = CGFloat.pi / 180
    let radius: CGFloat = 100
    var startDegree: CGFloat = 270
    
    var percentages: [CGFloat] = [25, 40, 35]
    var pies: [CAShapeLayer] = {
        var layerArray = [CAShapeLayer]()
        for i in 0..<3 {
            let layer = CAShapeLayer()
            layer.fillColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
            layerArray.append(layer)
        }
        return layerArray
    }()
    var pieIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for (index, percentage) in percentages.enumerated() {
            pieChartView.layer.addSublayer(pies[index])
        }
        addSlice()
    }

    func getPieChartViewCenter() -> CGPoint {
        return CGPoint(x: pieChartView.bounds.width / 2, y: pieChartView.bounds.width / 2)
    }
    
    func getDuration(percent: CGFloat) -> CFTimeInterval {
        let percentage = percent / 100.0
        return CFTimeInterval(percentage / 1.0 * PieChartViewController.ANIMATION_DURATION)
    }
    
    func createLabel(percentage: CGFloat, startDegree: CGFloat) -> UILabel {
        let textCenterDegree = startDegree + 360 * percentage / 2 / 100
        let center = getPieChartViewCenter()
        let textPath = UIBezierPath(arcCenter: center, radius: radius / 2, startAngle: aDegree * textCenterDegree, endAngle: aDegree * textCenterDegree, clockwise: true)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 8)
        label.text = "\(percentage)%"
        label.sizeToFit()
        label.center = textPath.currentPoint
        return label
    }
    
    func addSlice() {
        print("addSlice: Index:\(pieIndex)")
        let percentage = percentages[pieIndex]
        let endDegree = startDegree + 360 * percentage / 100
        let percentagePath = UIBezierPath()
        percentagePath.move(to: getPieChartViewCenter())
        percentagePath.addArc(withCenter: getPieChartViewCenter(), radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
        percentagePath.close()
        
        pies[pieIndex].path = percentagePath.cgPath
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = 1.1
        animation.duration = getDuration(percent: percentages[pieIndex])
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.delegate = self
        pies[pieIndex].add(animation, forKey: nil)
        
        pieChartView.addSubview(createLabel(percentage: percentage, startDegree: startDegree))
        startDegree = endDegree
    }
}

extension PieChartViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            pieIndex += 1
            if pieIndex < pies.count {
                addSlice()
            }
        }
    }
}
