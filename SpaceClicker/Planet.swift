//
//  Planet.swift
//  SpaceClicker
//
//  Created by Andy Humphries on 6/12/19.
//  Copyright © 2019 iMacAndrew. All rights reserved.
//

import SpriteKit

class Planet: SKSpriteNode {

    var planetName: String
    var distanceFromEarth: Int

    init(planetName: String, distanceFromEarth: Int) {

        self.planetName = planetName
        self.distanceFromEarth = distanceFromEarth

        let texture = SKTexture(imageNamed: planetName)
        super.init(texture: texture, color: .clear, size: CGSize(width: 100.0, height: 100.0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
