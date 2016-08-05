//
//  GameScene.h
//  antipattern
//

//  Copyright (c) 2016 Alexandru Catighera. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property(atomic, assign) bool isRunning;

-(void)start;
-(void)stop;

@end
