#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define APGRID_WIDTH 60
#define APGRID_HEIGHT 120

@interface APNodeMap : NSObject

@property(nonatomic, strong) NSMutableDictionary *nodes;

-(bool)insertNodeAtPos:(CGPoint)pt;
-(void)evolve;

@end