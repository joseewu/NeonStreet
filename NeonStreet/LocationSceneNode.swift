//
//  LocationSceneNode.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/30.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation
import ARCL
open class LocationSceneNode: LocationNode {

    public let annotationNode: SCNNode
    public var scaleRelativeToDistance = false

    public init(location: CLLocation?, node: SCNNode) {
        self.annotationNode = node
        super.init(location: location)

        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        addChildNode(annotationNode)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

