//
//  GameScene.m
//  antipattern
//
//  Created by Alexandru Catighera on 8/2/16.
//  Copyright (c) 2016 Alexandru Catighera. All rights reserved.
//

#import "GameScene.h"
#import "APNodeMap.h"

@interface GameScene ()

@property(nonatomic, assign) uint8_t cellSize;
@property(nonatomic, strong) APNodeMap *map;
@property(nonatomic, strong) SKShapeNode *grid;

@end

@implementation GameScene

-(void)start {
    [self run];
}

-(void)run {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.map evolve];
            [self clear];
            [self drawMap];
            [self run];
    });
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self setBackgroundColor:[UIColor blackColor]];
    [self createGridWithCellSize:5];
    self.size = view.bounds.size;
    self.map = [[APNodeMap alloc] init];
}

-(void)createGridWithCellSize:(uint8_t)cellSize {
    uint8_t strokeSize = 1;
    self.cellSize = cellSize + strokeSize;
    CGFloat screenScale = 1;
    CGFloat height = self.view.bounds.size.height * screenScale;
    CGFloat width= self.view.bounds.size.width * screenScale;
    uint8_t rows = height / self.cellSize;
    uint8_t cols = width / self.cellSize;
    
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 0; i <= rows; i++) {
        CGPathMoveToPoint(path, NULL, 0.0, self.cellSize * i);
        CGPathAddLineToPoint(path, NULL, width, self.cellSize * i);
    }
    
    for (int i = 0; i <= cols; i++) {
        CGPathMoveToPoint(path, NULL, self.cellSize * i, 0.0);
        CGPathAddLineToPoint(path, NULL, self.cellSize * i, height);
    }
    
    self.grid = [SKShapeNode node];
    self.grid.path = path;
    [self.grid setStrokeColor:[SKColor colorWithRed:1.0f green:0.3f blue:0.3f alpha:0.6f]];
    [self addChild:self.grid];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    CGPoint scaledPt =
        CGPointMake((int)(pt.x - self.cellSize / 2) / self.cellSize,
                    (int)((self.view.bounds.size.height - pt.y) / self.cellSize));
    
    if ([self.map insertNodeAtPos:scaledPt]) {
        [self drawMap];
    }
}

-(void)clear {
    [self removeAllChildren];
    [self addChild:self.grid];
}

-(void)drawMap {
    for (NSValue *val in [[self.map nodes] allValues]) {
        CGPoint pt = [val CGPointValue];
        float scaledX = (pt.x * self.cellSize) + self.cellSize / 2;
        float scaledY = (pt.y * self.cellSize) + self.cellSize / 2;
        [self drawNodeAt:CGPointMake(scaledX, scaledY)];
    }
}

-(void)drawNodeAt:(CGPoint)pt {
    SKShapeNode *circle = [SKShapeNode shapeNodeWithCircleOfRadius:self.cellSize / 3];
    circle.position = pt;
    circle.strokeColor = [SKColor blueColor];
    circle.fillColor =[SKColor greenColor];
    [self addChild:circle];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
