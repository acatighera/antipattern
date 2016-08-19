#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property(atomic, assign) bool isRunning;
@property(nonatomic, strong) NSString *patternToPlace;

-(void)start;
-(void)stop;
-(void)clearCanvasAndData;
-(void)spawnRandomNodesOnMap;

@end
