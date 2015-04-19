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
@synthesize visitBallCollection;
@synthesize visitPlayerIndex;
@synthesize visitIsFoul;
@synthesize scorePlayer1;
@synthesize scorePlayer2;
@synthesize currentBreakPlayer1;
@synthesize currentBreakPlayer2;
@synthesize visitNumberOfBalls;
@synthesize timeStamp;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

CGRect touchAreas[100];


-(void) initFrameData {
if (!self.frameData) {
    self.frameData = [[NSMutableArray alloc] init];
}
}

-(void)addFrameData:(int)frameIndex :(int)playerIndex :(int)points :(int)isfoul :(NSMutableArray*) breakTransaction {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *rightNow = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];

    [data setValue: rightNow forKey:@"datestamp"];
    [data setValue: [NSNumber numberWithInt:frameIndex] forKey:@"frameindex"];
    [data setValue: [NSNumber numberWithInt:playerIndex] forKey:@"player"];
    [data setValue: [NSNumber numberWithInt:points] forKey:@"points"];
    [data setValue: [NSNumber numberWithInt:isfoul] forKey:@"isfoul"];
    [data setValue: [NSMutableArray arrayWithArray:breakTransaction] forKey:@"ballTransaction"];
    [self.frameData addObject:data];
    
    if (playerIndex==1) {
        self.scorePlayer1+=points;
    } else {
        self.scorePlayer2+=points;
    }
}


-(int)getHighestBreakAmountInFrame:(NSMutableArray*) singleFrameData  :(int)playerIndex :(int)frameIndex {
    
    int highestBreak=0;
    for (NSMutableArray *dataPoint in singleFrameData) {
        
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        NSNumber *wantedFrame = [dataPoint valueForKeyPath:@"frameindex"];
        
        if (playerIndex == [wantedPlayer intValue] && [wantedType intValue] == 0 && (frameIndex == [wantedFrame intValue] || frameIndex == 0)) {
            
            NSMutableDictionary *ballCollection = [[NSMutableDictionary alloc] init];
            ballCollection = [dataPoint valueForKey:@"ballTransaction"];
            int totalBreak = 0;
            for (ball *ball in ballCollection) {
                totalBreak+=ball.pottedPoints;
            }
            if (totalBreak > highestBreak) {
                highestBreak = totalBreak;
            }
        }
    }
    return highestBreak;
}


-(int)getAmountOfBallsPottedInFrame:(NSMutableArray*) singleFrameData  :(int)playerIndex :(int)frameIndex {
    
    int totalBalls=0;
    for (NSMutableArray *dataPoint in singleFrameData) {
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        NSNumber *wantedFrame = [dataPoint valueForKeyPath:@"frameindex"];
        if (playerIndex == [wantedPlayer intValue] && [wantedType intValue] == 0 && (frameIndex == [wantedFrame intValue] || frameIndex == 0 )) {
            NSMutableDictionary *ballCollection = [[NSMutableDictionary alloc] init];
            ballCollection = [dataPoint valueForKey:@"ballTransaction"];
            totalBalls += ballCollection.count;
        }
    }
    return totalBalls;
}

-(int)getAmountOfVisitsInFrame:(NSMutableArray*) singleFrameData  :(int)playerIndex {
    
    int totalVisits=0;
    for (NSMutableArray *dataPoint in singleFrameData) {
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        if (playerIndex == [wantedPlayer intValue] && [wantedType intValue] == 0) {
            totalVisits ++;
        }
    }
    return totalVisits;
}

-(NSMutableDictionary *)getHighestBreakBallsInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex :(int)frameIndex {
    // This method returns a dictionary of the balls that were potted in the highest break
    // within the frame.
    int highestBreak=0;
    int ballsInBreak=0;
    NSMutableDictionary *balls;
    
    for (NSMutableArray *dataPoint in singleFrameData) {
        
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        NSNumber *wantedFrame = [dataPoint valueForKeyPath:@"frameindex"];
        
        if (playerIndex == [wantedPlayer intValue] && [wantedType intValue] == 0  && (frameIndex == [wantedFrame intValue] || frameIndex == 0)) {
            
            NSMutableDictionary *ballCollection = [[NSMutableDictionary alloc] init];
            ballCollection = [dataPoint valueForKey:@"ballTransaction"];
            int totalBreak = 0;
            for (ball *ball in ballCollection) {
                totalBreak+=ball.pottedPoints;
            }
            if (totalBreak > highestBreak) {
                // update highest break!
                highestBreak = totalBreak;
                balls = ballCollection;
                ballsInBreak = (int)balls.count;
            } else if (totalBreak == highestBreak && ballsInBreak > (int)ballCollection.count) {
                // save the combination that has the most pots in it.
                balls = ballCollection;
                ballsInBreak = (int)balls.count;
            }
        }
        
    }
    return balls;
}




-(int)getPointsInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex {
    // get the players total accumunated points in frame
    return [self getPointsByTypeInFrame:(NSMutableArray*) singleFrameData :playerIndex :0 :0] + [self getPointsByTypeInFrame :(NSMutableArray*) singleFrameData :playerIndex :1 :0];
}

-(int)getPointsInASingleFrame:(NSMutableArray*) singleFrameData :(int)playerIndex :(int)frameIndex {
    return [self getPointsByTypeInFrame:(NSMutableArray*) singleFrameData :playerIndex :0 :frameIndex] + [self getPointsByTypeInFrame :(NSMutableArray*) singleFrameData :playerIndex :1 :frameIndex];
    
}

