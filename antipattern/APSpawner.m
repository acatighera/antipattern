#import "APSpawner.h"
#import "Patterns.h"

@implementation APSpawner

-(void)spawnRandomOnMap:(APNodeMap *) map {
    for (int i = 0; i < APGRID_WIDTH; i++) {
        for (int j = 0; j < APGRID_HEIGHT; j++) {
            if (arc4random_uniform(7) == 0) {
                [map insertNodeAtPos:CGPointMake(i, j)];
            }
        }
    }
}

-(void)spawnPattern: (NSString *)pattenName atPoint:(CGPoint) pt onMap:(APNodeMap *) map {
    long pindex = [AP_PATTERN_NAMES indexOfObject:pattenName];
    bool pattern[APGRID_WIDTH][APGRID_HEIGHT];
    
    for (int i = 0; i < APGRID_WIDTH; i++) {
        for (int j = 0; j < APGRID_HEIGHT; j++) {
            // rotate patterns to fit
            pattern[i][j] = AP_PATTERNS[pindex][j][i];
        }
    }
    
    int maxX = 0;
    int maxY = 0;
    for (int i = 0; i < APGRID_WIDTH; i++) {
        int x = i + pt.x;
        if (x > APGRID_WIDTH) {
            x = x % APGRID_WIDTH;
        }
        for (int j = 0; j < APGRID_HEIGHT; j++) {
            int y = j + pt.y;
            if (y > APGRID_HEIGHT) {
                y = y % APGRID_HEIGHT;
            }
            if (pattern[i][j] == 1) {
                if (i > maxX) {
                    maxX = i;
                }
                if (j > maxY) {
                    maxY = j;
                }
            }
        }
    }
    int startX = MAX(pt.x - maxX/2, 0);
    int startY = MAX(pt.y - maxY/2, 0);
    [map insertNodes: pattern withOffset:CGPointMake(startX, startY)];
}

@end
