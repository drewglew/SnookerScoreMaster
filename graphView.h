//
//  graphView.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 19/03/2015.
//  Copyright (c) 2015 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface graphView : UIView {
    NSMutableArray *frameData;
}
@property (strong, nonatomic) NSMutableArray *frameData;
@property (assign) int scorePlayer1;
@property (assign) int scorePlayer2;
@property (assign) int currentBreakPlayer1;
@property (assign) int currentBreakPlayer2;


- (void)drawRect:(CGRect)rect;
- (void) initFrameData;
-(void) resetFrameData;
-(void)addFrameData:(int)playerIndex :(int)points;
#define kGraphHeight 275
#define kDefaultGraphWidth 275
#define kOffsetX 0
#define kStepX 50
#define kGraphBottom 275
#define kGraphTop 0
#define kStepY 50
#define kOffsetY 0
#define kCircleRadius 2


@end