-(int)getPointsByTypeInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex :(int)isfoul :(int)frameIndex {
    // This method is used to obtain either the potted points a player has made or the foul points a
    // player has received.
    
    int retValue=0;
    for (NSMutableArray *dataPoint in singleFrameData) {
        
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        NSNumber *wantedFrame = [dataPoint valueForKeyPath:@"frameindex"];
        
        if (playerIndex == [wantedPlayer intValue] && isfoul == [wantedType intValue] && (frameIndex == [wantedFrame intValue] || frameIndex == 0)) {
            
            NSMutableDictionary *ballCollection = [[NSMutableDictionary alloc] init];
            ballCollection = [dataPoint valueForKey:@"ballTransaction"];
            
            // this can be replaced by getBreakAmountFromBalls()
            for (ball *ball in ballCollection) {
                if (isfoul ==0) {
                    retValue+=ball.pottedPoints;
                } else {
                    retValue+=ball.foulPoints;
                }
            }
            
        }
        
    }
    return retValue;
}


-(float)getAverageBreakAmountInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex {
    int totalPottedPoints = 0;
    int totalVisits = 0;
    
    totalPottedPoints = [self getPointsByTypeInFrame:singleFrameData :playerIndex :0 :0];
    
    totalVisits = [self getAmountOfVisitsInFrame:singleFrameData :playerIndex];
    
    float avgAmount = 0.0;
    
    avgAmount = (float)totalPottedPoints / (float)totalVisits;
    
    if isnan(avgAmount) {
        avgAmount=0.0;
    }
    
    return avgAmount;
}


-(int)getBreakAmountFromBalls:(NSMutableArray*)balls :(NSNumber *)isfoul {
    int breakAmount = 0;
    
    for (ball *ball in balls) {
        if ([isfoul intValue] == 0) {
            breakAmount+=ball.pottedPoints;
        } else {
            breakAmount+=ball.foulPoints;
        }
    }
    return breakAmount;
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
        
        if (playerColour == [UIColor redColor]) {
            CGFloat components[8] = {1.0, 0.0, 0.0, 0.1,  // Start color
                1.0, 0.0, 0.0, 0.5}; // End color
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
    
    CGContextSetLineWidth(ctx, 4.0);
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
        
            NSLog(@"%@",[dataPoint valueForKey:@"ballTransaction"]);
            
            NSNumber *pointsValue=[dataPoint valueForKeyPath:@"points"];
            score += [pointsValue intValue];
        
            float plotPoints = scalePointsY * score;
        
            plotVisitsX = kOffsetX + dataIndex * scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
        
            CGRect rect = CGRectMake(plotVisitsX - kCircleRadius, plotPointsY - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            
            if (dataIndex<100) {
                touchAreas[dataIndex] = rect;
            }
            CGContextAddEllipseInRect(ctx, rect);
        }
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //NSLog(@"Touch x:%f, y:%f", point.x, point.y);
    for (int i = 0; i < 100; i++)
    {
        if (CGRectContainsPoint(touchAreas[i], point))
        {
            // example.  need to obtain items ball count..
            NSMutableArray *data = [self.frameData objectAtIndex:i-1];
            
            self.visitBallCollection = [data valueForKey:@"ballTransaction"];
            self.visitPlayerIndex = (int)[data valueForKey:@"player"];
            self.visitIsFoul = [data valueForKey:@"isfoul"];
            self.timeStamp = [data valueForKey:@"datestamp"];
            
            self.visitNumberOfBalls=(int)self.visitBallCollection.count;
            
            [self.delegate reloadGrid];
            
            
            self.visitBreakDown.hidden = false;
            
            
        
            NSLog(@"Tapped a bar with index %d, value", i);
            break;
        }
    }
}

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
    [self plotPlayerLines:false :ctx :2 :self.currentBreakPlayer2 :[UIColor redColor] :scalePoints :scaleVisits];
    [self plotPlayerLines:true :ctx :2 :self.currentBreakPlayer2 :[UIColor redColor] :scalePoints :scaleVisits];
    
    [self plotPlayerMarkers:ctx :2 :[UIColor redColor] :scalePoints :scaleVisits];
}


//TODO scale the amount of lines drawn with the dynamic resized graph

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
 
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    int graphBottom = self.frame.size.height;
    
    NSUInteger frameDataEntries = self.frameData.count;
    if (self.currentBreakPlayer1 + self.currentBreakPlayer2 > 0) {
        frameDataEntries ++;
    }

    
    float scaleVisits = ((int)self.frame.size.width - 5) / frameDataEntries;
    if (scaleVisits==0) {
        scaleVisits=50;
    }

    
    // How many lines?
    int howMany = (self.frame.size.width - kOffsetX) + 11 / scaleVisits;
    
    // Here the lines go
    for (int i = 0; i < howMany; i++)
    {
        CGContextMoveToPoint(context, kOffsetX + i * scaleVisits, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * scaleVisits, graphBottom);
    }
    
    int howManyHorizontal = (graphBottom - kGraphTop - kOffsetY) / scaleVisits;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, graphBottom - kOffsetY - i * scaleVisits);
        CGContextAddLineToPoint(context, self.frame.size.width, graphBottom - kOffsetY - i * scaleVisits);
    }
    
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
    [self drawLineGraphWithContext:context];

    
    
}







@end
