//
//  graph.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 16/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "breakEntry.h"
#import "player.h"

@interface graphV : UIView

@property (strong, nonatomic) NSMutableArray *matchFramePoints;
@property (assign) int matchMaxPoints;
@property (assign) int numberOfFrames;
@property (strong, nonatomic) NSMutableArray *selectedData;
@property (strong, nonatomic) NSMutableArray *frameData;
@property (assign) bool matchStatistics;
@property (assign) int graphReferenceId;
@property (assign) int scorePlayer1;
@property (assign) int scorePlayer2;
@property (assign) int currentBreakPlayer1;
@property (assign) int currentBreakPlayer2;
@property (strong, nonatomic) player *p1;
@property (strong, nonatomic) player *p2;

#define kGraphHeight 275
#define kDefaultGraphWidth 275
#define kOffsetX 0
#define kStepX 50
#define kGraphBottom 275
#define kGraphTop 0
#define kStepY 50
#define kOffsetY 0
#define kCircleRadius 4.5
#define kSmallCircleRadius 2.0

-(void) loadSharedData;

@end
