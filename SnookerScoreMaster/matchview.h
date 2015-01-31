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
#import "statsViewController.h"

@interface matchview : UIViewController <MFMailComposeViewControllerDelegate,UIAlertViewDelegate, UIGestureRecognizerDelegate, AdjustPointsDelegate>  {
    int frameNumber;
    int currentColour;
    bool ballReplaced;
    int colourStateAtStartOfBreak;
    int colourQuantityAtStartOfBreak;
    statsViewController *statsVC;
    
}
@property (assign) int frameNumber;
@property (assign) int currentColour;
@property (assign) bool ballReplaced;
@property (assign) int colourStateAtStartOfBreak;
@property (assign) int colourQuantityAtStartOfBreak;

@property (strong, nonatomic) NSMutableArray     *joinedFrameResult;
/* https://www.youtube.com/watch?v=mdG6XpwwuwI */
-(void)processCurrentUsersHighestBreak;
-(NSString*) composePlayerStats :(frame*) currentFrame;
-(void) processMatchEnd;
-(void)endOfFrame;
-(void)endMatch;
@end

