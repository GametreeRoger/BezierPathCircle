//
//  ViewController.swift
//  BezierPathCircle
//
//  Created by 張又壬 on 2021/12/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var progressSlider: UISlider!
    
    
    let aDegree = CGFloat.pi / 180
    let lineWidth: CGFloat = 10
    let radius: CGFloat = 50
    let startDegree: CGFloat = 270
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let percentageCircle: CAShapeLayer = {
       let percentageLayer = CAShapeLayer()
        percentageLayer.fillColor = UIColor.clear.cgColor
        percentageLayer.strokeColor  = UIColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor
        percentageLayer.lineCap = .round
        return percentageLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progressCenter = getProgressViewCenter()
        
        let circlePath = UIBezierPath(ovalIn: CGRect(x: progressCenter.x - (radius), y: progressCenter.y - (radius), width: radius*2, height: radius*2))
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clear.cgColor
        
        percentageCircle.lineWidth = lineWidth
        percentagePath(percentage: 0.0)
        
        percentageLabel.frame = CGRect(x: 0, y: 0, width: progressView.bounds.width, height: progressView.bounds.height)
        percentageLabel.text = "\(0.0)%"

        progressView.layer.addSublayer(circleLayer)
        progressView.layer.addSublayer(percentageCircle)
        progressView.addSubview(percentageLabel)
        
    }
    
    func getProgressViewCenter() -> CGPoint {
        return CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.width / 2)
    }
    
    func percentagePath(percentage: CGFloat) {
        let progressCenter = getProgressViewCenter()
        let percentagePath = UIBezierPath(arcCenter: CGPoint(x: progressCenter.x, y: progressCenter.y), radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * (startDegree + 360 * percentage / 100), clockwise: true)
        percentageCircle.path = percentagePath.cgPath
        percentageLabel.text = "\(String(format: "%.1f", percentage))%"
    }

    @IBAction func onPercentage(_ sender: UISlider) {
        percentagePath(percentage: CGFloat(sender.value))
    }
    
    @IBAction func onAnimation(_ sender: UIButton) {
        print("animation")
        progressSlider.isEnabled = false
        percentageLabel.isHidden = true
        sender.isEnabled = false
        sender.setTitleColor(.gray, for: .disabled)
        
        let progressCenter = getProgressViewCenter()
        let percentagePath = UIBezierPath(arcCenter: CGPoint(x: progressCenter.x, y: progressCenter.y), radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * (startDegree + 360 * 1), clockwise: true)
        percentageCircle.path = percentagePath.cgPath
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { [self] in
            progressSlider.isEnabled = true
            progressSlider.value = 100
            percentageLabel.isHidden = false
            percentageLabel.text = "100.0%"
            sender.isEnabled = true
            sender.setTitleColor(.black, for: .normal)
        }
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(progressSlider.value) / 100.0
        animation.toValue = 1
        animation.duration = 1
        percentageCircle.add(animation, forKey: nil)
        CATransaction.commit()

    }
    
}

