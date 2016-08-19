#import "GameScene.h"
#import "Patterns.h"
#import "APNodeMap.h"
#import "APSpawner.h"

@interface GameScene ()

@property(atomic, strong) APNodeMap *map;
@property(atomic, strong) APSpawner *spawner;
@property(nonatomic, assign) float cellSize;
@property(nonatomic, strong) SKShapeNode *grid;
@property(nonatomic, strong) SKEffectNode *canvas;
@property(nonatomic, strong) dispatch_queue_t nodeQueue;

@end

@implementation GameScene

-(void)start {
    [self run];
    self.isRunning = YES;
}

-(void)stop {
    self.isRunning = NO;
}

-(void)run {
    __weak GameScene *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), self.nodeQueue, ^{
            if ([weakSelf isRunning]) {
                [weakSelf.map evolve];
                [weakSelf run];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf clearCanvas];
                    [weakSelf drawMap];
                });
            }
    });
}

-(void)didMoveToView:(SKView *)view {
    self.nodeQueue     = dispatch_queue_create("com.boba.NodeQueue", NULL);
    self.map           = [[APNodeMap alloc] init];
    self.spawner       = [[APSpawner alloc] init];
    uint8_t strokeSize = 0;
    self.size          = view.bounds.size;
    self.cellSize      = strokeSize + (float)(self.size.width / APGRID_WIDTH);
    
    [self setBackgroundColor:[UIColor blackColor]];
    [self.spawner spawnRandomOnMap:self.map];
    [self createGrid];
}

-(void)createGrid {
    CGFloat height = APGRID_HEIGHT * self.cellSize;
    CGFloat width  = APGRID_WIDTH * self.cellSize;
    uint8_t rows   = APGRID_HEIGHT;
    uint8_t cols   = APGRID_WIDTH;
    
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 0; i <= rows; i++) {
        CGPathMoveToPoint(path, NULL, 0.0, self.cellSize * i);
        CGPathAddLineToPoint(path, NULL, width, self.cellSize * i);
    }
    
    for (int i = 0; i <= cols; i++) {
        CGPathMoveToPoint(path, NULL, self.cellSize * i, 0.0);
        CGPathAddLineToPoint(path, NULL, self.cellSize * i, height);
    }
    
    
    self.canvas = [SKEffectNode node];
    self.canvas.shouldRasterize = YES;
    [self addChild:self.canvas];
    
    self.grid = [SKShapeNode node];
    self.grid.path = path;
    [self.grid setStrokeColor:[SKColor colorWithRed:1.0f green:0.3f blue:0.3f alpha:0.6f]];
    [self.canvas addChild:self.grid];
    
    [self drawMap];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch         = [touches anyObject];
    CGPoint pt             = [touch locationInView:self.view];
    CGPoint positionInGrid =
        CGPointMake((int)((pt.x - self.cellSize / 2) / self.cellSize),
                    (int)((self.view.bounds.size.height - pt.y) / self.cellSize));
    
    if (self.patternToPlace) {
        [self spawnPatternOnMap:self.patternToPlace atLoc:positionInGrid];
        self.patternToPlace = nil;
        [self drawMap];
    } else if ([self.map insertNodeAtPos:positionInGrid]) {
        [self drawNodeAt:[self scalePoint:positionInGrid]];
    }
}

-(void)clearCanvas {
    [self.canvas removeAllChildren];
    [self.canvas addChild:self.grid];
}

-(void)clearCanvasAndData {
    [self clearCanvas];
    [self.map removeAllNodes];
}

-(void)drawMap {
    for (NSValue *val in [[self.map nodes] allValues]) {
        CGPoint pt = [val CGPointValue];
        [self drawNodeAt:[self scalePoint:pt]];
    }
}

-(void)spawnRandomNodesOnMap {
    [self clearCanvasAndData];
    [self.spawner spawnRandomOnMap:self.map];
    [self drawMap];
}

-(void)spawnPatternOnMap:(NSString *) patternName atLoc:(CGPoint)locPt {
    [self.spawner spawnPattern:patternName atPoint:locPt onMap:self.map];
    [self drawMap];
}

-(void)drawNodeAt:(CGPoint)pt {
    SKShapeNode *circle = [SKShapeNode shapeNodeWithCircleOfRadius:self.cellSize / 2.8];
    circle.position = pt;
    circle.strokeColor = [SKColor blueColor];
    circle.fillColor =[SKColor greenColor];
    [self.canvas addChild:circle];
}

-(CGPoint) scalePoint:(CGPoint) pt {
    float scaledX = (pt.x * self.cellSize) + self.cellSize / 2.0f;
    float scaledY = (pt.y * self.cellSize) + self.cellSize / 2.0f;
    return CGPointMake(scaledX, scaledY);
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered (currently noop) */
}

@end
