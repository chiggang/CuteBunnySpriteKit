//
//  GameScene.swift
//  CuteBunnySpriteKit
//
//  Created by JinUk Baek on 2016. 12. 13.
//  Copyright © 2016년 chiggang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	// 캐릭터를 정의함
	var mBunny = SKSpriteNode()
	
//	// 개체의 종류를 정의함
//	enum ColliderType: UInt32 {
//		case Character = 1
//		case Food = 2
//		case Ball = 3
//	}
	
	// 개체의 종류를 정의함
	struct ColliderType {
		static let Character: UInt32 = 0x1 << 0
		static let Food: UInt32 = 0x1 << 1
		static let Ball: UInt32 = 0x1 << 2
	}
	
	// 캐릭터의 애니메이션을 정의함
	var mBunnyAnimation = Dictionary<String, SKAction>()
	
	// 사용자의 입력이 없으면 카운터가 증가함
	var mInputIdle = 0
	
	// 랜덤 아이템이 출력되지 않으면 카운터가 증가함
	var mItemShowUpIdle = 0
	
	// 현재 화면에 출력된 랜덤 아이템을 정의함
	var mItemShowUpNo = 0
	
	// 캐릭터의 이동 여부를 정의함(true:캐릭터가 이동함, false:캐릭터가 멈춰있음)
	var mCheckMove = false
	
	// 현재 화면에 출력 중인 아이템이 있는지 체크함
	var mShowUpItemCheck = false

	// 현재 화면에 출력 중인 아이템을 정의함
	var mShowUpItem = SKSpriteNode()
	
	// 아이템 아이콘을 정의함
	var mApple = SKSpriteNode()
	var mCarrot1 = SKSpriteNode()
	var mCarrot2 = SKSpriteNode()
	var mCarrot3 = SKSpriteNode()
	var mStrawberry = SKSpriteNode()
	var mBasketball = SKSpriteNode()
	
	// 메인을 시작함
    override func didMove(to view: SKView) {
		// ?
		self.physicsWorld.contactDelegate = self
		
		// 
		let screenSize: CGRect = UIScreen.main.bounds
		print("\(screenSize)")
		
		// 설정을 초기화함
		initSetup()
    }

	func didBegin(_ contact: SKPhysicsContact) {
		// 아이템의 흔들흔들 애니메이션을 제거함
		self.mShowUpItem.removeAction(forKey: "FoodWiggle")

		// 아이템에 확대 애니메이션을 적용함
		let scale1 = SKAction.scale(to: 3.0, duration: 0.3)
		let scale2 = SKAction.fadeOut(withDuration: 0.3)
		let foodCycle = SKAction.group([scale1, scale2])
		let foodScale = SKAction.repeat(foodCycle, count: 1)
		self.mShowUpItem.run(foodScale, withKey: "FoodScale")

		let face1 = SKAction.repeat(self.mBunnyAnimation["BunnyEat"]!, count: 3)
		let bunnyCycle = SKAction.sequence([face1])
		let bunnyFace = SKAction.repeat(bunnyCycle, count: 1)
		self.mBunny.run(bunnyFace, withKey: "BunnyFace")
		
		// 아이템에 확대 애니메이션을 적용함
		let iconScale1 = SKAction.scale(to: 2.0, duration: 0.2)
		let iconScale2 = SKAction.scale(to: 0.5, duration: 0.1)
		let iconScale3 = SKAction.scale(to: 1.0, duration: 0.2)
		let iconCycle = SKAction.sequence([iconScale1, iconScale2, iconScale3])
		let iconScale = SKAction.repeat(iconCycle, count: 1)
		
		switch self.mItemShowUpNo {
		case 1:
			self.mApple.run(iconScale, withKey: "IconScale")
			
		case 2:
			self.mCarrot1.run(iconScale, withKey: "IconScale")
			
		case 3:
			self.mCarrot2.run(iconScale, withKey: "IconScale")
			
		case 4:
			self.mCarrot3.run(iconScale, withKey: "IconScale")
			
		case 5:
			self.mStrawberry.run(iconScale, withKey: "IconScale")
			
		case 6:
			self.mBasketball.run(iconScale, withKey: "IconScale")
			
		default:
			self.mApple.run(iconScale, withKey: "IconScale")
		}
		
		// 개체 충돌을 체크함
		if contact.bodyA.categoryBitMask == ColliderType.Character && contact.bodyB.categoryBitMask == ColliderType.Food {
			print("통과")
		} else {
			print("충돌")
		}
		
		// 아이템이 화면에 출력됨
		self.mShowUpItemCheck = false
	}

	override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
	
	// 설정을 초기화함
	func initSetup() {
		/*
			배경
		*/
		
		// 화면의 배경색을 정의함
		self.backgroundColor = SKColor.white
		
		/*
			캐릭터
		*/
		
		// 캐릭터의 이미지를 정의함
		let bunnyTexture = SKTexture(imageNamed: "BunnyDefault.png")
		
		// 캐릭터의 기본 애니메이션을 정의함
		let bunnyAnimation = SKAction.animate(with: [bunnyTexture], timePerFrame: 1)
		let bunnyFlap = SKAction.repeatForever(bunnyAnimation)
		
		// 캐릭터의 위치 및 애니메이션을 정의함
		self.mBunny = SKSpriteNode(texture: bunnyTexture)
		let bunnyRatio = self.mBunny.size.height / self.mBunny.size.width
		self.mBunny.size = CGSize(width: 250.0, height: 250.0 * bunnyRatio)
		self.mBunny.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		self.mBunny.run(bunnyFlap)
		
		self.mBunny.physicsBody = SKPhysicsBody(rectangleOf: self.mBunny.size)
		self.mBunny.physicsBody?.isDynamic = false
		self.mBunny.physicsBody?.friction = 0
		
		// 캐릭터의 개체 종류를 정의함
		self.mBunny.physicsBody?.categoryBitMask = ColliderType.Character
		
		// 캐릭터와 충돌할 개체 종류를 정의하고 그것과 접촉하면 알려줌(충돌 후 충돌정보를 알려줌)
		self.mBunny.physicsBody?.contactTestBitMask = ColliderType.Food | ColliderType.Ball
		
		// 캐릭터가 충돌에 반응하는 자신의 개체 종류를 정의함(충돌 후 물리법칙을 적용함)
		self.mBunny.physicsBody?.collisionBitMask = ColliderType.Food | ColliderType.Ball

		// 캐릭터가 중력에 적용되는지 정의함
		self.mBunny.physicsBody?.affectedByGravity = false

		// 화면에 캐릭터를 출력함
		self.addChild(self.mBunny)
		
		/*
			캐릭터 - 애니메이션
		*/
		
		self.mBunnyAnimation = Dictionary()
		
		// 캐릭터의 이미지 배열을 정의함
		var arrImgBunny = [SKTexture]()
		
		// 캐릭터의 눈 깜빡임 이미지를 생성함
		for i in 1...5 {
			arrImgBunny.append(SKTexture(imageNamed: "BunnyCloseEyes\(i).png"))
		}
		
		self.mBunnyAnimation["BunnyCloseEyes"] = SKAction.animate(with: arrImgBunny, timePerFrame: 0.05)
		
		// 캐릭터의 이미지 배열을 초기화함
		arrImgBunny.removeAll()
		
		// 캐릭터의 입 오물오물 이미지를 생성함
		for i in 1...3 {
			arrImgBunny.append(SKTexture(imageNamed: "BunnyEat\(i).png"))
		}
		
		self.mBunnyAnimation["BunnyEat"] = SKAction.animate(with: arrImgBunny, timePerFrame: 0.06)
		
		// 캐릭터의 이미지 배열을 초기화함
		arrImgBunny.removeAll()
		
		// 캐릭터의 달리기 이미지를 생성함
		for i in 1...2 {
			arrImgBunny.append(SKTexture(imageNamed: "BunnyRun\(i).png"))
		}
		
		self.mBunnyAnimation["BunnyRun"] = SKAction.animate(with: arrImgBunny, timePerFrame: 0.2)
		
		/*
			화면 UI
		*/
		
		// 아이템의 이미지 파일을 정의함
		let arrItem = ["Apple.png", "Carrot1.png", "Carrot2.png", "Carrot3.png", "Strawberry.png", "Basketball.png"]

		for i in 0...arrItem.count - 1 {
			var itemSprite = SKSpriteNode()
			
			// 아이템의 이미지를 정의함
			let itemTexture = SKTexture(imageNamed: arrItem[i])
			
			// 아이템의 위치 및 크기를 정의함
			itemSprite = SKSpriteNode(texture: itemTexture)
			let itemRatio = itemSprite.size.height / itemSprite.size.width
			itemSprite.size = CGSize(width: 50.0, height: 50.0 * itemRatio)
			itemSprite.position = CGPoint(x: ((self.frame.width / 2 * -1) + 70 + CGFloat(i * 90)), y: (self.frame.height / 2) - 70)
			itemSprite.zPosition = -1
 
			// 화면에 아이템을 출력함
			switch arrItem[i] {
			case "Apple.png":
				self.mApple = itemSprite
				self.addChild(self.mApple)
				
			case "Carrot1.png":
				self.mCarrot1 = itemSprite
				self.addChild(self.mCarrot1)
				
			case "Carrot2.png":
				self.mCarrot2 = itemSprite
				self.addChild(self.mCarrot2)
				
			case "Carrot3.png":
				self.mCarrot3 = itemSprite
				self.addChild(self.mCarrot3)
				
			case "Strawberry.png":
				self.mStrawberry = itemSprite
				self.addChild(self.mStrawberry)
				
			case "Basketball.png":
				self.mBasketball = itemSprite
				self.addChild(self.mBasketball)
				
			default:
				print("")
			}
		}

		//
		self.addChild(self.mShowUpItem)
		
		/*
			스레드
		*/
		
		// 일정 시간동안 사용자의 터치 입력이 없을 시, 캐릭터의 표정을 변경함
		Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.threadBunnyFaceChange), userInfo: nil, repeats: true)
		
		// 화면에 채소나 공을 랜덤으로 하나만 출력함
		Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.threadShowUpObject), userInfo: nil, repeats: true)
	}

	// 스레드 : 일정 시간동안 사용자의 터치 입력이 없을 시, 캐릭터의 표정을 변경함
	func threadBunnyFaceChange() {
		// 캐릭터가 이동 중인지 체크함(true:이동중, false:멈춤)
		if self.mCheckMove == false {
			// 입력 대기 시간이 2초 이상이면 캐릭터의 표정을 변경함
			if self.mInputIdle >= 2 {
				// 캐릭터 표정 액션을 제거함
				self.mBunny.removeAction(forKey: "FaceChange")
				
				var bunnyFlap: SKAction
				
				// 1~4 범위의 랜덤값을 불러옴
				let rnd = Int(arc4random_uniform(3) + 1)
				
				// 랜덤값에 따라 캐릭터의 표정을 변경함
				switch rnd {
					// 눈 깜빡임
					case 1:
						bunnyFlap = SKAction.repeat(self.mBunnyAnimation["BunnyCloseEyes"]!, count: 1)
					
					// 입 오물오물
					case 2...4:
						bunnyFlap = SKAction.repeat(self.mBunnyAnimation["BunnyEat"]!, count: 4)
					
					// 기본값
					default:
						bunnyFlap = SKAction.repeat(self.mBunnyAnimation["BunnyEat"]!, count: 4)
				}
				
				// 캐릭터 표정 액션을 시작함
				self.mBunny.run(bunnyFlap, withKey: "FaceChange")
				
				// 카운터를 초기화함
				self.mInputIdle = 0
			} else {
				self.mInputIdle += 1
			}
		} else {
			// 캐릭터가 이동 중이면 카운터를 초기화함
			self.mInputIdle = 0
		}
	}
	
	// 랜덤 아이템의 출력 좌표를 생성함
	func getItemShowUpPosition() -> (Int, Int) {
		var rndPosX = 0
		var rndPosY = 0
		
		while true {
			// 랜덤 아이템을 출력할 가로 위치를 정의함
			var minValue = Int(self.frame.width) / 2 * -1 + 100
			var maxValue = Int(self.frame.width) / 2 - 100
			rndPosX = Int(arc4random_uniform(UInt32(maxValue - minValue + 1))) + minValue
			
			// 랜덤 아이템을 출력할 세로 위치를 정의함
			minValue = Int(self.frame.height) / 2 * -1 + 100
			maxValue = Int(self.frame.height) / 2 - 170
			rndPosY = Int(arc4random_uniform(UInt32(maxValue - minValue + 1))) + minValue
			
			// 캐릭터 주위의 여유 공간을 정의함
			let padSize = 100

			let bunnyPosW = Int(self.mBunny.position.x) - (Int(self.mBunny.size.width) / 2) - padSize
			let bunnyPosE = Int(self.mBunny.position.x) + (Int(self.mBunny.size.width) / 2) + padSize
			let bunnyPosN = Int(self.mBunny.position.y) + (Int(self.mBunny.size.height) / 2) + padSize
			let bunnyPosS = Int(self.mBunny.position.y) - (Int(self.mBunny.size.height) / 2) - padSize

			if (bunnyPosW <= rndPosX && bunnyPosE >= rndPosX) && (bunnyPosS <= rndPosY && bunnyPosN >= rndPosY) {
				
			} else {
				break
			}
		}
		
		return (rndPosX, rndPosY)
	}

	// 스레드 : 화면에 채소나 공을 랜덤으로 하나만 출력함
	func threadShowUpObject() {
		// 현재 화면에 출력 중인 아이템이 있는지 체크함
		if self.mShowUpItemCheck == false {
			// 다음 아이템이 나타날 때까지 2초간 기다림
			if self.mItemShowUpIdle <= 2 {
				self.mItemShowUpIdle += 1
				return
			}

			// 랜덤 아이템을 화면에서 삭제함
			self.mShowUpItem.removeFromParent()

			// 랜덤으로 아이템을 지정함(아이템 6개)
			let rnd = Int(arc4random_uniform(6) + 1)

			// 랜덤 아이템의 출력 좌표를 생성함
			let (rnsPosX, rnsPosY) = getItemShowUpPosition()

			// 기존에 화면 상단에 출력되어 있던 아이템 이미지를 재활용함
			switch rnd {
			case 1:
				self.mShowUpItem = self.mApple.copy() as! SKSpriteNode
				
			case 2:
				self.mShowUpItem = self.mCarrot1.copy() as! SKSpriteNode
				
			case 3:
				self.mShowUpItem = self.mCarrot2.copy() as! SKSpriteNode
				
			case 4:
				self.mShowUpItem = self.mCarrot3.copy() as! SKSpriteNode
				
			case 5:
				self.mShowUpItem = self.mStrawberry.copy() as! SKSpriteNode

			case 6:
				self.mShowUpItem = self.mBasketball.copy() as! SKSpriteNode

			default:
				self.mShowUpItem = self.mApple.copy() as! SKSpriteNode
			}

			// 아이템에 등장 애니메이션을 적용함
			let iconScale1 = SKAction.scale(to: 0.5, duration: 0.1)
			let iconScale2 = SKAction.scale(to: 1.0, duration: 0.1)
			let iconCycle = SKAction.sequence([iconScale1, iconScale2])
			let iconScale = SKAction.repeat(iconCycle, count: 1)
			self.mShowUpItem.run(iconScale, withKey: "ItemShowUp")

			// 현재 화면에 출력된 랜덤 아이템을 정의함
			self.mItemShowUpNo = rnd
		
			// 랜덤 아이템의 위치 및 크기를 정의함
			let itemRatio = self.mShowUpItem.size.height / self.mShowUpItem.size.width
			self.mShowUpItem.size = CGSize(width: 130.0, height: 130.0 * itemRatio)
			self.mShowUpItem.position = CGPoint(x: rnsPosX, y: rnsPosY)
			self.mShowUpItem.zPosition = -1
			
			// 아이템의 충돌 영역을 정의함
			self.mShowUpItem.physicsBody = SKPhysicsBody(rectangleOf: self.mShowUpItem.size)
			self.mShowUpItem.physicsBody?.isDynamic = true
			self.mShowUpItem.physicsBody?.affectedByGravity = false
			self.mShowUpItem.physicsBody?.mass = 50.0
			
			// 아이템의 개체 종류를 정의함
			if rnd == 6 {
				// 충돌
				self.mShowUpItem.physicsBody?.categoryBitMask = ColliderType.Ball
			} else {
				// 통과
				self.mShowUpItem.physicsBody?.categoryBitMask = ColliderType.Food
			}
			
			// 아이템이 충돌할 개체 종류를 정의하고 그것과 접촉하면 알려줌(충돌 후 충돌정보를 알려줌)
			self.mShowUpItem.physicsBody?.contactTestBitMask = ColliderType.Character
			
			// 아이템이 충돌에 반응하는 자신의 개체 종류를 정의함(충돌 후 물리법칙(통과)을 적용함)
			if rnd == 6 {
				// 충돌
				self.mShowUpItem.physicsBody?.collisionBitMask = ColliderType.Character
			} else {
				// 통과
				self.mShowUpItem.physicsBody?.collisionBitMask = ColliderType.Food
			}

			// 아이템에 흔들흔들 애니메이션을 적용함
			let rot1 = SKAction.rotate(byAngle: 0.5, duration: 0.3)
			rot1.timingMode = .easeOut
			let rot2 = SKAction.rotate(byAngle: -0.5, duration: 0.3)
			rot2.timingMode = .easeIn
			let rot3 = SKAction.rotate(byAngle: -0.5, duration: 0.3)
			rot3.timingMode = .easeOut
			let rot4 = SKAction.rotate(byAngle: 0.5, duration: 0.3)
			rot4.timingMode = .easeIn
			let cycle = SKAction.sequence([rot1, rot2, rot3, rot4])
			let foodWiggle = SKAction.repeatForever(cycle)
			self.mShowUpItem.run(foodWiggle, withKey: "FoodWiggle")
			
			self.addChild(self.mShowUpItem)
		
			// 아이템이 화면에 출력됨
			self.mShowUpItemCheck = true
			self.mItemShowUpIdle = 0
		}
	}

	// 화면을 터치함
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		// 캐릭터 표정 액션을 제거함
		self.mBunny.removeAction(forKey: "FaceChange")
		
		// 캐릭터가 이동 중인지 체크함(true:이동중, false:멈춤)
		self.mCheckMove = true

		for touch in touches {
			/*
				캐릭터 좌표 정의
			*/
			
			// 사용자가 터치한 좌표를 불러옴
			let location = touch.location(in: self)
			
			// 사용자가 터치한 좌표를 보정함
			var revLocation: CGPoint = location
			
			// 좌측 좌표를 보정함
			if location.x < (self.frame.width / 2 * -1) + (self.mBunny.size.width / 2) {
				revLocation.x = (self.frame.width / 2 * -1) + (self.mBunny.size.width / 2)
			}
			
			// 우측 좌표를 보정함
			if location.x > (self.frame.width / 2) - (self.mBunny.size.width / 2) {
				revLocation.x = (self.frame.width / 2) - (self.mBunny.size.width / 2)
			}
			
			// 상단 좌표를 보정함
			if location.y > (self.frame.height / 2) - (self.mBunny.size.height / 2) {
				revLocation.y = (self.frame.height / 2) - (self.mBunny.size.height / 2)
			}
			
			// 하단 좌표를 보정함
			if location.y < (self.frame.height / 2 * -1) + (self.mBunny.size.height / 2) {
				revLocation.y = (self.frame.height / 2 * -1) + (self.mBunny.size.height / 2)
			}

			/*
				캐릭터 이동
			*/

			// 캐릭터 이동 시, 달리기 애니메이션을 적용함
			let actFlap = SKAction.repeatForever(self.mBunnyAnimation["BunnyRun"]!)
			self.mBunny.run(actFlap, withKey: "MoveRun")

			// 캐릭터 이동을 정의함
			let actMove = SKAction.move(to: revLocation, duration: 0.9)
			actMove.timingMode = .easeInEaseOut
			let actMoveSeq = SKAction.sequence([actMove])
			
			// 캐릭터 이동이 완료되면 지정된 작업을 처리함
			let actMoveCompletion = SKAction.run() {
				// 캐릭터 달리기 액션을 제거함
				self.mBunny.removeAction(forKey: "MoveRun")

				// 캐릭터가 이동 중인지 체크함(true:이동중, false:멈춤)
				self.mCheckMove = false
			}
			
			// 작업의 순서를 정의함
			let actSequence = SKAction.sequence([actMoveSeq, actMoveCompletion])

			// 캐릭터를 이동함
			self.mBunny.run(actSequence, withKey: "Move")
		}
	}

	// 화면 터치를 완료함
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
}
