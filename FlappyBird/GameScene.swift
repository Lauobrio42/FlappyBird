import SpriteKit

struct PhysicsCategory {

	static let Ghost : UInt32 = 0x1 << 1
	static let Ground : UInt32 = 0x1 << 2
	static let Wall : UInt32 = 0x1 << 3
	static let Score : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {

	var Ground = SKSpriteNode()
	var Ghost = SKSpriteNode()

	var wallPair = SKNode()

	var moveAndRemove = SKAction()

	var gameStart = Bool()

	var score = Int()
	let scoreLbl = SKLabelNode()

	var died = Bool()
	var restartBTN = SKSpriteNode()

	func restartScene()
	{
		self.removeAllChildren()
		self.removeAllActions()
		died = false
		gameStarted = false
		score = 0
		createScene()
	}

	func createScene()
	{
		self.physicsWorld.contactDelegate = self

		scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
		scoreLbl.text = "\(score)"
		scoreLbl.fontName = "04b_19"
		scoreLbl.zPosition = 5
		scoreLbl.fontsize = 60
		self.addChild(scoreLbl)

		Ground = SKSpriteNode(imageNamed: "Ground")
		Ground.setScale(0.5)
		Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)

		Ground.physicsBody = SKPhysicsBody(rectangleOfSize: Ground.size)
		Ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
		Ground.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
		Ground.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
		Ground.physicsBody?.affectedByGravity = false
		Ground.physicsBody?.dynamic = false

		Ghost.zPosition = 3

		self.addChild(Ground)

		Ghost = SKSpriteNode(imageNamed: "Ghost")
		Ghost.size = CGSize(width: 60, height: 70)
		Ghost.position = CGPoint(x: self.frame.width / 2 - Ghost.frame.width, y: self.frame.height / 2)

		Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height / 2)
		Ghost.physicsBody?.categoryBitMask = PhysicsCategory.Ghost
		Ghost.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
		Ghost.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall | PhysicsCategory.Score
		Ghost.physicsBody?.affectedByGravity = false
		Ghost.physicsBody?.dynamic = true

		Ghost.zPosition = 2

		self.addChild(Ghost)
	}

	override func didMoveToView(view: SKView) {
		/* Setup scene here */

		createScene()
	}

	func createBTN() {
		restartBTN = SKSpriteNode(color: SKColor?blueColor(), size: CGSize(width: 200, height: 100))
		restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
		restartBTN.zPosition = 6
		restartBTN.setScale(0)
		self.addChild(restartBTN)

		restartBTN.runAction(SKAction.scaleTo(1.0, duration: 0.3))
	}

	func didBeginContact(contact: SKPhysicsContact)
	{
		let firstBody = contact.BodyA
		let secondBody = contact.bodyB

		if firstBody.categoryBitMask == PhysicsCategory.Score && secondBody.categoryBitMask == PhysicsCategory.Ghost || firstBody.categoryBitMask == PhysicsCategory.Ghost && secondBody.categoryBitMask == PhysicsCategory.Score {
			score++
			scoreLbl.text = "\(score)"
		}

		if firstBody.categoryBitMask == PhysicsCategory.Ghost && secondBody.categoryBitMask == PhysicsCategory.Wall || firstBody.categoryBitMask == PhysicsCategory.Wall && secondBody.categoryBitMask == PhysicsCategory.Ghost
		{
			died = true

			enumerationChildNodesWithName("wallPair", usingBlocks: ({
				(node, error) in

				node.speed = 0
				self.removeAllActions()
			}))
			createBTN()
		}
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if gameStarted == false {

			gameStarted = true

			Ghost.physicsBody?.affectedByGravity = true

			let spawn = SKAction.runBlock({
				() in

				self.createWalls()
			})

			let delay = SKAction.waitForDuration(2.0)
			let SpawnDelay = SKAction.sequence([spawn, delay])
			let spawnDelayForever = SKAction.repeatActionForever(SpawnDelay).
			self.runAction(spawnDelayForever)

			let distance = CGFloat(self.frame.width + wallPair.frame.width)
			let movePipes = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval (0.01 * distance))
			let removePipes = SKAction.removeFromParent()
			moveAndRemove = SKAction.sequence([movePipes, removePipes])

			Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
			Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
		} else {
			if died == true {

			} else {
				Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
				Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
			}
		}

		for touch in touches{
			let location = touch.locationInNode(self)

			if died == true {
				if restartBTN.containsPoint(location) {
				restartScene
				}
			}
		}
	}

	func createWalls() {

		let scoreNode = SKPriteNode()

		scoreNode.size = CGSize(width: 1, height: 200)
		scoreNode.position = CGPoint(x: self.frame.width, y: self.frame.height / 2)
		scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
		scoreNode.physicsBody?.affectedByGravity = false
		scoreNode.physicsBody?.dynamic = false
		scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.Score
		scoreNode.physicsBody?.collisionBitMask = 0
		scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
		scoreNode.color = SKColor.blueColor()

		wallPair = SKNode()
		wallPairName = "wallPair"

		let topWall = SKSpriteNode(imageNamed: "Wall")
		let bottomWall = SKSpriteNode(imageNamed: "Wall")

		topWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 + 350)
		bottomWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 - 350)

		topWall.setScale(0.5)
		bottomWall.setScale(0.5)

		topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
		topWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
		topWall.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
		topWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
		topWall.physicsBody?.dynamic = false
		topWall.physicsBody?.affectedByGravity = false

		bottomWall.physicsBody = SKPhysicsBody(rectangleOfSize: bottomWall.size)
		bottomWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
		bottomWall.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
		bottomWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
		bottomWall.physicsBody?.dynamic = false
		bottomWall.physicsBody?.affectedByGravity = false

		topWall.zRotation = CGFloat(M_PI)

		wallPair.addChild(topWall)
		wallPair.addChild(bottomWall)

		wallPair.zPosition = 1

		var randomPosition = CGFloat.random(min: -200, max: 200)
		wallPair.position.y = wallPair.y + randomPosition
		wallPair.addChild(scoreNode)

		wallPair.runAction(moveAndRemove)

		self.addChild(wallPair)
	}

	override func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
	}
}
