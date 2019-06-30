//
//  GameScene.swift
//  SpaceClicker
//
//  Created by Andy Humphries on 6/10/19.
//  Copyright © 2019 iMacAndrew. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var viewController: GameViewController?

    private var distanceLabel: SKLabelNode!
    private var timeToTapLabel: SKLabelNode!
    private var multiplierLabel: SKLabelNode!
    private var notificationLabel: SKLabelNode!

    private var totalDistance: Int = 0
    private var currentDistance: Int = 0
    private var currentAmountOfTouches: Int = 0
    private var distanceToPlanet: Float = 100.0

    private let numberOfTapsForMultiplier: Int = 10
    private var currentMultiplier: Int = 1
    private let multiplierCap: Int = 1
    private var didReachPlanet: Bool = false

    private var bottomPlanetNode: SKSpriteNode!
    private var topPlanetNode: SKSpriteNode!
    private var spaceShip: SKSpriteNode!
    private var bar: SKSpriteNode!
    private var worldMap: SKSpriteNode!
    private var spaceBackGround: SKSpriteNode!

    private var planetHandler = PlanetHandler()

    lazy var planets = planetHandler.planets

    lazy var bottomPlanet = planets[0]
    lazy var topPlanet = planets[1]

    private var bottomPlanetIndex: Int = 0
    lazy var topPlanetIndex: Int = bottomPlanetIndex + 1

    override func sceneDidLoad() {

        scene?.backgroundColor = UIColor.black

        spaceBackGround = SKSpriteNode.init(imageNamed: "spacebackground")
        spaceBackGround.size = CGSize(width: frame.width, height: frame.height)
        spaceBackGround.zPosition = -1
        addChild(spaceBackGround)

        spaceShip = SKSpriteNode.init(imageNamed: "spaceship")
        addChild(spaceShip)

        worldMap = SKSpriteNode.init(imageNamed: "worldmap")
        worldMap.position = CGPoint(x: (frame.width / 2) - 175, y: -(frame.height / 2) + 100)
        addChild(worldMap)

        bottomPlanetNode = SKSpriteNode(imageNamed: planets[bottomPlanetIndex].planetName)
        topPlanetNode = SKSpriteNode(imageNamed: planets[topPlanetIndex].planetName)

        bottomPlanetNode.position = CGPoint(x: -(frame.width / 2) + 100, y: -(frame.height / 2) + 50)
        addChild(bottomPlanetNode)

        topPlanetNode.position = CGPoint(x: -(frame.width / 2) + 100, y: frame.height / 2 - 50)
        addChild(topPlanetNode)

        distanceLabel = scene?.childNode(withName: "distanceLabel") as? SKLabelNode
        timeToTapLabel = scene?.childNode(withName: "timeToTapLabel") as? SKLabelNode
        multiplierLabel = scene?.childNode(withName: "multiplierLabel") as? SKLabelNode
        notificationLabel = scene?.childNode(withName: "notificationLabel") as? SKLabelNode

        bar = SKSpriteNode(color: SKColor.white, size: CGSize(width: 20, height: ((scene?.size.height)!) - 100))
        bar.anchorPoint.y = 0.0
        bar.position = CGPoint(x: -(frame.width / 2) + 100, y: -(frame.height / 2) + 50)
        addChild(bar)
    }

    func reachedPlanet() {
        if  currentDistance == topPlanet.distanceFromEarth {

            didReachPlanet = true

            let fadeAction = SKAction.fadeAlpha(to: 0, duration: 5.0)

            if planets[topPlanetIndex].planetName == "moon" {
                notificationLabel.text = "You've reached the \(planets[topPlanetIndex].planetName)!"
                notificationLabel.run(fadeAction)
            } else {
                notificationLabel.alpha = 1.0
                notificationLabel.text = "You've reached \(planets[topPlanetIndex].planetName)!"
                notificationLabel.run(fadeAction)
            }

            topPlanetIndex = topPlanetIndex + 1
            bottomPlanetIndex = bottomPlanetIndex + 1
            topPlanet = planets[topPlanetIndex]
            bottomPlanet = planets[bottomPlanetIndex]

            bottomPlanetNode.removeFromParent()
            topPlanetNode.removeFromParent()

            bottomPlanetNode = SKSpriteNode(imageNamed: planets[bottomPlanetIndex].planetName)
            topPlanetNode = SKSpriteNode(imageNamed: planets[topPlanetIndex].planetName)

            bottomPlanetNode.position = CGPoint(x: -(frame.width / 2) + 100, y: -(frame.height / 2) + 50)
            addChild(bottomPlanetNode)

            topPlanetNode.position = CGPoint(x: -(frame.width / 2) + 100, y: frame.height / 2 - 50)
            addChild(topPlanetNode)
            print(topPlanet.planetName)
            print(bottomPlanet.planetName)

        }
    }

    func touchDown(atPoint pos : CGPoint) {
        timeToTapLabel.text = "3"

        var timeLeftToTap: Int = 3

        let wait = SKAction.wait(forDuration:1) //change countdown speed here
        let action = SKAction.run({
            if timeLeftToTap > 0{
                timeLeftToTap = timeLeftToTap - 1
                self.timeToTapLabel.text = String(timeLeftToTap)

                if timeLeftToTap == 0 {
                    self.currentAmountOfTouches = 0
                    self.currentMultiplier = 1
                    self.multiplierLabel.text = ""
                }

            } else {
                self.removeAction(forKey: "action")
            }
        })
        let sequence = SKAction.sequence([wait,action])

        timeToTapLabel.run(SKAction.repeatForever(sequence), withKey: "action")

        if timeLeftToTap > 0 {
            self.currentAmountOfTouches = self.currentAmountOfTouches + 1
        }

        if currentAmountOfTouches % numberOfTapsForMultiplier == 0 {
            if currentMultiplier < multiplierCap {
                currentMultiplier = currentMultiplier + 1
            }
        }

        if currentMultiplier > 1 {
            multiplierLabel.text = "\(currentMultiplier)x"
        }

        //print("\(self.currentAmountOfTouches)")

        totalDistance = totalDistance + currentMultiplier
        currentDistance = currentDistance + currentMultiplier

        print("Current Distance: \(currentDistance)")

        distanceLabel?.text = String(Int(totalDistance))
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        let nodes = self.nodes(at: pos)

        if let button = worldMap {
            if nodes.contains(button) {

                viewController?.goToMapView()

            }
        }
    }

    func calcProgress() -> Float {

        if didReachPlanet {
            currentDistance = 0
            didReachPlanet = false
        }

        let topPlanetDistanceFromEarth = (Float(planets[topPlanetIndex].distanceFromEarth))
        let bottomPlanetDistanceFromEarth = (Float(planets[bottomPlanetIndex].distanceFromEarth))

        return (Float(currentDistance) / (topPlanetDistanceFromEarth - bottomPlanetDistanceFromEarth))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {

        if totalDistance == topPlanet.distanceFromEarth {
            currentDistance = topPlanet.distanceFromEarth
        }

        reachedPlanet()

        if calcProgress() <= 100 * 100 && calcProgress() >= 0  * 100 {
            bar.yScale = CGFloat(calcProgress())
        }
    }
}
