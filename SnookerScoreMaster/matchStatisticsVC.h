//
//  matchStatistics.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 16/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "player.h"
#import "embededMatchStatisticsV.h"
#import "matchListingTVC.h"
#import "match.h"

@class matchStatistics;

@protocol MatchStatisticsDelegate <NSObject>
@end

@interface matchStatisticsVC : UIViewController {}
@property (nonatomic, weak) id <MatchStatisticsDelegate> delegate;
@property (strong, nonatomic) player *p1;
@property (strong, nonatomic) player *p2;
@property (strong, nonatomic) match *m;
@property (strong, nonatomic) match *activeMatchPlayers;
@property (strong, nonatomic) NSMutableArray *activeMatchData;
@property (strong, nonatomic) NSMutableArray *activeFrameData;
@end

