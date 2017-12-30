//
//  MyScene.m
//  Bubbles FinalProject
//
//  Created by James Zhuang on 7/14/14.
//  Copyright (c) 2014 James Zhuang. All rights reserved.
//

#import "MenuScreen.h"
#import "MyScene.h"

@implementation MenuScreen

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"start"];
        [bg setXScale:(CGRectGetWidth(self.frame)/bg.frame.size.width)];
        [bg setYScale:CGRectGetHeight(self.frame)/bg.frame.size.height];
        [bg setZPosition:-1];
        
        [bg setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self addChild:bg];
        
        self.play = [SKSpriteNode spriteNodeWithImageNamed:@"startButton"];
        
        [self.play setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+60)];
        [self.play setXScale:1.5];
        [self.play setYScale:1.5];
        [self addChild:self.play];
        
        SKSpriteNode *settings = [SKSpriteNode spriteNodeWithImageNamed:@"setting"];
        
        [settings setPosition:CGPointMake(CGRectGetMidX(self.frame)-60, CGRectGetMidY(self.frame)-20)];
        [settings setXScale:1];
        [settings setYScale:1];
        [self addChild:settings];
        
        SKSpriteNode *tutorial = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial"];
        
        [tutorial setPosition:CGPointMake(CGRectGetMidX(self.frame)+60, CGRectGetMidY(self.frame)-20)];
        [settings setXScale:1];
        [settings setYScale:1];
        [self addChild:tutorial];

        
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            if(CGRectContainsPoint(self.play.frame, location))
            {
                SKView * skView = (SKView *)self.view;
                skView.showsFPS = YES;
                skView.showsNodeCount = YES;
                SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:scene];
            }
            
            
        }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    }
@end
