#import <Foundation/Foundation.h>
#import "APNodeMap.h"

@interface APSpawner : NSObject

-(void)spawnRandomOnMap:(APNodeMap *) map;
-(void)spawnPattern: (NSString *)pattenName atPoint:(CGPoint) pt onMap:(APNodeMap *) map;

@end
