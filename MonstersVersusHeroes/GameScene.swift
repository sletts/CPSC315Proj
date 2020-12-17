//
//  GameScene.swift
//  MonstersVersusHeroes
//
//  Created by Letts, Sean Aleksey on 11/30/20.
//

import SpriteKit

class GameScene: SKScene {
    
    //MARK: - MyLaebl and Math vars (new stuff)
    var playerLabel:SKLabelNode!
    var enemyLabel:SKLabelNode!
    //set up math variables for math functions
    var rand1: Int = 0
    var rand2: Int = 0
    var answer: Int = 0
    var toPrint: String = ""
    var operand: String = ""
    
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
    
    var playerHP = 200
    var enemyHP = 200
    //Starts a timer, used to determine how quickly someone answers a question
    var playerHealthBar = SKSpriteNode()
    var enemyHealthBar = SKSpriteNode()
    var backgroundHealthBar1 = SKSpriteNode()
    var backgroundHealthBar2 = SKSpriteNode()
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
               self.seconds += 1
        })
    }
    //MARK: - Populates all of the SKTexture Arrays
    //The function that populates the Idle movement array
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
    //The function that populates the attack movement array
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
    //The function that populates the dying movement array
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
    //The function that populates the walking movement array
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
    //The function that populates the hurt movement array
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
    
    //MARK: - Math Function
    func mathProblems(){
        //set up possible math equation types
        let mathQuestionTypes = ["Add", "Subtract", "Multiply"]
        var questionType: String
        questionType = mathQuestionTypes.randomElement() ?? ""

        //based on math equation type, generate 2 random numbers and answer which combines them
        if (questionType == mathQuestionTypes[0]){ //addition
            rand1 = Int(arc4random_uniform(UInt32(91)))+10
            rand2 = Int(arc4random_uniform(UInt32(91)))+10
            answer = rand1 + rand2
            print("\(rand1)+\(rand2) = \(answer)")
            toPrint = "\(rand1)+\(rand2) = \(answer)"
            operand = "+"
        }
        else if (questionType == mathQuestionTypes[1]){ //subtraction
            rand1 = Int(arc4random_uniform(UInt32(91)))+10
            rand2 = Int(arc4random_uniform(UInt32(91)))+10
            answer = max(rand1,rand2) - min(rand1,rand2)
            print("\(max(rand1,rand2))-\(min(rand1,rand2)) = \(answer)")
            toPrint = "\(max(rand1,rand2))-\(min(rand1,rand2)) = \(answer)"
            operand = "-"
        }
        else if (questionType == mathQuestionTypes[2]){ //multiplication
            rand1 = Int(arc4random_uniform(UInt32(12)))+1
            rand2 = Int(arc4random_uniform(UInt32(12)))+1
            answer = rand1*rand2
            print("\(rand1)*\(rand2) = \(answer)")
            toPrint = "\(rand1)*\(rand2) = \(answer)"
            operand = "*"
        }
    }
    
    func createHPBars(){
        playerHealthBar = SKSpriteNode(color: .green, size: CGSize(width: playerHP/2, height: 15))
        playerHealthBar.position = CGPoint(x: frame.minX + 60, y: playerLabel.position.y - self.size.width/20)
        playerHealthBar.zPosition = 1
        addChild(playerHealthBar)
        
        backgroundHealthBar1 = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 15))
        backgroundHealthBar1.position = CGPoint(x: frame.minX + 60, y: playerLabel.position.y - self.size.width/20)
        backgroundHealthBar1.zPosition = 0
        addChild(backgroundHealthBar1)
        
        enemyHealthBar = SKSpriteNode(color: .green, size: CGSize(width: enemyHP/2, height: 15))
        enemyHealthBar.position = CGPoint(x: frame.maxX - 70, y: enemyLabel.position.y - self.size.width/20)
        enemyHealthBar.zPosition = 1
        addChild(enemyHealthBar)
        
        backgroundHealthBar2 = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 15))
        backgroundHealthBar2.position = CGPoint(x: frame.maxX - 70, y: enemyLabel.position.y - self.size.width/20)
        backgroundHealthBar2.zPosition = 0
        addChild(backgroundHealthBar2)
        
        backgroundHealthBar1.alpha = 0
        backgroundHealthBar2.alpha = 0
        playerHealthBar.alpha = 0
        enemyHealthBar.alpha = 0
    }
    func updateHPBars(){
        playerHealthBar.size = CGSize(width: playerHP/2, height: 15)
        
        enemyHealthBar.size = CGSize(width: enemyHP/2, height: 15)
    }
    
    //Creates everything at the beginning
    override func didMove(to view: SKView) {
        //MARK: - Texture Atlas Creation Calls
        createIdleMovement()
        creatAttackMovement()
        createDyingMovement()
        createWalkingMovement()
        createHurtMovement()
        startTimer()
        
        //MARK: - BACKGROUND
        let background = SKSpriteNode(imageNamed: "BG_01")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 1
        background.zPosition = -1
        addChild(background)
        
        //MARK: - Player & Enemy Labels
        playerLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        playerLabel.text = ""
        playerLabel.fontColor = SKColor.black
        playerLabel.fontSize = 35
        playerLabel.position = CGPoint(x: frame.minX + self.size.width/5, y: frame.maxY - self.size.width/6)
                
        self.addChild(playerLabel)
        
        enemyLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        enemyLabel.text = ""
        enemyLabel.fontColor = SKColor.black
        enemyLabel.fontSize = 35
        enemyLabel.position = CGPoint(x: frame.maxX - self.size.width/5, y: frame.maxY - self.size.width/6)
                
        self.addChild(enemyLabel)
        
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
        
        createHPBars()
    }
    
    //Useless function that didn't work
    //Why is it still here?
    //To show an atempt at walking animation was given
    /*
    func walkForward(player: SKSpriteNode){
        let playerWidth = playerCharacter.frame.width / 5
        playerCharacter.run(SKAction.repeat(SKAction.animate(with: walkingStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
            while(playerCharacter.position.x < (frame.minX + playerWidth)){
                playerCharacter.position = CGPoint(x: playerCharacter.position.x + 0.1, y: playerCharacter.position.y)
        }
    }
    */
    
    //Where all the magic happens
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mathProblems()
        if(playButton.alpha > 0.0){
            for touch in touches{
                let node = self.atPoint(touch.location(in :self))
                let position = node.position
                if(position.x == playButton.position.x){
                    if(position.y == playButton.position.y){
                        let alert = UIAlertController(title: "Welcome!", message: "Hi there! This game is just meant to test your basic math ability while giving you a way to smash monsters to bits! The faster you answer the more damge you do. Simple right? \n Ready? \n Set...", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Go!", style: .default, handler: {action in
                            self.playButton.alpha = 0.0
                            self.playerLabel.text = "Player"
                            self.enemyLabel.text = "Enemy"
                            self.playerCharacter.alpha = 1.0
                            self.enemyCharacter.alpha = 1.0
                            
                            self.backgroundHealthBar1.alpha = 1
                            self.backgroundHealthBar2.alpha = 1
                            self.playerHealthBar.alpha = 1
                            self.enemyHealthBar.alpha = 1
                        }))
                        self.view?.window?.rootViewController?.present(alert, animated: true)
                    }
                }
            }
        }
        else{
            attemptAttackAlert()
        }
    }
    //Functions that exisit just cause I need functions
    func endPlayer(){
        playerCharacter.alpha = 0
    }
    func endEnemy(){
        enemyCharacter.alpha = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func attemptAttackAlert(){
        let startTime = seconds
        var damage = 10
        let alert = UIAlertController(title: "Swing!", message: "You're trying to attack? Quick! What's \n \(max(rand1,rand2)) \(operand) \(min(rand1,rand2))\n equal to?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Answer goes here"
        }
        alert.addAction(UIAlertAction(title: "Hit!", style: .default, handler: {action in
            let textfield = alert.textFields![0]
            if(Int(textfield.text!) == self.answer){
                var timeDif = self.seconds - startTime
                if(timeDif < 10){
                    timeDif = (timeDif - 10) * -1
                    damage = damage * timeDif
                    self.enemyHP -= damage
                }
                else{
                    self.enemyHP -= damage
                }
                self.playerCharacter.run(SKAction.repeat(SKAction.animate(with: self.attackStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
                if (self.enemyHP <= 0){
                    self.enemyHealthBar.alpha = 0
                    //If the enemy has no health left run the end of game alert
                    self.enemyCharacter.run(SKAction.repeat(SKAction.animate(with: self.dyingStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1), completion: self.endEnemy)
                    self.endOfGameAlert(loser: false)
                }
                else{
                    //Otherwise the enemy gets smacked
                    self.enemyCharacter.run(SKAction.repeat(SKAction.animate(with: self.hurtStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
                }
            }
            else{
                self.playerHP -= 25
                
                self.enemyCharacter.run(SKAction.repeat(SKAction.animate(with: self.attackStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
                let alert = UIAlertController(title: "Miss!", message: "That's a shame \(max(self.rand1,self.rand2)) \(self.operand) \(min(self.rand1,self.rand2)) is actually equal to \(self.answer)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aw okay!", style: .default, handler: nil))
                self.view?.window?.rootViewController?.present(alert, animated: true)
                if(self.playerHP <= 0){
                    self.playerHealthBar.alpha = 0
                    self.playerCharacter.run(SKAction.repeat(SKAction.animate(with: self.dyingStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1), completion: self.endPlayer)
                    self.endOfGameAlert(loser: true)
                }
                else{
                    self.playerCharacter.run(SKAction.repeat(SKAction.animate(with: self.hurtStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
                }
            }
            self.updateHPBars()
        }))
        self.view?.window?.rootViewController?.present(alert, animated: true)
    }
    
    //The alert pop up that shows when either the player or enemy wins
    func endOfGameAlert(loser: Bool){
        var loserString = ""
        if(loser){
            loserString = "Looks like you lost. Shame about that."
        }
        else{
            loserString = "Looks like you won, congrats!"
        }
        let alert = UIAlertController(title: "Next Fight", message: "\(loserString) Are you ready for your next fight?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            //resets important data for next fight
            self.enemyHP = 200
            self.playerHealthBar.alpha = 1
            self.enemyHealthBar.alpha = 1
            self.enemyCharacter.alpha = 1
            self.updateHPBars()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
            //resets data so that front screen can be seen properly
            self.playButton.alpha = 1.0
            self.playerLabel.text = ""
            self.enemyLabel.text = ""
            self.playerCharacter.alpha = 0
            self.enemyCharacter.alpha = 0
            self.playerHP = 200
            self.enemyHP = 200
            
            self.backgroundHealthBar1.alpha = 0
            self.backgroundHealthBar2.alpha = 0
            self.playerHealthBar.alpha = 0
            self.enemyHealthBar.alpha = 0
            self.updateHPBars()
        }))
        self.view?.window?.rootViewController?.present(alert, animated: true)
    }

}

