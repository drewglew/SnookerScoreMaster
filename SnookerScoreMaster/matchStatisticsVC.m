//
//  matchStatistics.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 16/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "matchStatisticsVC.h"



@interface matchStatisticsVC () <EmbededMatchStatisticsDelegate, graphViewDelegate>

@end

@implementation matchStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"matchliststatistics"] || [segue.identifier isEqualToString:@"activeMatchStatistics"]) {
        embededMatchStatisticsVC *controller = (embededMatchStatisticsVC *)segue.destinationViewController;
        controller.delegate = self;
        
        controller.p1 = self.p1;
        controller.p2 = self.p2;
        controller.m = self.m;
        controller.activeMatchPlayers = self.activeMatchPlayers;
        controller.activeMatchStatistcsShown = self.activeMatchStatistcsShown;
        controller.displayState = self.displayState;
        controller.db = self.db;
        controller.skinPrefix = self.skinPrefix;
        controller.activeFramePointsRemaining = self.activeFramePointsRemaining;
        controller.isHollow = self.isHollow;
        controller.theme = self.theme;
    } }

- (void)addItemViewController:(embededMatchStatisticsVC *)controller keepDisplayState:(int)displayState {
    self.displayState = displayState;
    [self.delegate addItemViewController:self keepDisplayState:self.displayState];
}

-(bool) loadBreakShots:(int) breakShotsIndex :(BOOL) fromGraph {
    return true;
}

@end
