//
//  graphView.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 19/03/2015.
//  Copyright (c) 2015 andrew glew. All rights reserved.
//

#import "graphView.h"
#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation graphView
@synthesize frameData;
@synthesize scorePlayer1;
@synthesize scorePlayer2;
@synthesize currentBreakPlayer1;
@synthesize currentBreakPlayer2;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//CGRect touchAreas[100];


-(void) initFrameData {
if (!self.frameData) {
    self.frameData = [[NSMutableArray alloc] init];
}
}

-(void)addFrameData:(int)playerIndex :(int)points {
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setValue: [NSNumber numberWithInt:playerIndex] forKey:@"player"];
    [data setValue: [NSNumber numberWithInt:points] forKey:@"points"];
    
    [self.frameData addObject:data];
    
    if (playerIndex==1) {
        self.scorePlayer1+=points;
    } else {
        self.scorePlayer2+=points;
    }
}

-(void)resetFrameData {
    [self.frameData removeAllObjects];
    self.scorePlayer1=0;
    self.scorePlayer2=0;
}


-(void)plotPlayerLines:(bool)fillGraph :(CGContextRef)ctx :(int) playerIndex :(int) breakOfPlayer  :(UIColor*) playerColour :(float) scalePointsY :(float) scaleVisitsX {
    
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [playerColour CGColor]);
    CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    int score=0;
    int dataIndex = 0; // incremental index to plot
    
    float plotVisitsX=0.0f;
    float plotPointsY=0.0f + graphHeight;
    CGGradientRef gradient = NULL;
    CGColorSpaceRef colorspace;
    CGPoint startPoint, endPoint;
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] CGColor]);
    
    if (fillGraph) {

        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};
        colorspace = CGColorSpaceCreateDeviceRGB();
        
        if (playerColour == [UIColor orangeColor]) {
            CGFloat components[8] = {1.0, 0.5, 0.0, 0.31,  // Start color
                1.0, 0.5, 0.0, 0.9}; // End color
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        } else {
            
            CGFloat components[8] = {0.0, 1.0, 0.0, 0.1,  // Start color
                0.0, 1.0, 0.0, 0.9}; // End color
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        }
        startPoint.x = kOffsetX;
        startPoint.y = maxGraphHeight;
        endPoint.x = kOffsetX;
        endPoint.y = kOffsetY;
    }
    
    /* first part is to draw the lines of data actually logged */
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, plotVisitsX, plotPointsY);
    /* run through player 1 and player 2 shared data array picking out only selected players data */
    for (NSMutableArray *dataPoint in self.frameData) {
        dataIndex ++;
        NSNumber *scoreNbr=[dataPoint valueForKeyPath:@"player"];
        int pIndex = [scoreNbr intValue];
        
        if (pIndex == playerIndex) {
            
            NSNumber *pointsValue=[dataPoint valueForKeyPath:@"points"];
            score += [pointsValue intValue];
            
            float plotPoints = scalePointsY * score;
            plotVisitsX = kOffsetX + dataIndex * scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
            CGContextAddLineToPoint(ctx, plotVisitsX ,plotPointsY );
        }
        
    }
    if (fillGraph) {
        
        CGContextAddLineToPoint(ctx, plotVisitsX, maxGraphHeight);
        CGContextClosePath(ctx);
        CGContextSaveGState(ctx);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(ctx);
        CGColorSpaceRelease(colorspace);
        CGGradientRelease(gradient);
        
    } else {
        
        CGContextDrawPath(ctx, kCGPathStroke);
    
        /* last part of method is to check if selected player has a break that is current or not */
        if (breakOfPlayer > 0) {
            /* break exists, draw one dotted line entry to signify entry on graph */
            CGContextSetLineWidth(ctx, 2.0);
            CGContextMoveToPoint(ctx, plotVisitsX, plotPointsY);
            /* turn dash on! */
            CGFloat dash[] = {2.0, 2.0};
            CGContextSetLineDash(ctx, 0.0, dash, 2);
        
            dataIndex ++;
            score += breakOfPlayer;
        
            float plotPoints = scalePointsY * score;
            plotVisitsX = kOffsetX + dataIndex * scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
        
            CGContextAddLineToPoint(ctx, plotVisitsX ,plotPointsY );
            CGContextDrawPath(ctx, kCGPathStroke);
            /* remove dash */
            CGContextSetLineDash(ctx, 0, NULL, 0);
        }
    }
}






