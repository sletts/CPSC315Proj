//
//  GameScene.swift
//  MonstersVersusHeroes
//
//  Created by Letts, Sean Aleksey on 11/30/20.
//

import SpriteKit

class GameScene: SKScene {
    
    //MARK: - MyLaebl and Math vars (new stuff)
    var myLabel:SKLabelNode!
    //set up math variables for math functions
    var rand1: Int = 0
    var rand2: Int = 0
    var answer: Int = 0
    var toPrint: String = ""
    
    var idleStanceArray = [SKTexture]()
    var attackStanceArray = [SKTexture]()
    var dyingStanceArray = [SKTexture]()
    var walkingStanceArray = [SKTexture]()
    var hurtStanceArray = [SKTexture]()
    
    var playerCharacter = SKSpriteNode()
    var enemyCharacter = SKSpriteNode()
    var playButton = SKSpriteNode()
    
    var test = 0
    var timer: Timer? = nil
    var seconds: Int = 0
    
    func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                self.seconds += 1
            })
        }
    
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
    
    func createWalkingMovement(){
        let textureAtlas = SKTextureAtlas(named: "MC_Walking")
        print(textureAtlas.textureNames.count)
        for x in 0...textureAtlas.textureNames.count - 1{
            var name = ""
            if x < 10{
                name = "Golem_01_Walking_00\(x)"
            }
            else{
                name = "Golem_01_Walking_0\(x)"
            }
            walkingStanceArray.append(SKTexture(imageNamed: name))
        }
    }
    
    func createHurtMovement(){
        let textureAtlas = SKTextureAtlas(named: "MC_Hurt")
        print(textureAtlas.textureNames.count)
        for x in 0...textureAtlas.textureNames.count - 1{
            var name = ""
            if x < 10{
                name = "Golem_01_Hurt_00\(x)"
            }
            else{
                name = "Golem_01_Hurt_0\(x)"
            }
            hurtStanceArray.append(SKTexture(imageNamed: name))
        }
    }
    
    //MARK: - Math Function (new stuff)
    func mathProblems(){
        //set up possible math equation types
        let mathQuestionTypes = ["Add", "Subtract", "Multiply"]
        var questionType: String
        questionType = mathQuestionTypes.randomElement() ?? ""
        //testing stuff
        //questionType = "Multiply"
        print(questionType)

        //based on math equation type, generate 2 random numbers and answer which combines them
        if (questionType == mathQuestionTypes[0]){ //addition
            rand1 = Int(arc4random_uniform(UInt32(91)))+10
            rand2 = Int(arc4random_uniform(UInt32(91)))+10
            answer = rand1 + rand2
            print("\(rand1)+\(rand2) = \(answer)")
            toPrint = "\(rand1)+\(rand2) = \(answer)"
        }
        else if (questionType == mathQuestionTypes[1]){ //subtraction
            rand1 = Int(arc4random_uniform(UInt32(91)))+10
            rand2 = Int(arc4random_uniform(UInt32(91)))+10
            answer = max(rand1,rand2) - min(rand1,rand2)
            print("\(max(rand1,rand2))-\(min(rand1,rand2)) = \(answer)")
            toPrint = "\(max(rand1,rand2))-\(min(rand1,rand2)) = \(answer)"
        }
        else if (questionType == mathQuestionTypes[2]){ //multiplication
            rand1 = Int(arc4random_uniform(UInt32(12)))+1
            rand2 = Int(arc4random_uniform(UInt32(12)))+1
            answer = rand1*rand2
            print("\(rand1)*\(rand2) = \(answer)")
            toPrint = "\(rand1)*\(rand2) = \(answer)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        //MARK: - Texture Atlas
        createIdleMovement()
        creatAttackMovement()
        createDyingMovement()
        createWalkingMovement()
        createHurtMovement()
        startTimer()
        
        mathProblems()
        
        //MARK: - BACKGROUND
        let background = SKSpriteNode(imageNamed: "BG_01")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 1
        background.zPosition = -1
        addChild(background)
        
        //MARK: - MyLabel (new stuff)
        myLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        myLabel.text = toPrint
        myLabel.fontColor = SKColor.black
        myLabel.fontSize = 50
        myLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/1.5)
                
        self.addChild(myLabel)
        
        //MARK: - Player Sprite
        playerCharacter = SKSpriteNode(imageNamed: "Golem_01_Idle_000")
        playerCharacter.setScale(0.4)
        let playerWidth = playerCharacter.frame.width / 5
        let playerHeight = playerCharacter.frame.height / 2
        playerCharacter.position = CGPoint(x: frame.minX + playerWidth, y: frame.minY + playerHeight)
        playerCharacter.alpha = 0
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
        enemyCharacter.alpha = 0
        enemyCharacter.zPosition = 1
        addChild(enemyCharacter)
        enemyCharacter.run(SKAction.repeatForever(SKAction.animate(with: idleStanceArray, timePerFrame: 0.1, resize: false, restore: true)))
        
        //MARK: - Play Button Sprite
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.setScale(0.4)
        let playButtonHeight = playButton.frame.height / 2
        playButton.position = CGPoint(x: frame.midX, y: frame.maxY - playButtonHeight)
        playButton.alpha = 1
        playButton.zPosition = 1
        addChild(playButton)
    }
    
    func walkForward(player: SKSpriteNode){
        let playerWidth = playerCharacter.frame.width / 5
        let playerHeight = playerCharacter.frame.height / 2
        playerCharacter.run(SKAction.repeat(SKAction.animate(with: walkingStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
            while(playerCharacter.position.x < (frame.minX + playerWidth)){
                playerCharacter.position = CGPoint(x: playerCharacter.position.x + 0.1, y: playerCharacter.position.y)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(playButton.alpha > 0.0){
            for touch in touches{
                let node = self.atPoint(touch.location(in :self))
                let position = node.position
                if(position.x == playButton.position.x){
                    if(position.y == playButton.position.y){
                        let alert = UIAlertController(title: "Welcome!", message: "Hi there! This game is just meant to test your basic math ability while giving you a way to smash monsters to bits! \n Ready? \n Set.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Go!", style: .default, handler: {action in
                            self.playButton.alpha = 0.0
                            self.playerCharacter.alpha = 1.0
                            self.enemyCharacter.alpha = 1.0
                        }))
                        self.view?.window?.rootViewController?.present(alert, animated: true)
                    }
                }
            }
        }
        else{
            test = 0
            if test==0{
                playerCharacter.run(SKAction.repeat(SKAction.animate(with: attackStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
                //let animateStart = seconds
                enemyCharacter.run(SKAction.repeat(SKAction.animate(with: hurtStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

}

