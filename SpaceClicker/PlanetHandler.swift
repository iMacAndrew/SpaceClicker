//
//  PlanetHandler.swift
//  SpaceClicker
//
//  Created by Andy Humphries on 6/12/19.
//  Copyright © 2019 iMacAndrew. All rights reserved.
//

import SpriteKit

class PlanetHandler {

    var planets = [Planet]()

    // Add the planet above's distanceFromEarth to get actual value.
    var earth = Planet(planetName: "earth", distanceFromEarth: 0)
    var moon = Planet(planetName: "moon", distanceFromEarth: 50)
    var mars = Planet(planetName: "mars", distanceFromEarth: 100)
    var jupiter = Planet(planetName: "jupiter", distanceFromEarth: 150)
    var saturn = Planet(planetName: "saturn", distanceFromEarth: 200)
    var uranus = Planet(planetName: "uranus", distanceFromEarth: 250)
    var neptune = Planet(planetName: "neptune", distanceFromEarth: 300)



    init() {
        addPlanets()
    }

    func addPlanets() {
        planets.append(earth)
        planets.append(moon)
        planets.append(mars)
        planets.append(jupiter)
        planets.append(saturn)
        planets.append(uranus)
        planets.append(neptune)
    }
}