-(void)plotPlayerMarkers:(CGContextRef)ctx :(int) playerIndex  :(UIColor*) playerColour :(float) scalePointsY :(float) scaleVisitsX {
    
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [playerColour CGColor]);
    CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    float plotVisitsX=0.0f;     // maintains X position of line
    float plotPointsY=0.0f;     // maintains Y position of line
    int score=0; // variable used to store visit point value.
    int dataIndex = 0;
    for (NSMutableArray *dataPoint in self.frameData) {
        dataIndex ++;
        NSNumber *pointsValue=[dataPoint valueForKeyPath:@"player"];
        int pIndex = [pointsValue intValue];
    
        if (pIndex == playerIndex) {
        
            NSNumber *pointsValue=[dataPoint valueForKeyPath:@"points"];
            score += [pointsValue intValue];
        
            float plotPoints = scalePointsY * score;
        
            plotVisitsX = kOffsetX + dataIndex * scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
        
            CGRect rect = CGRectMake(plotVisitsX - kCircleRadius, plotPointsY - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            //if (dataIndex<100) {
            //    touchAreas[dataIndex] = rect;
            //}
            CGContextAddEllipseInRect(ctx, rect);
        }
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"Touch x:%f, y:%f", point.x, point.y);
    for (int i = 0; i < 100; i++)
    {
        if (CGRectContainsPoint(touchAreas[i], point))
        {
            NSLog(@"Tapped a bar with index %d, value", i);
            break;
        }
    }
}*/

- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    /* assist with scale of graph - height */
    int maxScore;
    if (self.scorePlayer1+self.currentBreakPlayer1 > self.scorePlayer2+self.currentBreakPlayer2) {
        maxScore = self.scorePlayer1+1+self.currentBreakPlayer1;
    } else {
        maxScore = self.scorePlayer2+1+self.currentBreakPlayer2;
    }
    float scalePoints = 1.0f/maxScore;
    /* assist with scale of graph - width */
    NSUInteger frameDataEntries = self.frameData.count;
    if (self.currentBreakPlayer1 + self.currentBreakPlayer2 > 0) {
        frameDataEntries ++;
    }
    float scaleVisits = ((int)self.frame.size.width - 5) / frameDataEntries;
    /* Player 1 plotting */
    [self plotPlayerLines:false :ctx :1 :self.currentBreakPlayer1 :[UIColor greenColor] :scalePoints :scaleVisits];
    [self plotPlayerLines:true :ctx :1 :self.currentBreakPlayer1 :[UIColor greenColor] :scalePoints :scaleVisits];
    [self plotPlayerMarkers:ctx :1 :[UIColor greenColor] :scalePoints :scaleVisits];
    /* Player 2 plotting */
    [self plotPlayerLines:false :ctx :2 :self.currentBreakPlayer2 :[UIColor orangeColor] :scalePoints :scaleVisits];
    [self plotPlayerLines:true :ctx :2 :self.currentBreakPlayer2 :[UIColor orangeColor] :scalePoints :scaleVisits];
    
    [self plotPlayerMarkers:ctx :2 :[UIColor orangeColor] :scalePoints :scaleVisits];
}


//TODO scale the amount of lines drawn with the dynamic resized graph

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
 
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    int graphBottom = self.frame.size.height;
    
    // How many lines?
    int howMany = (self.frame.size.width - kOffsetX) + 11 / kStepX;
    
    // Here the lines go
    for (int i = 0; i < howMany; i++)
    {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, graphBottom);
    }
    
    int howManyHorizontal = (graphBottom - kGraphTop - kOffsetY) / kStepY;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, graphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, self.frame.size.width, graphBottom - kOffsetY - i * kStepY);
    }
    
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
    [self drawLineGraphWithContext:context];

    
    
}



@end
