//
//  CustomHeaderView.swift
//  Crummy
//
//  Created by Josh Nagel on 4/24/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {

  var width: CGFloat!
  
   convenience init() {
    self.init()
  }
  
  init(width: CGFloat) {
    self.width = width
    super.init(frame: CGRect(x: 0, y: 0, width: self.width, height: 32))
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func drawRect(rect: CGRect) {
    //// General Declarations
    let context = UIGraphicsGetCurrentContext()
    
    //// Color Declarations
    let color = UIColor(red: 0.048, green: 0.264, blue: 0.541, alpha: 1.000)
    let shadowColor = UIColor(red: 0.539, green: 0.532, blue: 0.532, alpha: 1.000)
    let gradient2Color = UIColor(red: 0.060, green: 0.158, blue: 0.408, alpha: 1.000)
    
    //// Gradient Declarations
    let gradient2 = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [color.CGColor, gradient2Color.CGColor], [0, 1])
    
    //// Shadow Declarations
    let shadow = NSShadow()
    shadow.shadowColor = shadowColor
    shadow.shadowOffset = CGSizeMake(0.1, -0.1)
    shadow.shadowBlurRadius = 5
    
    //// Rectangle Drawing
    let rectanglePath = UIBezierPath(rect: CGRectMake(0, 0, self.width, 32))
    CGContextSaveGState(context)
    rectanglePath.addClip()
    CGContextDrawLinearGradient(context, gradient2, CGPointMake(300, -0), CGPointMake(300, 32), CGGradientDrawingOptions(rawValue: 0))
    //CGContextDrawLinearGradient(context, gradient2, CGPointMake(300, -0), CGPointMake(300, 32), 0)
    CGContextRestoreGState(context)
    
    ////// Rectangle Inner Shadow
    CGContextSaveGState(context)
    CGContextClipToRect(context, rectanglePath.bounds)
    CGContextSetShadow(context, CGSizeMake(0, 0), 0)
    CGContextSetAlpha(context, CGColorGetAlpha((shadow.shadowColor as! UIColor).CGColor))
    CGContextBeginTransparencyLayer(context, nil)
    let rectangleOpaqueShadow = (shadow.shadowColor as! UIColor).colorWithAlphaComponent(1)
    CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, rectangleOpaqueShadow.CGColor)
    CGContextSetBlendMode(context, .SourceOut)
    CGContextBeginTransparencyLayer(context, nil)
    
    rectangleOpaqueShadow.setFill()
    rectanglePath.fill()
    
    CGContextEndTransparencyLayer(context)
    CGContextEndTransparencyLayer(context)
    CGContextRestoreGState(context)
  }
}

extension UIColor {
  func blendedColorWithFraction(fraction: CGFloat, ofColor color: UIColor) -> UIColor {
    var r1: CGFloat = 1.0, g1: CGFloat = 1.0, b1: CGFloat = 1.0, a1: CGFloat = 1.0
    var r2: CGFloat = 1.0, g2: CGFloat = 1.0, b2: CGFloat = 1.0, a2: CGFloat = 1.0
    
    self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
    
    return UIColor(red: r1 * (1 - fraction) + r2 * fraction,
      green: g1 * (1 - fraction) + g2 * fraction,
      blue: b1 * (1 - fraction) + b2 * fraction,
      alpha: a1 * (1 - fraction) + a2 * fraction);
  }
}
