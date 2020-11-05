//
//  LaunchSliderView.swift
//  Fonties
//
//  Created by Semyon on 03.11.2020.
//

import Foundation
import UIKit

enum LaunchScreenSide {
    case top
    case bottom
}

class LaunchSliderView:  UIView {
    
    let minHeightPercentage = 0.3
    let okHeightPercentage  = 0.5
    let maxHeightPercentage = 0.7
    
    var side: LaunchScreenSide!
    var viewSize: CGSize?
    var shapeColor: UIColor!
    var shape: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    convenience init(color: UIColor, side: LaunchScreenSide) {
        self.init(frame: .zero)
        
        self.shapeColor = color
        self.side       = side
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor.clear
    }
    override func draw(_ rect: CGRect) {
        // Создаем новую форму, в которую будем
        // записывать все изменения
        shape = CAShapeLayer()
        // Определяем размер зоны для расстановки точек фигуры
        viewSize = self.bounds.size
        // Устанавливаем для фигуры зону отрисовки
        shape!.frame = self.bounds
        // Устанавливаем цвет заливки
        shape!.fillColor = self.shapeColor.cgColor
        shape!.shadowColor = UIColor.black.cgColor
        shape!.shadowRadius = 8.0
        shape!.shadowOpacity = 0.9
        shape!.shadowOffset = CGSize(width: 0, height: 0)
        // Добавляем слой с фигурой как подслой view
        self.layer.addSublayer(shape!)
        // В зависимости от стороны нарисуем различные линии
        let path = createStandardPath()
        // Присвоем получившуюся фигуру форме (подслою)
        shape!.path = path.cgPath
    }
    func morphShape() {
        
        let newPath = createMorphedFigure()
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = newPath.cgPath
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fillMode = CAMediaTimingFillMode.both
        animation.repeatCount = 0
        animation.autoreverses = false
        animation.isRemovedOnCompletion = true
        
        shape!.add(animation, forKey: animation.keyPath)
    }
    func createMorphedFigure() -> UIBezierPath {
        let newPath = UIBezierPath()
        
        if self.side == .top {
            newPath.move   (to: CGPoint(x: 0, y: 0))
            newPath.addLine(to: CGPoint(x: viewSize!.width, y: 0))
            newPath.addLine(to: CGPoint(x: viewSize!.width, y: viewSize!.height * CGFloat(minHeightPercentage)))
            newPath.addLine(to: CGPoint(x: 0, y: viewSize!.height * CGFloat(maxHeightPercentage)))
            newPath.addLine(to: CGPoint(x: 0, y: 0))
        } else if side == .bottom {
            newPath.move(to: CGPoint(x: viewSize!.width, y: viewSize!.height))
            newPath.addLine(to: CGPoint(x: 0, y: viewSize!.height))
            newPath.addLine(to: CGPoint(x: 0, y: viewSize!.height * CGFloat(maxHeightPercentage)))
            newPath.addLine(to: CGPoint(x: viewSize!.width, y: viewSize!.height * CGFloat(minHeightPercentage)))
            newPath.addLine(to: CGPoint(x: viewSize!.width, y: viewSize!.height))
        } else { fatalError("ERROR: Unknown side!") }
        
        return newPath
    }
    
    func createStandardPath() -> UIBezierPath {
        let path = UIBezierPath()
        if self.side == .top {
            path.move   (to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: viewSize!.width, y: 0))
            path.addLine(to: CGPoint(x: viewSize!.width, y: viewSize!.height * CGFloat(okHeightPercentage)))
            path.addLine(to: CGPoint(x: 0, y: viewSize!.height * CGFloat(okHeightPercentage)))
            path.addLine(to: CGPoint(x: 0, y: 0))
        } else if side == .bottom {
            path.move(to: CGPoint(x: viewSize!.width, y: viewSize!.height))
            path.addLine(to: CGPoint(x: 0, y: viewSize!.height))
            path.addLine(to: CGPoint(x: 0, y: viewSize!.height * CGFloat(okHeightPercentage)))
            path.addLine(to: CGPoint(x: viewSize!.width, y: viewSize!.height * CGFloat(okHeightPercentage)))
            path.addLine(to: CGPoint(x: viewSize!.width, y: viewSize!.height))
        } else { fatalError("ERROR: Unknown side!") }
        
        return path
    }
}
