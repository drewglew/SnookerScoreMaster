//
//  graphView.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 19/03/2015.
//  Copyright (c) 2015 andrew glew. All rights reserved.
//
@protocol graphViewDelegate
-(void)reloadGrid;
@end

#import <UIKit/UIKit.h>
#import "ball.h"
#import "matchview.h"


@interface graphView : UIView {
    NSMutableArray *frameData;
    NSMutableArray *selectedFrameData;
}
@property (assign) id <graphViewDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *frameData;
@property (strong, nonatomic) NSMutableArray *selectedFrameData;
@property (assign) int scorePlayer1;
@property (assign) NSUInteger visitNumberOfBalls;
@property (assign) int scorePlayer2;
@property (assign) int currentBreakPlayer1;
@property (assign) int currentBreakPlayer2;
@property (assign) int visitId;
@property (weak, nonatomic) UIView *visitBreakDown;
@property (strong, nonatomic) NSMutableArray *visitBallCollection;
@property (assign) NSNumber *visitPlayerIndex;
@property (assign) NSNumber *visitIsFoul;
@property (assign) NSNumber *visitPoints;
@property (nonatomic) NSString *visitRef;
@property (nonatomic) NSString *timeStamp;

@property (weak, nonatomic) UICollectionView *visitBallGrid;


- (void)drawRect:(CGRect)rect;
- (void) initFrameData;
-(void) resetFrameData;
-(void)addFrameData:(int)frameIndex :(int)playerIndex :(int)points :(int)isfoul :(NSMutableArray*) breakTransaction :(int)matchTxId;
-(int)getPointsInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex;
-(int)getBreakAmountFromBalls:(NSMutableArray*)balls :(NSNumber *)isfoul;
-(int)getAmountOfVisitsInFrame:(NSMutableArray*) singleFrameData  :(int)playerIndex;
-(float)getAverageBreakAmountInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex;
-(int)getPointsByTypeInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex :(int)isfoul :(int)frameIndex;
-(int)getPointsInASingleFrame:(NSMutableArray*) singleFrameData :(int)playerIndex :(int)frameIndex;
-(int)getHighestBreakAmountInFrame:(NSMutableArray*) singleFrameData  :(int)playerIndex :(int)frameIndex;
-(NSMutableDictionary *)getHighestBreakBallsInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex :(int)frameIndex;
-(int)getAmountOfBallsPottedInFrame:(NSMutableArray*) singleFrameData  :(int)playerIndex :(int)frameIndex;
-(void) loadVisitWindow:(int) visitIndex :(BOOL) fromGraph;
-(NSString*) createResultsContent :(NSMutableArray*) singleFrameData :(NSString*) playerName1 :(NSString*) playerName2;
-(NSMutableArray*) getSelectedFrameData :(NSMutableArray*) singleFrameData :(int)frameIndex;


#define kGraphHeight 275
#define kDefaultGraphWidth 275
#define kOffsetX 0
#define kStepX 50
#define kGraphBottom 275
#define kGraphTop 0
#define kStepY 50
#define kOffsetY 0
#define kCircleRadius 7.5


@end
