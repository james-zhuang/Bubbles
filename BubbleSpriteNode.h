//
//  BubbleSpriteNode.h
//  Bubbles FinalProject
//
//  Created by James Zhuang on 7/14/14.
//  Copyright (c) 2014 James Zhuang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BubbleSpriteNode : SKSpriteNode
@property NSInteger xSpeed;
@property NSInteger ySpeed;
@property BOOL isBomb;
@property BOOL isHealth;
@property BOOL isSpeed;

@end
