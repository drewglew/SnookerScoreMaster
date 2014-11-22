//
//  ViewController.h
//  SnookerScorer
//
//  Created by andrew glew on 05/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "player.h"
#import "AdjustPointsViewController.h"

@interface matchview : UIViewController <MFMailComposeViewControllerDelegate,UIAlertViewDelegate, AdjustPointsDelegate>  {
    int frameNumber;
}
@property (assign) int frameNumber;
@property (strong, nonatomic) NSMutableArray     *joinedFrameResult;
-(void)processCurrentUsersHighestBreak;
-(NSString*) composePlayerStats :(frame*) currentFrame;
-(void) processMatchEnd;
-(void)endOfFrame;
@end

