#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define APGRID_WIDTH 90
#define APGRID_HEIGHT 160

@interface APNodeMap : NSObject

@property(atomic, strong) NSMutableDictionary *nodes;

-(bool)insertNodeAtPos:(CGPoint)pt;
-(void)evolve;
-(void)spawnRandom;

@end