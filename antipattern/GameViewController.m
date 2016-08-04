//
//  GameViewController.m
//  antipattern
//
//  Created by Alexandru Catighera on 8/2/16.
//  Copyright (c) 2016 Alexandru Catighera. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"


@interface GameViewController()
@property(nonatomic, strong) GameScene *scene;
@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    self.scene = [GameScene nodeWithFileNamed:@"GameScene"];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:self.scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(IBAction)start:(id)sender {
    [self.scene start];
}

@end
