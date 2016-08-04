#import "APNodeMap.h"

@interface APNodeMap () {
    NSString *_map[APGRID_WIDTH][APGRID_HEIGHT];
}

@end

@implementation APNodeMap

-(id) init {
    [self setNodes:[NSMutableDictionary dictionary]];
    return [super init];
}

-(void)spawn {
    for (int i = 0; i < APGRID_WIDTH; i++) {
        for (int j = 0; j < APGRID_HEIGHT; j++) {
            _map[i][j] = @"d";
        }
    }
}

-(void)spawnRandom {
    for (int i = 0; i < APGRID_WIDTH; i++) {
        for (int j = 0; j < APGRID_HEIGHT; j++) {
            if (arc4random_uniform(2) == 0) {
                [self insertNodeAtPos:CGPointMake(i, j)];
            } else {
                _map[i][j] = [NSString stringWithFormat:@"d%i%i", i, j];
            }
        }
    }
}

-(APNode *)insertNodeAtPos:(CGPoint)pt {
    if ([self isAliveNodeAtPos:pt] || pt.x >= APGRID_WIDTH || pt.y >= APGRID_HEIGHT) {
        return nil;
    }
    APNode *node = [[APNode alloc] init];
    return [self insertNode:node atPos:pt];
}

-(APNode *)insertNode:(APNode *)node atPos:(CGPoint)pt {
    [node setPosition:pt];
    _map[(int)pt.x][(int)pt.y] = [node description];
    [self.nodes setObject:node forKey:[node description]];
    
    return node;
}

-(void)evolve {
    [self evolve:1];
    [self evolve:2];
    [self evolve:3];
    [self evolve:4];
}

-(void)evolve:(int)phase {
    NSString *evolvedMap[APGRID_WIDTH][APGRID_HEIGHT];
    [self overwriteMap:evolvedMap withMap:_map];
    NSMutableDictionary *newNodes = [NSMutableDictionary dictionary];
    
    for (APNode *currentNode in [self.nodes allValues]) {
        int aliveCount = 0;
        for (NSDictionary *neighborTuple in [self getNeighborsAt:currentNode.position]) {
            if ([[neighborTuple objectForKey:@"alive"] boolValue]) {
                aliveCount++;
            } else if (phase == 4){
                APNode *newNode = [self reviveTupleToLiveNode:neighborTuple];
                if (newNode) {
                    [newNodes setObject:newNode forKey:[newNode description]];
                    evolvedMap[(int)newNode.position.x][(int)newNode.position.y] = [newNode description];
                }
            }
            
        }
        
        if ((phase == 1 && aliveCount < 2) || (phase == 3 && aliveCount > 3)) {
            currentNode.alive = NO;
            [self.nodes removeObjectForKey:[currentNode description]];
        }
        
    }
    
    [self.nodes addEntriesFromDictionary:newNodes];
    [self overwriteMap:_map withMap:evolvedMap];
}

-(void)overwriteMap:(__strong NSString *[APGRID_WIDTH][APGRID_HEIGHT])map
            withMap:(__strong NSString *[APGRID_WIDTH][APGRID_HEIGHT])newMap {
    for (int i = 0; i < APGRID_WIDTH; i++) {
        for (int j = 0; j < APGRID_HEIGHT; j++) {
            map[i][j] = newMap[i][j];
        }
    }
}


//TODO: replace tuple with APNode object
-(NSArray *)getNeighborsAt:(CGPoint)pt {
    NSMutableArray *neighborIds = [NSMutableArray array];
    int x = pt.x;
    int y = pt.y;
    NSString *identifier = _map[x][y];
    if (!identifier) {
        return neighborIds;
    }
    
    for (int i = 0; i < 9; i++) {
        int adjX = x+(i/3) - 1;
        int adjY = y+(i%3) - 1;
        if (adjX < 0 || adjY < 0 || adjX >= APGRID_WIDTH || adjY >= APGRID_HEIGHT) {
            continue;
        }
        NSString *adjIdentifier = _map[adjX][adjY];
        if (adjIdentifier && adjIdentifier != identifier) {
            CGPoint adjPoint = CGPointMake(adjX, adjY);
            [neighborIds addObject:@{@"id": adjIdentifier,
                                     @"x":@(adjX),
                                     @"y":@(adjY),
                                     @"alive":@([self isAliveNodeAtPos:adjPoint])}];
        }
    }
    return neighborIds;
}

-(bool)isAliveNodeAtPos:(CGPoint) pt {
    return _map[(int)pt.x][(int)pt.y] && [self.nodes objectForKey:_map[(int)pt.x][(int)pt.y]];
}

-(APNode *)reviveTupleToLiveNode:(NSDictionary *)nodeTuple {
    
    int aliveCount = 0;
    CGPoint pt =CGPointMake([[nodeTuple objectForKey:@"x"] intValue],
                            [[nodeTuple objectForKey:@"y"] intValue]);
    
    for (NSDictionary *neighborTuple in [self getNeighborsAt:pt]) {
        if ([[neighborTuple objectForKey:@"alive"] boolValue]) {
            aliveCount++;
        }
    }
    if (aliveCount == 3) {
        APNode *revivedNode = [[APNode alloc] init];
        revivedNode.position = pt;
        return revivedNode;
    }
    return nil;
}


@end