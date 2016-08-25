//
//  GameViewController.m
//  antipattern
//
//  Created by Alexandru Catighera on 8/2/16.
//  Copyright (c) 2016 Alexandru Catighera. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "Patterns.h"

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
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
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

#pragma mark - IBActions

-(IBAction)startToggle:(id)sender {
    if ([self.scene isRunning]) {
        [self.scene stop];
        [self.startToggle setAttributedTitle:self.playTitle forState:UIControlStateNormal];
    } else {
        [self.scene start];
        [self.startToggle setAttributedTitle:self.stopTitle forState:UIControlStateNormal];
    }
}

-(IBAction)addPattern:(id)sender {
    if ([self.tableView isHidden]) {
        [self.tableView setHidden:NO];
        [self flashPatternTableViewScrollIndicators];
    } else {
        [self.tableView setHidden:YES];
    }
}

-(void)flashPatternTableViewScrollIndicators {
    __weak GameViewController *gvc = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [gvc.tableView flashScrollIndicators];
    });
}

-(IBAction)clear:(id)sender {
    [self.scene stop];
    [self.startToggle setAttributedTitle:self.playTitle forState:UIControlStateNormal];
    [self.scene clearCanvasAndData];
    if (!self.tableView.isHidden) {
        [self.tableView setHidden:YES];
    }
}

#pragma mark - Pattern Picker TableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"patternPickerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"random";
    } else {
        cell.textLabel.text = [AP_PATTERN_NAMES objectAtIndex:indexPath.row - 1];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AP_PATTERN_NAMES count] + 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.scene spawnRandomNodesOnMap];
    } else {
        [self.alert setText:@"Tap on map to place, ✕ to clear first"];
        [self.alert setAlpha:1.0f];
        [UIView animateWithDuration:7.5 animations:^{
            [self.alert setAlpha:0.0f];
        }];
        self.scene.patternToPlace = [AP_PATTERN_NAMES objectAtIndex:(indexPath.row -1)];
    }
    [tableView setHidden:YES];
}


@end
