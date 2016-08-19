#import "APNodeMap.h"
#import "Patterns.h"

@interface APNodeMap () {
    bool _map[APGRID_WIDTH][APGRID_HEIGHT];
}

@end

@implementation APNodeMap

-(id) init {
    [self setNodes:[NSMutableDictionary dictionary]];
    return [super init];
}


- (void)insertNodes:(bool [APGRID_WIDTH][APGRID_HEIGHT]) rawMap withOffset:(CGPoint) offset {
    for(int i = 0; i < APGRID_WIDTH; i++){
        for(int j = 0; j < APGRID_HEIGHT; j++){
            if (rawMap[i][j]) {
                [self insertNodeAtPos:CGPointMake(i + offset.x, j + offset.y)];
            }
        }
    }
}

-(bool)insertNodeAtPos:(CGPoint)pt {
    if ([self isAliveNodeAtPos:pt]) {
        return NO;
    }
    if (pt.x >= APGRID_WIDTH || pt.y >= APGRID_HEIGHT) {
        pt = CGPointMake((int)pt.x % APGRID_WIDTH, (int)pt.y % APGRID_HEIGHT);
    }
    _map[(int)pt.x][(int)pt.y] = YES;
    [self.nodes setValue:[NSValue valueWithCGPoint:pt] forKey:[self keyForCGPoint:pt]];
    return YES;
}

-(NSString *)keyForCGPoint:(CGPoint)pt {
    return [NSString stringWithFormat:@"%i|%i", (int)pt.x, (int)pt.y];
}

-(CGPoint)pointForKey:(NSString *)key {
    NSValue *value = [self.nodes valueForKey:key];
    if (value) {
        return [value CGPointValue];
    } else {
        return CGPointMake(0,0);
    }
}

-(void)evolve {
    @synchronized (self) {
        NSMutableDictionary *newNodes = [NSMutableDictionary dictionary];
        bool evolvedMap[APGRID_WIDTH][APGRID_HEIGHT];
        [self overwriteMap:evolvedMap withMap:_map];
        
        for (NSValue *val in [self.nodes allValues]) {
            int aliveCount = 0;
            CGPoint pt = [val CGPointValue];
            for (NSValue *neighborVal in [self getNeighborsAt:pt]) {
                CGPoint neighborPt = [neighborVal CGPointValue];
                if (_map[(int)neighborPt.x][(int)neighborPt.y]) {
                    aliveCount++;
                } else {
                    bool shouldRevive = [self shouldReviveNodeAt:neighborPt];
                    if (shouldRevive) {
                        NSString *neighborKey = [self keyForCGPoint:neighborPt];
                        evolvedMap[(int)neighborPt.x][(int)neighborPt.y] = YES;
                        [newNodes setValue:[NSValue valueWithCGPoint:neighborPt] forKey:neighborKey];
                    }
                }
            }
            
            if (aliveCount != 2 && aliveCount != 3) {
                evolvedMap[(int)pt.x][(int)pt.y] = NO;
                [self.nodes removeObjectForKey:[self keyForCGPoint:pt]];
            }
            
        }
        
        [self.nodes addEntriesFromDictionary:newNodes];
        [self overwriteMap:_map withMap:evolvedMap];
    }
}

-(void)overwriteMap:(bool [APGRID_WIDTH][APGRID_HEIGHT])map
            withMap:(bool [APGRID_WIDTH][APGRID_HEIGHT])newMap {
    memcpy(map, newMap, sizeof(bool) * APGRID_WIDTH * APGRID_HEIGHT);
}


-(NSArray *)getNeighborsAt:(CGPoint)pt {
    NSMutableArray *neighbors = [NSMutableArray array];
    int x = pt.x;
    int y = pt.y;
    
    for (int i = 0; i < 9; i++) {
        int adjX = x+(i/3) - 1;
        int adjY = y+(i%3) - 1;
        
        // wrap around 
        if (adjX < 0) {
            adjX = (APGRID_WIDTH + adjX) % APGRID_WIDTH;
            
        }
        
        if (adjY < 0) {
            adjY = (APGRID_HEIGHT + adjY) % APGRID_HEIGHT;
            
        }
        
        if (adjX >= APGRID_WIDTH) {
            adjX = (APGRID_WIDTH - adjX) % APGRID_WIDTH;
        }
        
        if (adjY >= APGRID_HEIGHT) {
            adjY = (APGRID_HEIGHT - adjY) % APGRID_HEIGHT;
        }
        
        if (adjX == x && adjY == y) {
            continue;
        }
        
        CGPoint adjPoint = CGPointMake(adjX, adjY);
        NSValue *val = [NSValue valueWithCGPoint:adjPoint];
        [neighbors addObject:val];
    }
    
    return neighbors;
}

-(bool)isAliveNodeAtPos:(CGPoint) pt {
    return _map[(int)pt.x][(int)pt.y];
}

-(bool)shouldReviveNodeAt:(CGPoint)pt {
    
    int aliveCount = 0;
    
    for (NSValue *val in [self getNeighborsAt:pt]) {
        CGPoint pt = [val CGPointValue];
        if (_map[(int)pt.x][(int)pt.y]) {
            aliveCount++;
        }
    }
    
    if (aliveCount == 3) {
        return YES;
    }
    return NO;
}

-(void)removeAllNodes {
    memset(_map, 0, sizeof(bool) * APGRID_WIDTH * APGRID_HEIGHT);
    [self.nodes removeAllObjects];
}


@end