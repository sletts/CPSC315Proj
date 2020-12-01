//
//  GameScene.swift
//  MonstersVersusHeroes
//
//  Created by Letts, Sean Aleksey on 11/30/20.
//

import SpriteKit

class GameScene: SKScene {
    
    
    var idleStanceArray = [SKTexture]()
    var attackStanceArray = [SKTexture]()
    var dyingStanceArray = [SKTexture]()
    
    var playerCharacter = SKSpriteNode()
    var enemyCharacter = SKSpriteNode()
    
    var test = true
    
    func createIdleMovement(){
        let textureAtlas = SKTextureAtlas(named: "MC_Idle")
        for x in 0...textureAtlas.textureNames.count - 1{
            var name = ""
            if x < 10{
                name = "Golem_01_Idle_00\(x)"
            }
            else{
                name = "Golem_01_Idle_0\(x)"
            }
            idleStanceArray.append(SKTexture(imageNamed: name))
        }
    }
    
    func creatAttackMovement(){
        let textureAtlas = SKTextureAtlas(named: "MC_Attack")
        for x in 0...textureAtlas.textureNames.count - 1{
            var name = ""
            if x < 10{
                name = "Golem_01_Attacking_00\(x)"
            }
            else{
                name = "Golem_01_Attacking_0\(x)"
            }
            attackStanceArray.append(SKTexture(imageNamed: name))
        }
    }
    
    func createDyingMovement(){
        let textureAtlas = SKTextureAtlas(named: "MC_Dying")
        for x in 0...textureAtlas.textureNames.count - 1{
            var name = ""
            if x < 10{
                name = "Golem_01_Dying_00\(x)"
            }
            else{
                name = "Golem_01_Dying_0\(x)"
            }
            dyingStanceArray.append(SKTexture(imageNamed: name))
        }
    }
    
    override func didMove(to view: SKView) {
        
        //MARK: - Texture Atlas
        createIdleMovement()
        creatAttackMovement()
        createDyingMovement()
        
        //MARK: - BACKGROUND
        let background = SKSpriteNode(imageNamed: "BG_01")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 1
        background.zPosition = -1
        addChild(background)
        
        //MARK: - Player Sprite
        playerCharacter = SKSpriteNode(imageNamed: "Golem_01_Idle_000")
        playerCharacter.setScale(0.4)
        let playerWidth = playerCharacter.frame.width / 5
        let playerHeight = playerCharacter.frame.height / 2
        playerCharacter.position = CGPoint(x: frame.minX + playerWidth, y: frame.minY + playerHeight)
        playerCharacter.alpha = 1
        playerCharacter.zPosition = 1
        //playerSprite.run(SKAction.repeatForever(standingAction))
        addChild(playerCharacter)
        playerCharacter.run(SKAction.repeatForever(SKAction.animate(with: idleStanceArray, timePerFrame: 0.05, resize: false, restore: true)))
        //MARK: - Enemy Sprite
        
        enemyCharacter = SKSpriteNode(imageNamed: "Golem_01_Idle_000")
        enemyCharacter.setScale(0.4)
        let enemyWidth = enemyCharacter.frame.width / 5
        let enemyHeight = enemyCharacter.frame.height / 2
        enemyCharacter.position = CGPoint(x: frame.maxX - enemyWidth, y: frame.minY + enemyHeight)
        enemyCharacter.xScale = enemyCharacter.xScale * -1
        enemyCharacter.alpha = 1
        enemyCharacter.zPosition = 1
        addChild(enemyCharacter)
        enemyCharacter.run(SKAction.repeatForever(SKAction.animate(with: idleStanceArray, timePerFrame: 0.1, resize: false, restore: true)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if test{
            playerCharacter.run(SKAction.repeat(SKAction.animate(with: attackStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
            test = false
        }
        else{
            playerCharacter.run(SKAction.repeat(SKAction.animate(with: dyingStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
            test = true
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

}

