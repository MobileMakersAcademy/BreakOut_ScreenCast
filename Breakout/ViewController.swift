//
//  ViewController.swift
//  Breakout
//
//  Created by Bruce Wayne on 9/6/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate
{

    var blockArray : [UIView] = []
    var allViewsArray : [UIView] = []
    var deletedBlockArray : [UIView] = []
    var paddle : UIView!
    var ball : UIView!
    var dynamicAnimator = UIDynamicAnimator()
    var ballBehavior = UIDynamicItemBehavior()
    var collisionBehavior = UICollisionBehavior()
                            
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        dynamicAnimator = UIDynamicAnimator(referenceView: view)

        var x = 5 as CGFloat
        var y = 10 as CGFloat

        for i in 1...3
        {
            for e in 1...5
            {
                var blockView = UIView(frame: CGRectMake(x, y, 55, 20))
                blockView.backgroundColor = UIColor.redColor()
                view.addSubview(blockView)

                blockArray.append(blockView)
                allViewsArray.append(blockView)

                x += 60
            }
            x = 5
            y += 25
        }

        paddle = UIView(frame: CGRectMake(130, 430, 60, 30))
        paddle.backgroundColor = UIColor.blackColor()
        view.addSubview(paddle)
        allViewsArray.append(paddle)

        ball =  UIView(frame: CGRectMake(150, 250, 20, 20))
        ball.backgroundColor = UIColor.greenColor()
        view.addSubview(ball)
        allViewsArray.append(ball)
        ball.hidden = true

        giveDynamicProperties()

    }

    func giveDynamicProperties()
    {
        ballBehavior = UIDynamicItemBehavior(items: [ball])
        ballBehavior.friction = 0.0
        ballBehavior.resistance = 0.0
        ballBehavior.elasticity = 1.0
        ballBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(ballBehavior)

        var paddleBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleBehavior.density = 10000
        paddleBehavior.elasticity = 1.0
        paddleBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(paddleBehavior)

        var blockBehavior = UIDynamicItemBehavior(items: blockArray)
        blockBehavior.density = 1000
        blockBehavior.elasticity = 1.0
        blockBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(blockBehavior)

        collisionBehavior = UICollisionBehavior(items: allViewsArray)
        collisionBehavior.collisionMode = UICollisionBehaviorMode.Everything
        collisionBehavior.collisionDelegate = self
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)

    }

    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint)
    {
        for block in blockArray
        {
            if item1.isEqual(ball) && item2.isEqual(block) || item1.isEqual(block) && item2.isEqual(ball)
            {
                block.hidden = true
                collisionBehavior.removeItem(block)
                dynamicAnimator.updateItemUsingCurrentState(block)
                deletedBlockArray.append(block)
            }
        }
    }

    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint)
    {
        if p.y > paddle.center.y
        {
            ballBehavior.resistance = 100.0
            ball.center = CGPointMake(150, 250)
            ball.hidden = true
            startButton.hidden = false
            dynamicAnimator.updateItemUsingCurrentState(ball)

            for block in deletedBlockArray
            {
                block.hidden = false
                collisionBehavior.addItem(block)
                dynamicAnimator.updateItemUsingCurrentState(block)
            }

            deletedBlockArray.removeAll(keepCapacity: false)
        }
    }

    @IBAction func onPressedStartGame(sender: UIButton)
    {
        ballBehavior.resistance = 0.0
        dynamicAnimator.updateItemUsingCurrentState(ball)
        ball.hidden = false
        var pushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = 0.1
        pushBehavior.angle = 1.0
        pushBehavior.active = true
        dynamicAnimator.addBehavior(pushBehavior)

        sender.hidden = true
    }

    @IBAction func onDragged(sender: UIPanGestureRecognizer)
    {
        paddle.center = CGPointMake(sender.locationInView(view).x, paddle.center.y)
        dynamicAnimator.updateItemUsingCurrentState(paddle)
    }

}














