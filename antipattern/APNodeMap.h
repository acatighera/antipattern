#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APNode.h"

#define APGRID_WIDTH 60
#define APGRID_HEIGHT 120

@interface APNodeMap : NSObject

@property(nonatomic, strong) NSMutableDictionary *nodes;

-(APNode *)insertNodeAtPos:(CGPoint)pt;
-(void)evolve;

@end