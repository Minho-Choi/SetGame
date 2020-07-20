//
//  SetCardView.swift
//  Set
//
//  Created by Minho Choi on 2020/07/10.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class SetShapeView: UIButton {

    var shape: String = "diamond" {didSet {setNeedsDisplay()}}// roundRec, diamond, squiggle
    var color: String = "purple" {didSet {setNeedsDisplay()}}// red, green, purple
    var number: Int = 3 {didSet {setNeedsDisplay()}}
    var fill: String = "half" {didSet {setNeedsDisplay()}}// full, half, none
    
    private var centerArray: [CGPoint] {
        if number == 1 {
            return [CGPoint(x: bounds.midX, y: bounds.midY)]
        }
        else if number == 2 {
            return [CGPoint(x: bounds.midX, y: bounds.midY - varInterval), CGPoint(x: bounds.midX, y: bounds.midY + varInterval)]
        } else {
            return [CGPoint(x: bounds.midX, y: bounds.midY - 2*varInterval), CGPoint(x: bounds.midX, y: bounds.midY), CGPoint(x: bounds.midX, y: bounds.midY + 2*varInterval)]
        }
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        for centerIndex in 0..<number {
            let center = centerArray[centerIndex]
            if shape == "roundRec" {
                path.move(to: CGPoint(x: center.x + width, y: center.y - radius))
                path.addArc(withCenter: CGPoint(x: center.x + width, y: center.y), radius: radius, startAngle: 3*CGFloat.pi/2, endAngle: CGFloat.pi/2, clockwise: true)
                path.addArc(withCenter: CGPoint(x: center.x - width, y: center.y), radius: radius, startAngle: CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
                path.close()
            } else if shape == "diamond" {
                path.move(to: CGPoint(x: center.x, y: center.y - radius))
                path.addLine(to: CGPoint(x: center.x, y: center.y - radius))
                path.addLine(to: CGPoint(x: center.x + radius + width, y: center.y))
                path.addLine(to: CGPoint(x: center.x, y: center.y + radius))
                path.addLine(to: CGPoint(x: center.x - radius - width, y: center.y))
                path.close()
            } else if shape == "squiggle" {
                path.move(to: CGPoint(x: center.x - width - radius/2,y: center.y - radius))
                path.addCurve(to: CGPoint(x: center.x + width + radius/2,y: center.y + radius), controlPoint1: CGPoint(x: center.x - width,y: center.y + radius/2), controlPoint2: CGPoint(x: center.x + 3 * width,y: center.y - 3 * radius))
                path.addCurve(to: CGPoint(x: center.x - width - radius/2,y: center.y - radius), controlPoint1: CGPoint(x: center.x + width,y: center.y - radius/2), controlPoint2: CGPoint(x: center.x - 3 * width,y: center.y + 3 * radius))
                path.close()
                path.lineJoinStyle = .round
            }
        }
        path.lineWidth = outerThickness
        if color == "red" {
            if fill == "full" {
                #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1).setFill()
            } else { UIColor.clear.setFill()}
            #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1).setStroke()
        } else if color == "green" {
            if fill == "full" {
                #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1).setFill()
            } else { UIColor.clear.setFill()}
            #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1).setStroke()
        } else {
            if fill == "full" {
               #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).setFill()
            } else { UIColor.clear.setFill()}
            #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).setStroke()
        }
        path.stroke()
        path.fill()
        for centerIndex in 0..<number {
            let center = centerArray[centerIndex]
            if fill == "half" {
                path.addClip()
                path.move(to: CGPoint(x: center.x + width + radius, y: center.y - radius))
                path.addLine(to: CGPoint(x: center.x + width + radius - xInterval, y: center.y - radius))
                for interval in 1..<16 {
                    path.addLine(to: CGPoint(x: center.x + width + radius - xInterval*CGFloat(interval), y: center.y + radius))
                    path.addLine(to: CGPoint(x: center.x + width + radius - xInterval*CGFloat(interval), y: center.y - radius))
                    path.addLine(to: CGPoint(x: center.x + width + radius - xInterval*CGFloat(interval + 1), y: center.y - radius))
                }
                path.lineWidth = innerThickness
                path.stroke()
            }
        }
    }

}

extension SetShapeView { /// 모양 크기 세팅
    
    private struct SizeRatio {
        static let suitRadiusToBoundsHeight: CGFloat = 0.1
        static let suitWidthToRadius: CGFloat = 1.2
        //static let cornerOffsetToCornerRadius: CGFloat = 0.33
    }
    private var radius: CGFloat {
        return bounds.size.height * SizeRatio.suitRadiusToBoundsHeight
    }
    private var width: CGFloat {
        return radius * SizeRatio.suitWidthToRadius
    }
    private var xInterval: CGFloat {
        return (width + radius)/8
    }
    private var outerThickness: CGFloat {
        return 30 * SizeRatio.suitRadiusToBoundsHeight
    }
    private var innerThickness: CGFloat {
        return 5 * SizeRatio.suitRadiusToBoundsHeight
    }
    private var varInterval: CGFloat {
        return 1.3*radius
    }
}
