//
//  MyScene.h
//  Bubbles FinalProject
//
//  Created by James Zhuang on 7/14/14.
//  Copyright (c) 2014 James Zhuang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene
{
NSTimer *timer;
}
@property (strong,nonatomic) NSMutableArray * bubbleArray;
@property (strong, nonatomic) NSMutableArray *bubblesToRemove;
@property NSInteger lives;
@property (strong,nonatomic) SKLabelNode *health;
@property (weak, nonatomic) SKLabelNode *score;
@property (weak, nonatomic) SKLabelNode *gameOver;
@property (weak, nonatomic) SKLabelNode *yourScore;
@property (weak, nonatomic) SKLabelNode *resume;
@property (weak, nonatomic) SKLabelNode *HighScoreLabel;
@property NSInteger scorePoints;
@property NSInteger HighScore;
@property double bubbleSpeed;
@property BOOL gameEnded;
@property (weak,nonatomic) SKSpriteNode *replay;
@property (weak,nonatomic) SKSpriteNode *menu;
@property (weak,nonatomic) SKSpriteNode *settings;
@property (weak, nonatomic) SKSpriteNode *pause;
@property (weak, nonatomic) SKSpriteNode *resumeButton;
@property BOOL isPaused;
@property BOOL hasPaused;
@property BOOL incSpeed;
@property BOOL hasIncSpeed;
@property NSInteger speedCounter;
@end
