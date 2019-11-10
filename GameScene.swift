import SpriteKit

struct PhysicsCategory {

	static let Ghost : UInt32 = 0x1 << 1
	static let Ground : UInt32 = 0x1 << 2
	static let Wall : UInt32 = 0x1 << 3

}

class GameScene: SKScene {

	var Ground = SKSpriteNode()
	var Ghost = SKSpriteNode()

	override func didMoveToView(view: SKView) {
		/* Setup scene here */

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
		Ghost.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
		Ghost.physicsBody?.affectedByGravity = true
		Ghost.physicsBody?.dynamic = true

		Ghost.zPosition = 2

		self.addChild(Ghost)

		createWalls()
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

	Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
	Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))

	}

	func createWalls() {

		let wallPair = SKNode()

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

		self.addChild(wallPair)
	}

	override func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
	}
}
