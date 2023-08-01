//
//  Pie.swift
//  Memorize
//
//  Created by Sebastian Tleye on 26/07/2023.
//

import SwiftUI

struct Pie: Shape {
    
    var startAngle: Angle
    var endAngle: Angle
    var clockwise = false
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            startAngle = Angle.radians(newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.width) / 2
        let start = CGPoint(x: center.x + radius * CGFloat(cos(startAngle.radians)),
                            y: center.y + radius * CGFloat(sin(startAngle.radians)))

        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: !clockwise)
        p.addLine(to: center)

        return p
    }

}
