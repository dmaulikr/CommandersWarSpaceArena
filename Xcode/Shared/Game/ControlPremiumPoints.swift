//
//  ControlPoints.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/17/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class ControlPremiumPoints: Control {
    
    static func current() -> ControlPremiumPoints? {
        return ControlPremiumPoints.lastInstance
    }
    private static weak var lastInstance: ControlPremiumPoints? = nil
    
    private weak var labelPremiumPoints: Label!

    init(x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        
        super.init(imageNamed: "box_144x55", x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        self.set(color: GameColors.premiumPoints)
        
        let buttonBuyMore = Button(imageNamed: "button_55x55", x: 144, y: 0)
        buttonBuyMore.setIcon(imageNamed: "Plus")
        buttonBuyMore.set(color: GameColors.premiumPoints, blendMode: .add)
        self.addChild(buttonBuyMore)
        
        self.labelPremiumPoints = Label(text: "?", fontColor: GameColors.premiumPoints, x: 97, y: 27)
        self.addChild(self.labelPremiumPoints)
        
        let icon = Control(imageNamed: "Minecraft Diamond", x: 0, y: 0)
        icon.size = CGSize(width: 55, height: 55)
        icon.set(color: GameColors.premiumPoints)
        self.addChild(icon)
        
        ControlPremiumPoints.lastInstance = self
        
        #if os(iOS)
            let gameAdManager = GameAdManager.sharedInstance
            
            gameAdManager.onAdAvailabilityChange = { [weak buttonBuyMore] isReady in
                buttonBuyMore?.isHidden = !gameAdManager.isReady
            }
            
            gameAdManager.onVideoAdAttemptFinished = { [weak self] shown in
                guard let `self` = self else { return }
                guard let scene = GameScene.current() else { return }
                
                let playerData = MemoryCard.sharedInstance.playerData!
                let bonusPremiumPoints = 1 + Int.random(100)
                
                playerData.premiumPoints = playerData.premiumPoints + Int32(bonusPremiumPoints)
                self.setLabelPremiumPointsText(premiumPoints: playerData.premiumPoints)
                
                let boxVideoAdAttemptFinished = BoxVideoAdAttemptFinished(bonusPremiumPoints: bonusPremiumPoints)
                boxVideoAdAttemptFinished.zPosition = MainMenuScene.zPosition.box.rawValue
                scene.blackSpriteNode.isHidden = false
                scene.blackSpriteNode.zPosition = MainMenuScene.zPosition.blackSpriteNode.rawValue
                scene.addChild(boxVideoAdAttemptFinished)
                scene.blackSpriteNode.removeAllHandlers()
                scene.blackSpriteNode.addHandler { [weak boxVideoAdAttemptFinished] in
                    boxVideoAdAttemptFinished?.removeFromParent()
                    GameScene.current()?.blackSpriteNode.isHidden = true
                }
            }
            
            buttonBuyMore.isHidden = !gameAdManager.isReady
            
            buttonBuyMore.addHandler {
                guard let scene = GameScene.current() else { return }
                
                let boxWatchAd = BoxWatchAd()
                boxWatchAd.zPosition = MainMenuScene.zPosition.box.rawValue
                scene.blackSpriteNode.isHidden = false
                scene.blackSpriteNode.zPosition = MainMenuScene.zPosition.blackSpriteNode.rawValue
                scene.addChild(boxWatchAd)
                scene.blackSpriteNode.removeAllHandlers()
                scene.blackSpriteNode.addHandler { [weak boxWatchAd] in
                    boxWatchAd?.removeFromParent()
                    GameScene.current()?.blackSpriteNode.isHidden = true
                }
            }
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelPremiumPointsText(premiumPoints: Int32) {
        self.labelPremiumPoints.text = premiumPoints.pointsString()
    }
}
