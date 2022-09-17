//
//  CustomView.swift
//  Marvel
//
//  Created by Naglaa Ogabih on 16/09/2022.
//

import UIKit

@IBDesignable
class CustomView: UIView {

    @IBInspectable var offset:    CGFloat = 10        { didSet { setNeedsDisplay() } }
    @IBInspectable var fillColor: UIColor = .white      { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: bounds.minX + offset, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX - offset, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))

        // Close the path. This will create the last line automatically.
        path.close()
        fillColor.setFill()
        path.fill()
    }
}
