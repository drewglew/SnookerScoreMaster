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
#import "graphView.h"
//#import "CorePlot-CocoaTouch.h"

@interface matchview : UIViewController <MFMailComposeViewControllerDelegate,UIAlertViewDelegate, UIGestureRecognizerDelegate, AdjustPointsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>  {
    int frameNumber;
    int currentColour;
    bool ballReplaced;
    bool advancedCounting;
    int colourStateAtStartOfBreak;
    int colourQuantityAtStartOfBreak;
    statsViewController *statsVC;
    UIImagePickerController *imgPicker;
}
@property (assign) int frameNumber;
@property (assign) int currentColour;
@property (assign) bool ballReplaced;
@property (assign) bool advancedCounting;
@property (assign) int colourStateAtStartOfBreak;
@property (assign) int colourQuantityAtStartOfBreak;
;
@property (weak, nonatomic) IBOutlet graphView *frameGraphView;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (strong, nonatomic) NSMutableArray     *joinedFrameResult;
/* https://www.youtube.com/watch?v=mdG6XpwwuwI */
-(void) processCurrentUsersHighestBreak;
-(NSString*) composePlayerStats :(frame*) currentFrame;
-(void) processMatchEnd;
-(void) endOfFrame;
-(void) endMatch;

@end

