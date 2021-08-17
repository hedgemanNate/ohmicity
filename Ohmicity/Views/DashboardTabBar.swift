//
//  DashboardTabBar.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/17/21.
//

import UIKit

class TabBarVC: UITabBar {

    private var shapeLayer: CALayer?
    
    
    private func addShape() {
        self.backgroundImage = UIImage()
        self.shadowImage = UIImage()
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = cc.tabBarPurple.cgColor
        shapeLayer.lineWidth = 1.0
        
        shapeLayer.shadowOffset = CGSize(width: 0, height: -5)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.5
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        }else{
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        self.addShape()
        self.unselectedItemTintColor = UIColor.white
        self.tintColor = UIColor(named: "dark-brown")
    }

    func createPath() -> CGPath {
        let height: CGFloat = 15
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: -20)) //start pos
        path.addQuadCurve(to: CGPoint(x: self.frame.width, y: -20), controlPoint: CGPoint(x: centerWidth, y: height))
        
        
        
        
        //close the path
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
        
    }
}
