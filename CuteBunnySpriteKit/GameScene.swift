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
	
	// 개체의 종류를 정의함
	enum ColliderType: UInt32 {
		case Character = 1
		case Food = 2
		case Ball = 3
	}
	
	// 캐릭터의 애니메이션을 정의함
	var mBunnyAnimation = Dictionary<String, SKAction>()
	
	// 사용자의 입력이 없으면 카운터가 증가함
	var mInputIdle = 0
	
	// 캐릭터의 이동 여부를 정의함(true:캐릭터가 이동함, false:캐릭터가 멈춰있음)
	var mCheckMove = false
	
	// 메인을 시작함
    override func didMove(to view: SKView) {
		// ?
		self.physicsWorld.contactDelegate = self
		
		// 설정을 초기화함
		initSetup()
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
			스레드
		*/

		// 일정 시간동안 사용자의 터치 입력이 없을 시, 캐릭터의 표정을 변경함
		Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.threadBunnyFaceChange), userInfo: nil, repeats: true)
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
	
	// 화면을 터치함
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		// 캐릭터 표정 액션을 제거함
		self.mBunny.removeAction(forKey: "FaceChange")
		
		// 캐릭터가 이동 중인지 체크함(true:이동중, false:멈춤)
		self.mCheckMove = true

		for touch in touches {
			// 사용자가 터치한 좌표를 불러옴
			let location = touch.location(in: self)
			
			print("x:\(location.x)")
			print("y:\(location.y)")
			print("c.width:\(self.mBunny.size.width), c.height:\(self.mBunny.size.height)")
			print("f.width:\(self.frame.width), f.height:\(self.frame.height)")
			print("")
			
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
