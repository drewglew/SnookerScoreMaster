//
//  matchStatistics.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 16/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "matchStatisticsVC.h"



@interface matchStatisticsVC () <EmbededMatchStatisticsDelegate>

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
    
    if([segue.identifier isEqualToString:@"matchliststatistics"]) {
        embededMatchStatisticsV *controller = (embededMatchStatisticsV *)segue.destinationViewController;
        controller.delegate = self;
        
        controller.p1 = self.p1;
        controller.p2 = self.p2;
        controller.m = self.m;
        controller.activeMatchPlayers = self.activeMatchPlayers;
    }
    
    
}

@end
