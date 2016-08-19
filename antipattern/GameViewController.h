//
//  GameViewController.h
//  antipattern
//

//  Copyright (c) 2016 Alexandru Catighera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface GameViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


-(IBAction)startToggle:(id)sender;
-(IBAction)addPattern:(id)sender;
-(IBAction)clearGrid:(id)sender;

@property(nonatomic, strong) IBOutlet UIButton *startToggle;
@property(nonatomic, strong) IBOutlet UILabel *alert;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end