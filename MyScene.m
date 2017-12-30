//
//  MyScene.m
//  Bubbles FinalProject
//
//  Created by James Zhuang on 7/14/14.
//  Copyright (c) 2014 James Zhuang. All rights reserved.
//

#import "MyScene.h"
#import "MenuScreen.h"
#import "BubbleSpriteNode.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.HighScore = 0;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger tempCount = [defaults integerForKey:@"highscore"];
        if( tempCount)
            self.HighScore = (int)tempCount;
        
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
        [bg setXScale:(CGRectGetWidth(self.frame)/bg.frame.size.width)];
        [bg setYScale:CGRectGetHeight(self.frame)/bg.frame.size.height];
        [bg setZPosition:-1];
        
        [bg setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self addChild:bg];
        
        self.bubbleArray = [[NSMutableArray alloc] init];
        self.bubblesToRemove = [[NSMutableArray alloc] init];
        timer = [NSTimer timerWithTimeInterval:0.4
                                        target:self
                                      selector:@selector(spawnBubble)
                                      userInfo:nil
                                       repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        self.gameEnded = false;
        self.lives = 3;
        
        self.health = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Medium"];
        [self.health setText: [NSString stringWithFormat:@"Lives: %d",self.lives]];
        self.health.fontSize = 13;
        self.health.position = CGPointMake(CGRectGetMinX(self.frame)+50, CGRectGetMaxY(self.frame)-40);
        [self addChild:self.health];
        
        self.scorePoints = 0;
        self.score = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Medium"];
        [self.score setText: [NSString stringWithFormat:@"Score: %d",self.scorePoints]];
        self.score.fontSize = 13;
        self.score.position = CGPointMake(CGRectGetMaxX(self.frame)-60, CGRectGetMaxY(self.frame)-40);
        [self addChild:self.score];
        
        self.pause = [SKSpriteNode spriteNodeWithImageNamed:@"pause"];
        [self.pause setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-35)];
        [self.pause setXScale:0.5];
        [self.pause setYScale:0.5];
        [self addChild:self.pause];
        self.isPaused = false;
        
        self.bubbleSpeed = 3;
        self.hasPaused = false;
        self.speedCounter = 0;

        //[self.view presentScene:...]
    }
    return self;
}
-(void) spawnBubble{
    BubbleSpriteNode *bubble = [BubbleSpriteNode spriteNodeWithImageNamed:@"bubble"];
    NSInteger randomPosition = (arc4random()%270)+30;
    
    [bubble setPosition:CGPointMake(randomPosition, CGRectGetHeight(self.frame)-20)];
    
    double randomSpeed = -(arc4random()%2+self.bubbleSpeed);
    
    [bubble setYSpeed:randomSpeed];
    
    [self.bubbleArray addObject:bubble];
    [self addChild:bubble];
    
    if(arc4random()%50 ==1)
    {
        BubbleSpriteNode *bomb = [BubbleSpriteNode spriteNodeWithImageNamed:@"bomb"];
        bomb.isBomb = true;
        NSInteger randomPosition = (arc4random()%270)+30;
        
        [bomb setPosition:CGPointMake(randomPosition, CGRectGetHeight(self.frame)-20)];
        
        double randomSpeed = -(arc4random()%2+self.bubbleSpeed);
        
        [bomb setYSpeed:randomSpeed];
        
        [self.bubbleArray addObject:bomb];
        [self addChild:bomb];
    }
    else if (arc4random()%40 ==1)
    {
        BubbleSpriteNode *health = [BubbleSpriteNode spriteNodeWithImageNamed:@"heart"];
        health.isHealth = true;
        NSInteger randomPosition = (arc4random()%270)+30;
        
        [health setPosition:CGPointMake(randomPosition, CGRectGetHeight(self.frame)-20)];
        
        double randomSpeed = -(arc4random()%2+self.bubbleSpeed);
        
        [health setYSpeed:randomSpeed];
        
        [self.bubbleArray addObject:health];
        [self addChild:health];
    }
    else if(arc4random()%50 ==1)
    {
        BubbleSpriteNode *speed = [BubbleSpriteNode spriteNodeWithImageNamed:@"speed"];
        speed.isSpeed = true;
        NSInteger randomPosition = (arc4random()%270)+30;
        
        [speed setPosition:CGPointMake(randomPosition, CGRectGetHeight(self.frame)-20)];
        
        double randomSpeed = -(arc4random()%2+self.bubbleSpeed);
        
        [speed setYSpeed:randomSpeed];
        
        [self.bubbleArray addObject:speed];
        [self addChild:speed];

    }
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            if(self.gameEnded == false)
            {
                if(self.isPaused == false)
                {
                    for (BubbleSpriteNode *bubble in self.bubbleArray) {
                        if(CGRectContainsPoint(bubble.frame, location))
                        {
                            [bubble removeFromParent];
                            [self.bubblesToRemove addObject:bubble];
                            if(bubble.isBomb)
                            {
                                self.lives = 0;
                                [self.health setText: [NSString stringWithFormat:@"Lives: %d",self.lives]];
                                
                            }
                            else if(bubble.isHealth)
                            {
                                self.lives ++;
                                [self.health setText: [NSString stringWithFormat:@"Lives: %d",self.lives]];
                            }
                            else if(bubble.isSpeed)
                            {
                                self.incSpeed = true;
                            }
                            else
                            {
                                self.scorePoints += -5+2*self.bubbleSpeed;
                                [self.score setText: [NSString stringWithFormat:@"Score: %d",self.scorePoints]];
                            }
                        }
                    }
                }
                
                for (BubbleSpriteNode *bubble in self.bubblesToRemove) {
                    [self.bubbleArray removeObject:bubble];
                }
                [self.bubblesToRemove removeAllObjects];
                
                if(CGRectContainsPoint(self.pause.frame, location))
                {
                    self.isPaused = true;
                }
                if(self.isPaused && CGRectContainsPoint(self.resumeButton.frame, location))
                {
                    self.isPaused = false;
                    self.hasPaused = false;
                    
                    [self.resumeButton removeFromParent];
                    [self.resume removeFromParent];
                    
                    self.pause = [SKSpriteNode spriteNodeWithImageNamed:@"pause"];
                    [self.pause setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-35)];
                    [self.pause setXScale:0.5];
                    [self.pause setYScale:0.5];
                    [self addChild:self.pause];
                    timer = [NSTimer timerWithTimeInterval:0.4
                                                    target:self
                                                  selector:@selector(spawnBubble)
                                                  userInfo:nil
                                                   repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                }
            }
            else
            {
                if(CGRectContainsPoint(self.replay.frame, location) || CGRectContainsPoint(self.menu.frame, location))
                {
                    self.lives = 3;
                    [self.health setText:[NSString stringWithFormat:@"Lives: %d", self.lives]];
                    
                    self.bubbleSpeed = 3;
                    self.gameEnded = false;
                    
                    self.scorePoints = 0;
                    [self.score setText: [NSString stringWithFormat:@"Score: %d",self.scorePoints]];
                    
                    for (BubbleSpriteNode *bubble in self.bubbleArray) {
                            [bubble removeFromParent];
                    }
                    
                    self.pause = [SKSpriteNode spriteNodeWithImageNamed:@"pause"];
                    [self.pause setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-35)];
                    [self.pause setXScale:0.5];
                    [self.pause setYScale:0.5];
                    [self addChild:self.pause];
                    [self.bubbleArray removeAllObjects];
                    [self.yourScore removeFromParent];
                    [self.gameOver removeFromParent];
                    [self.replay removeFromParent];
                    [self.menu removeFromParent];
                    [self.settings removeFromParent];
                    [self.HighScoreLabel removeFromParent];
                    
                    if(CGRectContainsPoint(self.replay.frame, location))
                    {
                        timer = [NSTimer timerWithTimeInterval:0.4
                                                        target:self
                                                      selector:@selector(spawnBubble)
                                                      userInfo:nil
                                                       repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                    }
                    else if(CGRectContainsPoint(self.menu.frame, location))
                    {
                        SKView * skView = (SKView *)self.view;
                        skView.showsFPS = YES;
                        skView.showsNodeCount = YES;
                        SKScene * scene = [MenuScreen sceneWithSize:skView.bounds.size];
                        scene.scaleMode = SKSceneScaleModeAspectFill;
                        [self.view presentScene:scene];
                    }

                }

            }
            
        }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(self.isPaused == false)
    {
        for (BubbleSpriteNode *bubble in self.bubbleArray) {
            [bubble setPosition:CGPointMake(bubble.position.x,bubble.position.y + bubble.ySpeed)];
            if (bubble.frame.origin.y < 70)
            {
                if(bubble.isBomb ==false && bubble.isHealth == false && bubble.isSpeed == false)
                {
                    self.lives --;
                    if(self.lives>=0)
                    {
                        [self.health setText: [NSString stringWithFormat:@"Lives: %d",self.lives]];
                    }
                }
                [bubble removeFromParent];
                [self.bubblesToRemove addObject:bubble];
            }
        }
        for (BubbleSpriteNode *bubble in self.bubblesToRemove) {
            [self.bubbleArray removeObject:bubble];
        }
        [self.bubblesToRemove removeAllObjects];
        
        if(self.incSpeed ==true && self.speedCounter <100)
        {
            self.speedCounter ++;
            if(self.hasIncSpeed == false)
            {
                self.bubbleSpeed +=3;
                self.hasIncSpeed =true;
            }
        }
        else
        {
            self.speedCounter = 0;
            self.incSpeed = false;
            if(self.hasIncSpeed == true)
            {
                self.bubbleSpeed -=3;
            }
            self.hasIncSpeed = false;
            
        }
        
        self.bubbleSpeed += 0.002;
        
        
        //GAMEOVER
        
        if (self.lives <=0)
        {
            if(self.gameEnded == false)
            {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //count= 0;
                if(self.scorePoints>self.HighScore)
                    self.HighScore = self.scorePoints;
                [defaults setInteger: self.HighScore forKey:@"highscore"];
                [defaults synchronize];

               
                self.gameOver = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Medium"];
                self.gameOver.text = @"Game Over";
                self.gameOver.fontSize = 20;
                self.gameOver.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+70);
                [self addChild:self.gameOver];
                
                self.yourScore = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Medium"];
                self.yourScore.text = [NSString stringWithFormat:@"Your Score: %d", self.scorePoints];
                self.yourScore.fontSize = 35;
                self.yourScore.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+35);
                [self addChild:self.yourScore];
                
                self.HighScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Medium"];
                self.HighScoreLabel.text = [NSString stringWithFormat:@"HighScore: %ld", (long)self.HighScore];
                self.HighScoreLabel.fontSize = 20;
                self.HighScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+11);
                [self addChild:self.HighScoreLabel];
                
                self.replay = [SKSpriteNode spriteNodeWithImageNamed:@"replay"];
                [self.replay setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-30)];
                [self addChild:self.replay];
                
                self.menu = [SKSpriteNode spriteNodeWithImageNamed:@"menu"];
                [self.menu setPosition:CGPointMake(CGRectGetMidX(self.frame)-80, CGRectGetMidY(self.frame)-30)];
                [self.menu setXScale:0.8];
                [self.menu setYScale:0.8];
                [self addChild:self.menu];
                
                self.settings = [SKSpriteNode spriteNodeWithImageNamed:@"setting2"];
                
                [self.settings setPosition:CGPointMake(CGRectGetMidX(self.frame)+80, CGRectGetMidY(self.frame)-30)];
                [self.settings setXScale:0.8];
                [self.settings setYScale:0.8];
                [self addChild:self.settings];
            
                [timer invalidate];
                [self.pause removeFromParent];
                self.gameEnded = true;
            }
        }
    }
    else
    {
        [timer invalidate];
        if (self.hasPaused == false)
        {
            [self.pause removeFromParent];
            self.resume = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Medium"];
            self.resume.text = @"Resume";
            self.resume.fontSize = 50;
            self.resume.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+50);
            [self addChild:self.resume];
            
            self.resumeButton = [SKSpriteNode spriteNodeWithImageNamed:@"startButton"];
            [self.resumeButton setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-20)];
            [self addChild:self.resumeButton];
            
            self.hasPaused = true;
        }
        
    }

}

@end
