//
//  WhackSlot.swift
//  project14-Whack-a-Penguin
//
//  Created by Felipe Gil on 2021-08-05.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    let goodPenguin = "penguinGood"
    let goodNode = "charFriend"
    let badNode = "charEnemy"
    let badPenguin = "penguinEvil"
    let smokeEffect = "smoke.sks"
    let holeImage = "whackHole"
    let holeMask = "whackMask"
    
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: holeImage)
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: holeMask)
        
        charNode = SKSpriteNode(imageNamed: goodPenguin)
        charNode.position = CGPoint(x: 0, y: -90)
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: goodPenguin)
            charNode.name = goodNode
        } else {
            charNode.texture = SKTexture(imageNamed: badPenguin)
            charNode.name = badNode
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
        [weak self] in
            self?.hidePenguin()
        }
    }
    func hidePenguin() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        guard let smokeEffect = SKEmitterNode(fileNamed: smokeEffect) else { return }
        smokeEffect.zPosition = 1
        addChild(smokeEffect)
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            smokeEffect.removeFromParent()
        }
    }
}
