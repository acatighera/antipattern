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
@property(nonatomic, strong) NSAttributedString *playTitle;
@property(nonatomic, strong) NSAttributedString *stopTitle;
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
    
    // Create Button Styles
    self.playTitle = self.startToggle.currentAttributedTitle;
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:18.0];
    NSMutableDictionary *attrsDictionary = [NSMutableDictionary dictionary];
    [attrsDictionary setObject:font forKey:NSFontAttributeName];
    [attrsDictionary setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.stopTitle = [[NSAttributedString alloc] initWithString:@"❚❚" attributes:attrsDictionary];
    
    
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

-(IBAction)startToggle:(id)sender {
    if ([self.scene isRunning]) {
        [self.scene stop];
        [self.startToggle setAttributedTitle:self.playTitle forState:UIControlStateNormal];
    } else {
        [self.scene start];
        [self.startToggle setAttributedTitle:self.stopTitle forState:UIControlStateNormal];
    }
}

@end
