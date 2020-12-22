//
//  GameScene.swift
//  Math Fighters
//
//  Created by Letts, Sean Aleksey on 11/30/20.
//  Sean Letts and Davis Fairchild
//

import SpriteKit

class GameScene: SKScene {

    //MARK: - MyLabel and Math vars
    var playerLabel:SKLabelNode!
    var enemyLabel:SKLabelNode!
    //set up math variables for math functions
    var rand1: Int = 0
    var rand2: Int = 0
    var answer: Int = 0
    var toPrint: String = ""
    var operand: String = ""
    
    //set up arrays for animations (collection of PNGs)
    var idleStanceArray = [SKTexture]()
    var attackStanceArray = [SKTexture]()
    var dyingStanceArray = [SKTexture]()
    //var walkingStanceArray = [SKTexture]()//unused
    var hurtStanceArray = [SKTexture]()
    
    //set up graphics
    var playerCharacter = SKSpriteNode()
    var enemyCharacter = SKSpriteNode()
    var playButton = SKSpriteNode()
    
    //test - which animation will run, timer - timer, seconds - how long in timer
    var test = 0
    var timer: Timer? = nil
    var seconds: Int = 0
    
    //set up health bar stuff and streak
    var playerHP = 200
    var enemyHP = 200
    var streak = 0
    
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
    //unused
    /*
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
    }*/
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
    //function which will generate multiplication, addition, or subtraction problems
    //the problems are used to quiz the user so they have to do math if they want to hurt
    //  the enemy
    //the goal of this is to orient the game in a learning way
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
    
    //function to create health bar graphics
    //as player or enemy take damage, they will show red to determine how much health
    // each golem has left
    func createHPBars(){
        playerHealthBar = SKSpriteNode(color: .green, size: CGSize(width: playerHP/2, height: 15))
        playerHealthBar.position = CGPoint(x: frame.minX + 60, y: playerLabel.position.y - self.size.width/20)
        playerHealthBar.zPosition = 1
        addChild(playerHealthBar)
        
        //as damage is taken, red appears
        backgroundHealthBar1 = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 15))
        backgroundHealthBar1.position = CGPoint(x: frame.minX + 60, y: playerLabel.position.y - self.size.width/20)
        backgroundHealthBar1.zPosition = 0
        addChild(backgroundHealthBar1)
        //enemy
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
    //inits stuff like the play button and the golems and their animations
    override func didMove(to view: SKView) {
        //MARK: - Texture Atlas Creation Calls
        createIdleMovement()
        creatAttackMovement()
        createDyingMovement()
        //createWalkingMovement() //unused
        createHurtMovement()
        startTimer()
        
        //MARK: - BACKGROUND
        //places snowy background on screen
        let background = SKSpriteNode(imageNamed: "BG_01")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 1
        background.zPosition = -1
        addChild(background)
        
        //MARK: - Player & Enemy Labels
        //for on screen text, ended up not using it for alerts because they
        //  were easier to see, but this could be used to show everyone on screen
        playerLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        playerLabel.text = ""
        playerLabel.fontColor = SKColor.black
        playerLabel.fontSize = 35
        playerLabel.position = CGPoint(x: frame.minX + self.size.width/5, y: frame.maxY - self.size.width/6)
        self.addChild(playerLabel)
        //more legacy
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
        //main menu plpay button
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
    //To show an attempt at walking animation was given
    //Practice for anims that wasn't necessary in the end
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
    //the game starts with a message about how to play
    //then when user taps they are prompted for math problems
    //if they get them right they do damage to enemy, based on how fast they get it
    //if they get it wrong, they take damage
    //if enemy dies, a streak is updated and player can go to start menu or keep fighting
    //if player dies the game resets to menu
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mathProblems()
        if(playButton.alpha > 0.0){
            for touch in touches{
                let node = self.atPoint(touch.location(in :self))
                let position = node.position
                if(position.x == playButton.position.x){
                    if(position.y == playButton.position.y){
                        let alert = UIAlertController(title: "Welcome!", message: "This game is meant to test your basic math abilities while giving you a way to smash monsters to bits! The faster you answer each question the more damge you do. The game ends when you answer too many questions wrong, so go until you are defeated! Simple right? \n Ready? \n Set...", preferredStyle: .alert)
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
    //this sets the golems to be "transparent" - they won't appear when not needed
    func endPlayer(){
        playerCharacter.alpha = 0
    }
    func endEnemy(){
        enemyCharacter.alpha = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //used to track time
    }
    
    //if player has health left, they will be prompted for math to do damage
    //else they are sent back to menu and the screen is reset
    func attemptAttackAlert(){
        if (playerHP > 0){
            let startTime = seconds
            var damage = 10
            let alert = UIAlertController(title: "Swing!", message: "You're trying to attack? Quick! What's the answer to \n \(max(rand1,rand2)) \(operand) \(min(rand1,rand2))?", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Answer goes here."
            }
            //tells player if they hit and then calculates damage based on how long it took them to answer
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
                    //run anims
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
                //player got question wrong and takes damage
                else{
                    //player has 5 chances with 200 hp and -40 hp on losses
                    self.playerHP -= 40
                    //run anims
                    self.enemyCharacter.run(SKAction.repeat(SKAction.animate(with: self.attackStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
                    let alert = UIAlertController(title: "Miss!", message: "Unfortunately \(max(self.rand1,self.rand2)) \(self.operand) \(min(self.rand1,self.rand2)) is actually equal to \(self.answer)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Aw okay!", style: .default, handler: nil))
                    self.view?.window?.rootViewController?.present(alert, animated: true)
                    //update hp
                    if(self.playerHP <= 0){
                        self.playerHealthBar.alpha = 0
                        self.playerCharacter.run(SKAction.repeat(SKAction.animate(with: self.dyingStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1), completion: self.endPlayer)
                        self.endOfGameAlert(loser: true)
                    }
                    else{
                        self.playerCharacter.run(SKAction.repeat(SKAction.animate(with: self.hurtStanceArray, timePerFrame: 0.05, resize: false, restore: true), count: 1))
                    }
                }
                //update hp
                self.updateHPBars()
            }))
            self.view?.window?.rootViewController?.present(alert, animated: true)
        }else{
            //resets data so that front screen can be seen properly
            //these params are reset every time the screen needs to be cleared
            //this makes things "transparent" rather than completely removing the objects since they will still be used
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
            self.streak = 0
        }
    }
    
    //The alert pop up that shows when either the player or enemy wins
    func endOfGameAlert(loser: Bool){
        var loserString = ""
        if(loser){
            loserString = "Looks like you lost. There's always next time!."
        }
        else{
            self.streak += 1
            loserString = "You won, congrats! You've defeated \(streak) enemies."
        }
        //pop up after battle is over
        let alert = UIAlertController(title: "Next Fight", message: "\(loserString) Are you ready for your next fight?", preferredStyle: .alert)
        //resets enemy hp and keeps fighting
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            //resets important data for next fight
            self.enemyHP = 200
            self.playerHealthBar.alpha = 1
            self.enemyHealthBar.alpha = 1
            self.enemyCharacter.alpha = 1
            self.updateHPBars()
        }))
        //ends fight and goes to menu
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
            self.streak = 0
        }))
        self.view?.window?.rootViewController?.present(alert, animated: true)
    }

}

