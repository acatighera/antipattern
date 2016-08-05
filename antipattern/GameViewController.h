//
//  GameViewController.h
//  antipattern
//

//  Copyright (c) 2016 Alexandru Catighera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface GameViewController : UIViewController


-(IBAction)startToggle:(id)sender;

@property(nonatomic, strong) IBOutlet UIButton *startToggle;

@end