//
//  matchStatisticsVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 15/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "player.h"
#import "dbHelper.h"
#import "matchListingTVC.h"
#import "graphV.h"
#import "singlePlayerStatsV.h"

@class matchStatisticsTVC;

@protocol EmbededMatchStatisticsDelegate <NSObject>
@end

@interface embededMatchStatisticsV : UIViewController {}

@property (nonatomic, weak) id <EmbededMatchStatisticsDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *player1View;
@property (weak, nonatomic) IBOutlet UIView *player2View;
@property (weak, nonatomic) IBOutlet UILabel *player1Score;
@property (weak, nonatomic) IBOutlet UILabel *player2Score;
@property (weak, nonatomic) IBOutlet UIImageView *player1Photo;
@property (weak, nonatomic) IBOutlet UIImageView *player2Photo;
@property (weak, nonatomic) IBOutlet UILabel *player1Name;
@property (weak, nonatomic) IBOutlet UILabel *player2Name;
@property (weak, nonatomic) IBOutlet graphV *graphStatisticView;
@property (weak, nonatomic) IBOutlet UIStepper *stepperFrame;
@property (weak, nonatomic) IBOutlet UILabel *graphSummaryLabel;
@property (strong, nonatomic) player *p1;
@property (strong, nonatomic) player *p2;
@property (strong, nonatomic) match *m;
@property (strong, nonatomic) match *activeMatchPlayers;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) NSMutableArray *activeMatchData;
@property (strong, nonatomic) NSMutableArray *activeFrameData;
@property (weak, nonatomic) IBOutlet UIStepper *graphStepper;
@property (weak, nonatomic) IBOutlet UILabel *graphReferenceLabel;

@property (weak, nonatomic) IBOutlet UIButton *MorePlayer1Button;
@property (weak, nonatomic) IBOutlet UIButton *MorePlayer2Button;
@property (weak, nonatomic) IBOutlet singlePlayerStatsV *player1StatView;
@property (weak, nonatomic) IBOutlet singlePlayerStatsV *player2StatView;

@property (weak, nonatomic) IBOutlet UILabel *p1HiBreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1AvgBreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1RedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1YellowCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1GreenCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1BrownCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1BlueCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1PinkCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1BlackCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *p2HiBreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2AvgBreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2RedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2YellowCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2GreenCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2BrownCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2BlueCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2PinkCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2BlackCountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *p1HiBreakCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *p2HiBreakCollection;

@property (strong, nonatomic) NSMutableArray *p1BreakBalls;
@property (strong, nonatomic) NSMutableArray *p2BreakBalls;

@property (assign) bool updateP1Collection;

@property (weak, nonatomic) IBOutlet UIView *breakStatistcsView;




@end



