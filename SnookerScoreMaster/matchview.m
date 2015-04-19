//
//  ViewController.m
//  SnookerScorer
//
//  Created by andrew glew on 05/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "matchview.h"
#import "ball.h"
#import "player.h"
#import "frame.h"
#import "snookerbreak.h"
#import "graphView.h"


@interface matchview ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerStatsPosition;
@property (weak, nonatomic) IBOutlet ball *buttonRed;
@property (weak, nonatomic) IBOutlet UILabel *redIndicator;
@property (weak, nonatomic) IBOutlet ball *buttonYellow;
@property (weak, nonatomic) IBOutlet UILabel *yellowIndicator;
@property (weak, nonatomic) IBOutlet ball *buttonGreen;
@property (weak, nonatomic) IBOutlet UILabel *greenIndicator;
@property (weak, nonatomic) IBOutlet ball *buttonBrown;
@property (weak, nonatomic) IBOutlet UILabel *brownIndicator;
@property (weak, nonatomic) IBOutlet ball *buttonBlue;
@property (weak, nonatomic) IBOutlet UILabel *blueIndicator;
@property (weak, nonatomic) IBOutlet ball *buttonPink;
@property (weak, nonatomic) IBOutlet UILabel *pinkIndicator;
@property (weak, nonatomic) IBOutlet ball *buttonBlack;
@property (weak, nonatomic) IBOutlet UILabel *blackIndicator;
@property (weak, nonatomic) IBOutlet player *textScorePlayer1;
@property (weak, nonatomic) IBOutlet player *textScorePlayer2;
@property (strong, nonatomic) player    *currentPlayer;
@property (strong, nonatomic) player    *opposingPlayer;
@property (weak, nonatomic) IBOutlet UITextField *textPlayerOneName;
@property (weak, nonatomic) IBOutlet UITextField *textPlayerTwoName;
@property (weak, nonatomic) IBOutlet UIView *viewScorePlayer1;
@property (weak, nonatomic) IBOutlet UIView *viewScorePlayer2;
@property (weak, nonatomic) IBOutlet frame *labelScoreMatchPlayer1;
@property (weak, nonatomic) IBOutlet frame *labelScoreMatchPlayer2;
@property (weak, nonatomic) IBOutlet UIView *viewBreak;
@property (weak, nonatomic) IBOutlet UISwitch *switchFoul;
@property (weak, nonatomic) IBOutlet UILabel *foulLabel;
@property (weak, nonatomic) IBOutlet snookerbreak *currentPlayersBreak;
@property (weak, nonatomic) IBOutlet UILabel *labelStatePlayer1;
@property (weak, nonatomic) IBOutlet UILabel *labelStatePlayer2;
@property (weak, nonatomic) IBOutlet UIImageView *imagePottedBall;
@property (nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UILabel *statContentLabelPlayer1;
@property (weak, nonatomic) IBOutlet UIView *statContentP1View;

@property (weak, nonatomic) IBOutlet UILabel *statNameLabelPlayer1;
@property (weak, nonatomic) IBOutlet UILabel *statNameLabelPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *statContentLabelPlayer2;
@property (weak, nonatomic) IBOutlet UIView *statContentP2View;


@property (weak, nonatomic) IBOutlet UIView *PlayerStatsView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navButtonNew;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navButtonEnd;

@property (weak, nonatomic) IBOutlet UILabel *frameInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonClear;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdjust;
@property (weak, nonatomic) IBOutlet UIView *disabledView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) NSMutableArray *frameData;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statBoxHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statP1ContentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statP2ContentHeightConstraint;
@property (assign) int statPlayer1item;
@property (assign) int statPlayer2item;
@property (assign) int visitBallCount;
@property (assign) bool isButtonStateClear;
@property (weak, nonatomic) IBOutlet UIView *visitBreakdownView;
@property (weak, nonatomic) IBOutlet graphView *frameGraphView;
@property (weak, nonatomic) IBOutlet UILabel *visitDetailsLable;
@property (strong, nonatomic) UIAlertView *alertEndScores;
@property (strong, nonatomic) UIAlertView *alertOkNotification;
@property (strong, nonatomic) UIAlertView *alertUndoEntry;
@end


/*

 DONE
Added control to disable colours as frame progresses
Provide difference in players score and compare against expected amount left on table.
Allow freeballs
Handle tied frames and respotted black

TODO
CLear button - only visible/enabled when user is actually on a break
Adjust button - only visibale/enabled when user is not on a break
Player Stats - when expanded should all activity behind in main view should be disabled DONE!
Link current ball & quantities to adjustment process.
End of frame occurs when all balls are potted.  Provide a message of sorts.
Still issue when user fouls at same time as potting current ball.  More analysis needed!

 
*/
@implementation matchview 
@synthesize joinedFrameResult;
@synthesize frameNumber;
@synthesize matchData;
@synthesize currentColour;
@synthesize colourStateAtStartOfBreak;
@synthesize colourQuantityAtStartOfBreak;
@synthesize frameGraphView;
@synthesize ballReplaced;
@synthesize imgPicker;
@synthesize advancedCounting;
enum scoreStatus { FrameScore, HighestBreak, BallsPotted, TotalVisits, AvgBreak };
enum scoreStatus scoreState;
enum IndicatorStyle {highlight, hide};

#pragma mark -standard methods


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.imgPicker = [[UIImagePickerController alloc] init];
    //self.imgPicker.allowsImageEditing = YES;
    //self.imgPicker.delegate = self;
    //self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
   
    //[self presentViewController:self.imgPicker animated:YES completion:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];

    
    
    
       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"showInstructions"]) {
        [defaults setBool:YES forKey:@"showInstructions"];
        [defaults setValue:@"Player 1" forKey:@"player1"];
        [defaults setValue:@"Player 2" forKey:@"player2"];
        [defaults setBool:YES forKey:@"advancedCounting"];
    }
    if ([defaults boolForKey:@"showInstructions"] == YES) {
       [self performSegueWithIdentifier:@"segueToInstructions" sender:self];
        
        [defaults setBool:NO forKey:@"showInstructions"];
        [defaults synchronize];
    }
    self.textPlayerOneName.text = [defaults stringForKey:@"player1"];
    if (self.textPlayerOneName.text==nil) {
     self.textPlayerOneName.text = @"Player 1";
    }
    self.textPlayerTwoName.text = [defaults stringForKey:@"player2"];
    if (self.textPlayerTwoName.text==nil) {
        self.textPlayerTwoName.text = @"Player 2";
    }
    self.advancedCounting = [defaults boolForKey:@"advancedCounting"];
    if (!self.advancedCounting) {
        self.frameInfo.hidden = true;
    }
    
    self.textScorePlayer1.playerIndex = 1;
    self.textScorePlayer2.playerIndex = 2;
    
    self.currentPlayer = self.textScorePlayer1;
    self.opposingPlayer = self.textScorePlayer2;

    //TODO fix foulPoints so they use default value in ball object
    self.buttonRed.colour = @"Red";
    self.buttonRed.foulPoints = 4;
    self.buttonRed.pottedPoints = 1;
    self.buttonRed.quantity = 15;
    self.buttonRed.imageNameLarge = @"ball_large_red01.png";
    self.buttonRed.imageNameSmall = @"ball_small_red01.png";
    
    
    self.buttonYellow.colour = @"Yellow";
    self.buttonYellow.foulPoints = 4;
    self.buttonYellow.pottedPoints = 2;
    self.buttonYellow.quantity = 1;
    self.buttonYellow.imageNameLarge = @"ball_large_yellow02.png";
    self.buttonYellow.imageNameSmall = @"ball_small_yellow02.png";
    
    self.buttonGreen.colour = @"Green";
    self.buttonGreen.foulPoints = 4;
    self.buttonGreen.pottedPoints = 3;
    self.buttonGreen.quantity = 1;
    self.buttonGreen.imageNameLarge = @"ball_large_green03.png";
    self.buttonGreen.imageNameSmall = @"ball_small_green03.png";

    self.buttonBrown.colour = @"Brown";
    self.buttonBrown.foulPoints = 4;
    self.buttonBrown.pottedPoints = 4;
    self.buttonBrown.quantity = 1;
    self.buttonBrown.imageNameLarge = @"ball_large_brown04.png";
    self.buttonBrown.imageNameSmall = @"ball_small_brown04.png";
    
    self.buttonBlue.colour = @"Blue";
    self.buttonBlue.foulPoints = 5;
    self.buttonBlue.pottedPoints = 5;
    self.buttonBlue.quantity = 1;
    self.buttonBlue.imageNameLarge = @"ball_large_blue05.png";
    self.buttonBlue.imageNameSmall = @"ball_small_blue05.png";
    
    self.buttonPink.colour = @"Pink";
    self.buttonPink.foulPoints = 6;
    self.buttonPink.pottedPoints = 6;
    self.buttonPink.quantity = 1;
    self.buttonPink.imageNameLarge = @"ball_large_pink06.png";
    self.buttonPink.imageNameSmall = @"ball_small_pink06.png";
    
    self.buttonBlack.colour = @"Black";
    self.buttonBlack.foulPoints = 7;
    self.buttonBlack.pottedPoints = 7;
    self.buttonBlack.quantity = 1;
    self.buttonBlack.imageNameLarge = @"ball_large_black07.png";
    self.buttonBlack.imageNameSmall = @"ball_small_black07.png";
    
    self.currentColour=1;

    
    UITapGestureRecognizer *selectPlayerOneTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(selectPlayerOneTap:)];
    selectPlayerOneTap.numberOfTapsRequired = 1;
    [self.viewScorePlayer1 addGestureRecognizer:selectPlayerOneTap];

    
    UITapGestureRecognizer *selectPlayerTwoTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(selectPlayerTwoTap:)];
    selectPlayerTwoTap.numberOfTapsRequired = 1;
    [self.viewScorePlayer2 addGestureRecognizer:selectPlayerTwoTap];
    
    
    UITapGestureRecognizer *selectStatPlayerOneTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(selectStatPlayerOneTap:)];
    selectStatPlayerOneTap.numberOfTapsRequired = 1;
    [self.statContentP1View addGestureRecognizer:selectStatPlayerOneTap];
    
    
    UITapGestureRecognizer *selectStatPlayerTwoTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(selectStatPlayerTwoTap:)];
    selectStatPlayerTwoTap.numberOfTapsRequired = 1;
    [self.statContentP2View addGestureRecognizer:selectStatPlayerTwoTap];

    
    UITapGestureRecognizer *endBreakTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(endBreakTap:)];
    endBreakTap.numberOfTapsRequired = 1;
    [self.viewBreak addGestureRecognizer:endBreakTap];
    

    UITapGestureRecognizer *tapHideStats = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(tapHidePlayersStats:)];
    tapHideStats.numberOfTapsRequired = 1;
    [self.PlayerStatsView addGestureRecognizer:tapHideStats];
    
    
    UITapGestureRecognizer *tapHideVisitData = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(tapHideVisitData:)];
    tapHideVisitData.numberOfTapsRequired = 1;
    [self.visitBreakdownView addGestureRecognizer:tapHideVisitData];
    
    
    
    
    
    UISwipeGestureRecognizer  *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightShowPlayersStats:)];
    swipeRight.numberOfTouchesRequired = 1;//give required num of touches here ..
    swipeRight.delegate = (id)self;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer  *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHidePlayersStats:)];
    swipeLeft.numberOfTouchesRequired = 1;//give required num of touches here ..
    swipeLeft.delegate = (id)self;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    self.frameNumber=1;
    self.matchData = [[NSMutableArray alloc] init];
    
    
    [self.textScorePlayer1 createFrame:(self.frameNumber)];
    [self.textScorePlayer2 createFrame:(self.frameNumber)];
    
    self.joinedFrameResult = [[NSMutableArray alloc] init];

    
    [self.pointsLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    [self.frameGraphView initFrameData];
    
    
    //PlayerStatsView.frame.size.height
    self.statViewWidthConstraint.constant = self.view.frame.size.width;
    
    self.playerStatsPosition.constant =  2 - self.view.frame.size.width;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        self.statBoxHeightConstraint.constant = 30;
        self.statP1ContentHeightConstraint.constant = 50;
        self.statP2ContentHeightConstraint.constant = 50;
    } else {
        self.statBoxHeightConstraint.constant = 55;
        self.statP1ContentHeightConstraint.constant = 100;
        self.statP2ContentHeightConstraint.constant = 100;
    }
    
    self.statPlayer1item=0;
    self.statPlayer2item=0;
    self.visitBallCount=0;
    self.frameGraphView.visitBreakDown = self.visitBreakdownView;
    self.frameGraphView.visitBallGrid = self.visitBallGrid;
    self.frameGraphView.visitBallCollection = [[NSMutableArray alloc] init];
    

    self.visitBallGrid.dataSource = self;
    self.visitBallGrid.delegate = self;
    
    self.frameGraphView.delegate = self;
    
    self.isButtonStateClear = false;
}

-(void)reloadGrid {
    [self.visitBallGrid reloadData];

    self.visitDetailsLable.text = [NSString stringWithFormat:@"Visit Details %@", [self.frameGraphView timeStamp] ];
    
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            [self.frameGraphView setNeedsDisplay];
                self.statViewWidthConstraint.constant = self.view.frame.size.width;
             if (self.playerStatsPosition.constant!=0) {
                self.playerStatsPosition.constant =  2 - self.view.frame.size.width;
             }

            self.statBoxHeightConstraint.constant = 55;
            self.statP1ContentHeightConstraint.constant = 100;
            self.statP2ContentHeightConstraint.constant = 100;
            
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            [self.frameGraphView setNeedsDisplay];
                self.statViewWidthConstraint.constant = self.view.frame.size.width;
            if (self.playerStatsPosition.constant!=0) {
                self.playerStatsPosition.constant =  2 - self.view.frame.size.width;
            }
            self.statBoxHeightConstraint.constant = 55;
            self.statP1ContentHeightConstraint.constant = 100;
            self.statP2ContentHeightConstraint.constant = 100;
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self.frameGraphView setNeedsDisplay];
            self.statViewWidthConstraint.constant = self.view.frame.size.width;
            if (self.playerStatsPosition.constant!=0) {
                self.playerStatsPosition.constant =  2 - self.view.frame.size.width;
            }
            self.statBoxHeightConstraint.constant = 30;
            self.statP1ContentHeightConstraint.constant = 50;
            self.statP2ContentHeightConstraint.constant = 50;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            [self.frameGraphView setNeedsDisplay];
            self.statViewWidthConstraint.constant = self.view.frame.size.width;
            if (self.playerStatsPosition.constant!=0) {
                self.playerStatsPosition.constant =  2 - self.view.frame.size.width;
            }
            self.statBoxHeightConstraint.constant = 30;
            self.statP1ContentHeightConstraint.constant = 50;
            self.statP2ContentHeightConstraint.constant = 50;
            break;
            
        default:
            [self.frameGraphView setNeedsDisplay];
                self.statViewWidthConstraint.constant = self.view.frame.size.width;
             if (self.playerStatsPosition.constant!=0) {
                self.playerStatsPosition.constant =  2 - self.view.frame.size.width;
             }
            self.statBoxHeightConstraint.constant = 55;
            self.statP1ContentHeightConstraint.constant = 100;
            self.statP2ContentHeightConstraint.constant = 100;
            break;
    };
}



-(void)swipeRightShowPlayersStats:(UISwipeGestureRecognizer *)gesture
{
    // example potted points for player 1
    //int player1Points = [self.frameGraphView getPointsByTypeInFrame:[self.frameGraphView frameData] :1 :0];

    
   // NSLog(@"Player one potted points=%d", player1Points);
    
    
    self.navButtonNew.title  = @"";
    self.navButtonNew.enabled=false;
    self.navButtonEnd.title  = @"";
    self.navButtonEnd.enabled=false;
    
    int latestScorePlayer1 = [self.frameGraphView getPointsInFrame:[self.frameGraphView frameData] :1];
    int latestScorePlayer2 = [self.frameGraphView getPointsInFrame:[self.frameGraphView frameData] :2];
    
    
    //int latestScorePlayer1=self.textScorePlayer1.frameScore;
    //int latestScorePlayer2=self.textScorePlayer2.frameScore;
    int currentBreak = self.currentPlayersBreak.breakScore;
    
    if (self.currentPlayer.playerIndex==1) {
        latestScorePlayer1 += currentBreak;
        self.frameGraphView.currentBreakPlayer1 = currentBreak;
        self.frameGraphView.currentBreakPlayer2 = 0;
    } else {
        latestScorePlayer2 += currentBreak;
        self.frameGraphView.currentBreakPlayer2 = currentBreak;
        self.frameGraphView.currentBreakPlayer1 = 0;
    }
    self.statNameLabelPlayer1.text =  [NSString stringWithFormat:@"%@:%d",self.textPlayerOneName.text, latestScorePlayer1];
   
    self.statNameLabelPlayer2.text = [NSString stringWithFormat:@"%@:%d",self.textPlayerTwoName.text, latestScorePlayer2];

    self.statContentLabelPlayer1.text = [self getFrameBreakdown :1 :[self.frameGraphView frameData] :@"\n" :self.statPlayer1item];
    self.statContentLabelPlayer2.text = [self getFrameBreakdown :2 :[self.frameGraphView frameData] :@"\n" :self.statPlayer2item];
    
    
    self.playerStatsPosition.constant=0;
    
    self.frameInfo.text = [self getFrameBoxInfo];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.PlayerStatsView layoutIfNeeded];
    }];
    
    self.disabledView.hidden=false;
    self.pointsLabel.hidden = false;
    [self.frameGraphView setNeedsDisplay];
}

-(void)tapHidePlayersStats:(UISwipeGestureRecognizer *)gesture
{
 //   [self hidePlayersStats];
}

-(void)tapHideVisitData :(UISwipeGestureRecognizer *)gesture
{
    self.visitBreakdownView.hidden=true;
    
    

}


-(void)swipeLeftHidePlayersStats:(UISwipeGestureRecognizer *)gesture
{
    [self hidePlayersStats];
}

-(void)hidePlayersStats {
    
    self.playerStatsPosition.constant=-self.statViewWidthConstraint.constant+2;
    [UIView animateWithDuration:0.5f animations:^{
        [self.PlayerStatsView layoutIfNeeded];
    }];
    self.navButtonNew.title  = @"New";
    self.navButtonNew.enabled=true;
    self.navButtonEnd.title  = @"End";
    self.navButtonEnd.enabled=true;
    
    self.disabledView.hidden=true;
     self.pointsLabel.hidden = true;
    
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -user defined

-(void)processCurrentUsersHighestBreak {
    // if break that has just completed is higher than players highest break in match, save it.
    if ( [self.currentPlayer highestBreak] < [self.currentPlayersBreak breakScore] ) {
        [self.currentPlayer setHighestBreak:[self.currentPlayersBreak breakScore] :self.frameNumber :self.currentPlayersBreak.pottedBalls];
    }
    // if break is the highest for current player in frame save it to the frame object.
    if (self.currentPlayer.currentFrame.frameHighestBreak < [self.currentPlayersBreak breakScore]) {
        [self.currentPlayer.currentFrame setFrameHighestBreak:[self.currentPlayersBreak breakScore] :self.frameNumber :self.currentPlayersBreak.pottedBalls];
    }
    
    // we also need to add to the players frame transaction object.
    
    
    
    
}






// plan is to replace the above method ballClicked with this new one allowing us to
// also log the balls potted along the way into an array that we can process.

-(void)ballPotted:(ball*)pottedBall :(UILabel*) indicatorBall {

    bool freeBall=false;
    
    if (self.currentPlayersBreak.breakScore==0) {
    self.viewBreak.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.viewBreak.alpha = 1.0;
                     }
                     completion:nil
     ];
     
        self.buttonAdjust.hidden = true;
        [self.buttonClear setTitle:@"Clear" forState:UIControlStateNormal];
        self.isButtonStateClear = true;
        
    }
    
    
    if ([self.switchFoul isOn] ) {
        NSMutableArray *foulBallArray = [[NSMutableArray alloc] init];
        foulBallArray = [NSMutableArray arrayWithObjects:pottedBall, nil];
        
        [self closeBreak];
        // add the foul points to opposing player
        [self.opposingPlayer setFoulScore:pottedBall.foulPoints];
        
        // send array to method for foul ball.
        

        
        [self.frameGraphView addFrameData:self.frameNumber :self.opposingPlayer.playerIndex :pottedBall.foulPoints :1 :foulBallArray];
        [self.currentPlayersBreak clearBreak:self.imagePottedBall];
        [self.switchFoul setOn:false];
        self.foulLabel.hidden=true;
        self.buttonAdjust.hidden = false;
        [self.buttonClear setTitle:@"Undo" forState:UIControlStateNormal];
        self.isButtonStateClear = false;
        //self.buttonClear.hidden = true;
        [self swapPlayers];
        
    } else {

        if (self.advancedCounting) {
        
        
            if (self.currentColour < pottedBall.pottedPoints && self.currentPlayersBreak.breakScore==0 ) {
            // handle freeball scenario - free balls start the moment. Conditions - 1st pot of break.  ball potted greater than current 'live' ball

                pottedBall.potsInBreakCounter ++;
                indicatorBall.text = [NSString stringWithFormat:@"%d",pottedBall.potsInBreakCounter];
                if (self.currentColour==1) {
                    pottedBall = self.buttonRed;
                } else if (self.currentColour==2) {
                    pottedBall = self.buttonYellow;
                } else if (self.currentColour==3) {
                    pottedBall = self.buttonGreen;
                } else if (self.currentColour==4) {
                    pottedBall = self.buttonBrown;
                } else if (self.currentColour==5) {
                    pottedBall = self.buttonBlue;
                } else if (self.currentColour==6) {
                    pottedBall = self.buttonPink;
                }
                freeBall=true;
            } else if (self.currentPlayersBreak.breakScore==0) {
                // save current ball state at beginning of break just in case user cancels break.
                colourStateAtStartOfBreak = currentColour;
                colourQuantityAtStartOfBreak = pottedBall.quantity;
            }
        
            // it is a pot, so credit the current user
            if ([self.currentPlayersBreak incrementScore:pottedBall :self.imagePottedBall ] == true) {
                [self.currentPlayer incrementNbrBalls:1];
                [self.currentPlayer.currentFrame incrementFrameBallsPotted];
            
                if (pottedBall.quantity >= 1 && pottedBall.pottedPoints == 1 && freeBall == false) {
                    [pottedBall decreaseQty];
                    if (pottedBall.quantity == 0) {
                        currentColour ++;
                        self.ballReplaced=true;
                    }
                } else if (pottedBall.pottedPoints == self.currentColour) {
                
                    if (self.ballReplaced && pottedBall.pottedPoints == 2) {
                        //Allow Yellow to be potted twice after final red.
                        self.ballReplaced=false;
                    } else if (pottedBall.pottedPoints == 7 && (self.currentPlayer.currentFrame.frameScore + self.currentPlayersBreak.breakScore) == self.opposingPlayer.currentFrame.frameScore) {
                    // Allow a respotted Black!
                    
                    } else if (freeBall == false) {
                        [pottedBall decreaseQty];
                        self.currentColour ++;
                    }
                } else if (pottedBall.pottedPoints != self.currentColour && self.currentColour == 2 && self.ballReplaced) {
                    self.ballReplaced=false;
                }
                if (freeBall==false) {
                    pottedBall.potsInBreakCounter ++;
                    indicatorBall.text = [NSString stringWithFormat:@"%d",pottedBall.potsInBreakCounter];
                }
         
                [self clearIndicators :highlight];
                [indicatorBall setFont:[UIFont boldSystemFontOfSize:14]];
                indicatorBall.textColor = [UIColor whiteColor];
                indicatorBall.hidden = false;
            }
            
        } else {  // no advanced scoring
            if ([self.currentPlayersBreak incrementScore:pottedBall :self.imagePottedBall ] == true) {
                [self.currentPlayer incrementNbrBalls:1];
                [self.currentPlayer.currentFrame incrementFrameBallsPotted];
                [self clearIndicators :highlight];
                pottedBall.potsInBreakCounter ++;
                indicatorBall.text = [NSString stringWithFormat:@"%d",pottedBall.potsInBreakCounter];
                
                [indicatorBall setFont:[UIFont boldSystemFontOfSize:14]];
                indicatorBall.textColor = [UIColor whiteColor];
                indicatorBall.hidden = false;
            }
                
        }
        [self.currentPlayer.currentFrame increaseFrameScore:self.currentPlayer.frameScore];
    }
}

- (IBAction)redClicked:(id)sender {
    [self ballPotted:self.buttonRed :self.redIndicator];
}
- (IBAction)yellowClicked:(id)sender {
    [self ballPotted:self.buttonYellow :self.yellowIndicator];
}
- (IBAction)greenClicked:(id)sender {
    [self ballPotted:self.buttonGreen :self.greenIndicator];
}
- (IBAction)brownClicked:(id)sender {
    [self ballPotted:self.buttonBrown :self.brownIndicator];
}
- (IBAction)blueClicked:(id)sender {
    [self ballPotted:self.buttonBlue :self.blueIndicator];
}
- (IBAction)pinkClicked:(id)sender {
    [self ballPotted:self.buttonPink :self.pinkIndicator];
}
- (IBAction)blackClicked:(id)sender {
    [self ballPotted:self.buttonBlack :self.blackIndicator];
}


-(void)endBreakTap:(UITapGestureRecognizer *)gesture
{
    /* add break score to users frame total and hide the cueball */
    [self closeBreak];
    /* next player up */
    [self swapPlayers];
}

-(void)closeBreak {
    /* set counter variables and clear break */
    if (self.currentPlayersBreak.breakScore > 0) {
        [self.currentPlayer setSumOfBreaks:self.currentPlayer.sumOfBreaks + self.currentPlayersBreak.breakScore];
        [self.currentPlayer setNbrOfBreaks:self.currentPlayer.nbrOfBreaks + 1];
        [self.currentPlayer addBreakScore:self.currentPlayersBreak.breakScore];
        [self.frameGraphView addFrameData:self.frameNumber :self.currentPlayer.playerIndex :self.currentPlayersBreak.breakScore :0 :self.currentPlayersBreak.pottedBalls];
        [self processCurrentUsersHighestBreak];
        [self.currentPlayersBreak clearBreak:self.imagePottedBall];
        [self clearIndicators :hide];
        self.ballReplaced=false;
        self.buttonAdjust.hidden = false;
        [self.buttonClear setTitle:@"Undo" forState:UIControlStateNormal];
        self.isButtonStateClear = false;
        //self.buttonClear.hidden = true;
        self.frameGraphView.currentBreakPlayer1=0;
        self.frameGraphView.currentBreakPlayer2=0;
    }
}


-(void)clearIndicators :(enum IndicatorStyle) indicator {
    
    if (indicator == hide) {
        [self resetIndicator:self.buttonRed :self.redIndicator];
        [self resetIndicator:self.buttonYellow :self.yellowIndicator];
        [self resetIndicator:self.buttonGreen :self.greenIndicator];
        [self resetIndicator:self.buttonBrown :self.brownIndicator];
        [self resetIndicator:self.buttonBlue :self.blueIndicator];
        [self resetIndicator:self.buttonPink :self.pinkIndicator];
        [self resetIndicator:self.buttonBlack :self.blackIndicator];
    } else if (indicator == highlight) {
        [self resetIndicatorStyle:self.redIndicator];
        [self resetIndicatorStyle:self.yellowIndicator];
        [self resetIndicatorStyle:self.greenIndicator];
        [self resetIndicatorStyle:self.brownIndicator];
        [self resetIndicatorStyle:self.blueIndicator];
        [self resetIndicatorStyle:self.pinkIndicator];
        [self resetIndicatorStyle:self.blackIndicator];
    }
}

-(void)resetIndicator :(ball*)pottedBall :(UILabel*) indicatorBall {
    pottedBall.potsInBreakCounter = 0;
    indicatorBall.hidden=true;
}

-(void)resetIndicatorStyle :(UILabel*) indicatorBall {
    [indicatorBall setFont:[UIFont systemFontOfSize:14]];
    indicatorBall.textColor = [UIColor orangeColor];
}


-(void)swapPlayers {
    /* switch the player in focus to the other */
    
    if (self.currentPlayer == self.textScorePlayer1) {
        self.currentPlayer = self.textScorePlayer2;
        self.opposingPlayer = self.textScorePlayer1;
        [self.textPlayerTwoName setTextColor:[UIColor whiteColor]];
        [self.textPlayerOneName setTextColor:[UIColor orangeColor]];
    } else {
        self.currentPlayer = self.textScorePlayer1;
        self.opposingPlayer = self.textScorePlayer2;
        [self.textPlayerTwoName setTextColor:[UIColor orangeColor]];
        [self.textPlayerOneName setTextColor:[UIColor whiteColor]];
    }
    [self.currentPlayer setTextColor:[UIColor whiteColor]];
    [self.opposingPlayer setTextColor:[UIColor orangeColor]];
    /* enum to control the stats view */
    scoreState = FrameScore;
    self.labelStatePlayer1.text = @"";
    self.labelStatePlayer2.text = @"";
}







-(void)selectPlayerOneTap:(UITapGestureRecognizer *)gesture
{
    
    
    Boolean modified = false;
    NSString *labelScore;
    
    if (self.textScorePlayer1 == self.opposingPlayer) {
        [self selectPlayerOne];
        modified = true;
        labelScore = [NSString stringWithFormat:@"%d",self.opposingPlayer.currentFrame.frameScore];
        self.textScorePlayer2.text = labelScore;
    }
    if (scoreState == FrameScore && modified == false) {
        scoreState = HighestBreak;
        int highestBreakInMatch = [self getMatchHighestBreak:1];
        NSString *labelHighestBreak = [NSString stringWithFormat:@"%d",highestBreakInMatch];
        self.textScorePlayer1.text  =labelHighestBreak;
        self.labelStatePlayer1.text = @"Hi Break";
    } else if (scoreState == HighestBreak && modified == false) {
        scoreState = BallsPotted;
        int ballsPottedInMatch = [self getMatchBallsPotted:1];
        NSString *labelBallsPotted = [NSString stringWithFormat:@"%d",ballsPottedInMatch];
        self.textScorePlayer1.text  = labelBallsPotted;
        self.labelStatePlayer1.text = @"Balls Potted";
    } else if (scoreState == BallsPotted && modified == false) {
        scoreState = TotalVisits;
        int totalVisits = [self getMatchVisits:1];
        NSString *labelMatchVisits = [NSString stringWithFormat:@"%d",totalVisits];
        self.textScorePlayer1.text  = labelMatchVisits;
        self.labelStatePlayer1.text = @"Visits";
    } else if (scoreState == TotalVisits && modified == false) {
        scoreState = AvgBreak;
        NSString *labelAvgBreak = [NSString stringWithFormat:@"%0.2f", [self getAverageBreakAmountInMatch:1]];
        self.textScorePlayer1.text  = labelAvgBreak;
        self.labelStatePlayer1.text = @"Avg Break";
    } else if (scoreState == AvgBreak && modified == false) {
        scoreState = FrameScore;
        [self.currentPlayer addBreakScore:0];
        self.labelStatePlayer1.text = @"";
    }
}

-(void)selectPlayerOne {
    self.currentPlayer = self.textScorePlayer1;
    self.opposingPlayer = self.textScorePlayer2;

    [self.currentPlayer setTextColor:[UIColor whiteColor]];
    [self.opposingPlayer setTextColor:[UIColor orangeColor]];
    [self.textPlayerOneName setTextColor:[UIColor whiteColor]];
    [self.textPlayerTwoName setTextColor:[UIColor orangeColor]];
    
    scoreState = FrameScore;
    self.labelStatePlayer1.text = @"";
    self.labelStatePlayer2.text = @"";
    
}


-(void)selectPlayerTwoTap:(UITapGestureRecognizer *)gesture
{
   Boolean modified = false;
    NSString *labelScore;
    
    if (self.textScorePlayer2 == self.opposingPlayer) {
        [self selectPlayerTwo];
        modified = true;
        labelScore = [NSString stringWithFormat:@"%d",self.opposingPlayer.currentFrame.frameScore];
        self.textScorePlayer1.text = labelScore;
        
    }
    if (scoreState == FrameScore && modified == false) {
        scoreState = HighestBreak;
        int highestBreakInMatch = [self getMatchHighestBreak:2];
        NSString *labelHighestBreak = [NSString stringWithFormat:@"%d",highestBreakInMatch];
        self.textScorePlayer2.text  =labelHighestBreak;
        self.labelStatePlayer2.text = @"Hi Break";
    } else if (scoreState == HighestBreak && modified == false) {
        scoreState = BallsPotted;
        int ballsPottedInMatch = [self getMatchBallsPotted:2];
        NSString *labelBallsPotted = [NSString stringWithFormat:@"%d",ballsPottedInMatch];
        self.textScorePlayer2.text  = labelBallsPotted;
        self.labelStatePlayer2.text = @"Balls Potted";
    } else if (scoreState == BallsPotted && modified == false) {
        scoreState = TotalVisits;
        int totalVisits = [self getMatchVisits:2];
        NSString *labelMatchVisits = [NSString stringWithFormat:@"%d",totalVisits];
        self.textScorePlayer2.text  = labelMatchVisits;
        self.labelStatePlayer2.text = @"Visits";
    } else if (scoreState == TotalVisits && modified == false) {
        scoreState = AvgBreak;
        NSString *labelAvgBreak = [NSString stringWithFormat:@"%0.2f", [self getAverageBreakAmountInMatch:2]];
        self.textScorePlayer2.text  = labelAvgBreak;
        self.labelStatePlayer2.text = @"Avg Break";
    } else if (scoreState == AvgBreak && modified == false) {
        scoreState = FrameScore;
        [self.currentPlayer addBreakScore:0];
        self.labelStatePlayer2.text = @"";
    }

}


-(void)selectPlayerTwo {
    self.currentPlayer = self.textScorePlayer2;
    self.opposingPlayer = self.textScorePlayer1;

    [self.currentPlayer setTextColor:[UIColor whiteColor]];
    [self.opposingPlayer setTextColor:[UIColor orangeColor]];
    [self.textPlayerTwoName setTextColor:[UIColor whiteColor]];
    [self.textPlayerOneName setTextColor:[UIColor orangeColor]];

    scoreState = FrameScore;
    self.labelStatePlayer1.text = @"";
    self.labelStatePlayer2.text = @"";
}

- (IBAction)dismissPlayerOneKB:(id)sender {
    [self.textPlayerOneName becomeFirstResponder];
    [self.textPlayerOneName resignFirstResponder];
}

- (IBAction)dismissPlayerTwoKB:(id)sender {
    [self.textPlayerTwoName becomeFirstResponder];
    [self.textPlayerTwoName resignFirstResponder];
}

- (IBAction)newFrameClicked:(id)sender {
    [self endOfFrame];
}

-(void)endOfFrame {
    [self closeBreak];
    
    [self.matchData addObjectsFromArray:[self.frameGraphView frameData]];
    

    if (self.textScorePlayer1.frameScore > self.textScorePlayer2.frameScore) {
        [self.labelScoreMatchPlayer1 incrementMatchScore];
    } else if (self.textScorePlayer1.frameScore < self.textScorePlayer2.frameScore) {
        [self.labelScoreMatchPlayer2 incrementMatchScore];
    } else {
        /* do nothing. game tied so no winner yet! */
    }
    
    /* reset new frame scores for each player */
    if ([self.joinedFrameResult count] == 0) {
        self.joinedFrameResult = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@/%@",self.textScorePlayer1.text, self.textScorePlayer2.text], nil];
    } else {
        [self.joinedFrameResult addObject:[NSString stringWithFormat:@"%@/%@ ",self.textScorePlayer1.text,self.textScorePlayer2.text]];
    }
    
    [self.textScorePlayer1 resetFrameScore:0];
    [self.textScorePlayer2 resetFrameScore:0];
    [self selectPlayerOne];
    self.frameNumber++;
    [self.textScorePlayer1 createFrame:(self.frameNumber)];
    [self.textScorePlayer2 createFrame:(self.frameNumber)];
    [self resetBalls];
    
    //TODO - this is where we should show a popup view that will show the graph...
    

    //We would need to save the array someplace too.
    [self.frameGraphView resetFrameData];
}


-(void)resetBalls {
    self.buttonRed.enabled = true;
    self.buttonRed.quantity = 15;
    self.buttonYellow.enabled = true;
    self.buttonYellow.quantity = 1;
    self.buttonGreen.enabled = true;
    self.buttonGreen.quantity = 1;
    self.buttonBrown.enabled = true;
    self.buttonBrown.quantity = 1;
    self.buttonBlue.enabled = true;
    self.buttonBlue.quantity = 1;
    self.buttonPink.enabled = true;
    self.buttonPink.quantity = 1;
    self.buttonBlack.enabled = true;
    self.buttonBlack.quantity = 1;
    self.currentColour=1;
    self.ballReplaced = false;
}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)endOfMatchClicked:(id)sender {
    [self processMatchEnd];
    
}


-(void) processMatchEnd {
    /* so first we present the winner with a congratulations message */
    NSString *alertMessage;
    NSString *titleMessage;
    if (self.labelScoreMatchPlayer1.matchScore > self.labelScoreMatchPlayer2.matchScore) {
        titleMessage = [NSString stringWithFormat:@"Congratulations %@",self.textPlayerOneName.text];
        alertMessage = [NSString stringWithFormat:@"You won the match!\n %@ to %@\n\nNow Go send the results to anyone who may be interested.\n\nAlternatively press Cancel if you ended match by accident",self.labelScoreMatchPlayer1.text,self.labelScoreMatchPlayer2.text];
    } else if (self.labelScoreMatchPlayer1.matchScore < self.labelScoreMatchPlayer2.matchScore) {
        titleMessage = [NSString stringWithFormat:@"Congratulations %@",self.textPlayerTwoName.text];
        alertMessage = [NSString stringWithFormat:@"You won the match!\n %@ to %@\n\nNow Go send the results to anyone who may be interested.\n\nAlternatively press Cancel if you ended match by accident",self.labelScoreMatchPlayer1.text,self.labelScoreMatchPlayer2.text];

    } else {
       titleMessage = @"Match tied";
        alertMessage =[NSString stringWithFormat:@"Score was %@ to %@\n\nNow Go send the results to anyone who may be interested.\n\nAlternatively press Cancel if you ended match by accident",self.labelScoreMatchPlayer1.text,self.labelScoreMatchPlayer2.text];
    }
        
    
    self.alertEndScores = [[UIAlertView alloc] initWithTitle:titleMessage message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    self.alertEndScores.alertViewStyle = UIAlertViewStyleDefault ;
    [self.alertEndScores addButtonWithTitle:@"Go"];
    [self.alertEndScores show];
    [self.frameGraphView resetFrameData];
    
}




-(void) endMatch {
   
    /* next part attempts to compose an email and offer the user to load recipients & send an email */
    BOOL ok = [MFMailComposeViewController canSendMail];
    if (!ok) return;
    
    NSString *body = [self composeMessage];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
    MFMailComposeViewController* snookerScorerMailComposer = [MFMailComposeViewController new];
    snookerScorerMailComposer.mailComposeDelegate = self;
    [snookerScorerMailComposer setSubject:[NSString stringWithFormat:@"Snooker Score Master - Matchday :%@", [DateFormatter stringFromDate:[NSDate date]]]];
    //[snookerScorerMailComposer setToRecipients:[NSArray arrayWithObjects:@"andrewglew@me.com", @"dho041@gmail.com", nil]];
    [snookerScorerMailComposer setMessageBody:body isHTML:YES];
    
    [self presentViewController:snookerScorerMailComposer animated:YES completion:nil];

    /* this long winded part resets the application */
    [self.textScorePlayer1 resetFrameScore:0];
    [self.textScorePlayer2 resetFrameScore:0];
    
    [self.textScorePlayer1.frames removeAllObjects];
    self.labelScoreMatchPlayer1.matchScore=0;
    self.labelScoreMatchPlayer1.text = @"0";
    self.textScorePlayer1.highestBreak = 0;
    [self.textScorePlayer1.highestBreakHistory removeAllObjects];
    self.textScorePlayer1.nbrBallsPotted = 0;
    self.textScorePlayer1.currentFrameIndex=1;
    self.textScorePlayer1.nbrOfBreaks=0;
    self.textScorePlayer1.sumOfBreaks=0;
    self.textScorePlayer1.currentFrame.matchScore=0;
    [self.textScorePlayer1.playersBreaks removeAllObjects];
    

    [self.textScorePlayer2.frames removeAllObjects];
    self.labelScoreMatchPlayer2.matchScore=0;
    self.labelScoreMatchPlayer2.text = @"0";
    self.textScorePlayer2.highestBreak = 0;
    [self.textScorePlayer2.highestBreakHistory removeAllObjects];
    self.textScorePlayer2.nbrBallsPotted = 0;
    self.textScorePlayer2.currentFrameIndex=1;
    self.textScorePlayer2.nbrOfBreaks=0;
    self.textScorePlayer2.sumOfBreaks=0;
    self.textScorePlayer2.currentFrame.matchScore=0;
    [self.textScorePlayer2.playersBreaks removeAllObjects];
    self.frameNumber=1;
    [self.joinedFrameResult removeAllObjects];
    
    self.textScorePlayer1.frameScore=0;
    self.textScorePlayer1.text=@"0";
    
    self.textScorePlayer2.frameScore=0;
    self.textScorePlayer2.text=@"0";
    
    self.buttonAdjust.hidden = false;
    [self.buttonClear setTitle:@"Undo" forState:UIControlStateNormal];
    self.isButtonStateClear = false;
    
    [self.matchData removeAllObjects];

    [self resetBalls];
}


-(NSString*) composePlayerStatsForFrame :(int) playerIndex :(int)frameIndex  {
    
    NSString *hiBreakPlayer = [NSString stringWithFormat:@"</br>Highest Break: %d</br>",[self.frameGraphView getHighestBreakAmountInFrame:self.matchData :playerIndex :frameIndex]];
    
    NSString *bonusPoints = [NSString stringWithFormat:@"</br>Bonus Points: %d",[self.frameGraphView getPointsByTypeInFrame:self.matchData :playerIndex :1 :frameIndex ]];
    
    NSString *PottedPoints = [NSString stringWithFormat:@"</br>Potted Points: %d ",[self.frameGraphView getPointsByTypeInFrame:self.matchData :playerIndex :0 :frameIndex ]];
    
    NSString *hiBreakBallsPlayer = @"(";
    NSString *hiBreakBallsImagePlayer  = @"</br>";
    
    for (ball *ballObj in [self.frameGraphView getHighestBreakBallsInFrame:self.matchData :playerIndex :frameIndex]) {
        UIImage *emailImage = [UIImage imageNamed:ballObj.imageNameSmall];
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(emailImage)];
        
        NSString *base64String = [imageData base64EncodedStringWithOptions:0 ];
        NSString *ballImageData = [NSString stringWithFormat:@"<img src='data:image/png;base64,%@'>",base64String];
        hiBreakBallsPlayer = [NSString stringWithFormat:@"%@%@->",hiBreakBallsPlayer, ballObj.colour];
        hiBreakBallsImagePlayer = [NSString stringWithFormat:@"%@%@",hiBreakBallsImagePlayer, ballImageData];
    }

    NSString *ballsPotted = [NSString stringWithFormat:@"</br>Total Pots: %d</br>", [self.frameGraphView getAmountOfBallsPottedInFrame:self.matchData :playerIndex :frameIndex] ];
    
    NSString *dataPlayer = [NSString stringWithFormat:@"%@%@%@%@%@END)%@",ballsPotted, PottedPoints, bonusPoints, hiBreakPlayer, hiBreakBallsPlayer,hiBreakBallsImagePlayer];
    return dataPlayer;
}


-(NSString*) getFrameBreakdown :(int)playerIndex :(NSMutableArray*) frameData :(NSString*) lineBreak :(int)item {
    // refactored April 2015
    
    if (item==0) {
        return @"Tap to view statistics for player!";
    }
    
    NSString *dataAvgPlayer = [NSString stringWithFormat:@"Average Break = %0.2f", [self.frameGraphView getAverageBreakAmountInFrame:frameData :playerIndex]];
    
    if (item==1) {
        return dataAvgPlayer;
    }
    
    NSString *dataNbrOfPots = [NSString stringWithFormat:@"Nbr Pots/Scoring Visits = %d/%d%@", [self.frameGraphView getAmountOfBallsPottedInFrame:frameData :playerIndex :0]  ,
                               [self.frameGraphView getAmountOfVisitsInFrame:frameData :playerIndex],lineBreak];
    
    if (item==2) {
        return dataNbrOfPots;
    }

    NSString *dataHighestBreak = [NSString stringWithFormat:@"Highest Break = %d%@",[self.frameGraphView getHighestBreakAmountInFrame:frameData :playerIndex :0],lineBreak];
    
    
    if (item==3) {
        return dataHighestBreak;
    }
    
    NSMutableDictionary *breakdown  = [[NSMutableDictionary alloc] init];;
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"points"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [frameData sortedArrayUsingDescriptors:sortDescriptors];
    // obtain totals
    for (NSMutableArray *dataPoint in sortedArray) {
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
       
        
        if (playerIndex == [wantedPlayer intValue] && [wantedType intValue] == 0) {

            NSNumber *wantedBreak = [dataPoint valueForKeyPath:@"points"];
            
            NSString *paddedBreak = [NSString stringWithFormat:@"%03d",[wantedBreak intValue]];
            paddedBreak = [NSString stringWithFormat:@"%@%@",[paddedBreak substringToIndex:[paddedBreak length] - 1],@"0"];
            
            if ([wantedBreak intValue] < 10) {
                break;
            } else {
                NSNumber *occuances = [breakdown valueForKey:paddedBreak];
                
                int value = [occuances intValue];
                occuances = [NSNumber numberWithInt:value + 1];
  
                [breakdown setValue:occuances forKey:paddedBreak];
            }
        }
    }
    // write 3 totals
    NSString *breakstats = @"";
    
    for(id key in breakdown) {
        id value = [breakdown objectForKey:key];
        breakstats = [NSString stringWithFormat:@"%@ > %@ = %@%@",breakstats, key, value, @" /"];
    }
    
    if ([breakstats length] > 0) {
        breakstats = [breakstats substringToIndex:[breakstats length] - 1];
    }
    
    if([breakstats isEqualToString:@""]) {
        breakstats = @"Player has not yet had any breaks of note!";
    }
    
    if (item==4) {
        return breakstats;
    }
    
    NSString *result = [NSString stringWithFormat:@"%@%@%@%@%@%@",dataHighestBreak,lineBreak,dataAvgPlayer,lineBreak,dataNbrOfPots,lineBreak];
    
    return [NSString stringWithFormat:@"%@BREAKS:%@%@",result,breakstats,lineBreak];
}





-(NSString*) getFrameBoxInfo {
    NSString *data;
    int pointsRemaining=0;
    int currentBreak=0;
    int frameScorePlayer1=0;
    int frameScorePlayer2=0;
    
    
    // How many points remaining?
    for (int i = 7; i >= 1; i--)
    {
        if (i==1) {
            pointsRemaining += (self.buttonRed.quantity * 8);
        } else if (self.currentColour <= i) {
            pointsRemaining += i;
        } else {
            i=1;
        }
    }
    // get difference between players scores..
    
    currentBreak = self.currentPlayersBreak.breakScore;

    frameScorePlayer1 = [self.frameGraphView getPointsInFrame:[self.frameGraphView frameData]:1];
    frameScorePlayer2 = [self.frameGraphView getPointsInFrame:[self.frameGraphView frameData]:2];
    
    if (currentBreak>0) {
        
        if (self.currentPlayersBreak.currentBall.pottedPoints == 1) {
            pointsRemaining += 7;
        }
        
        if (self.currentPlayer == self.textScorePlayer1) {
            frameScorePlayer1 += currentBreak;
            
        } else {
            frameScorePlayer2 += currentBreak;
        }
    }
    
    if (frameScorePlayer1 > frameScorePlayer2) {
        // player one is winning
        data = [NSString stringWithFormat:@"%d remaining. %@ is leading %@ by %d point(s)",pointsRemaining,self.textPlayerOneName.text,self.textPlayerTwoName.text, frameScorePlayer1 - frameScorePlayer2];
        
    } else if (frameScorePlayer2 > frameScorePlayer1) {
        // player two is winning
        data = [NSString stringWithFormat:@"%d remaining. %@ is leading %@ by %d point(s)",pointsRemaining,self.textPlayerTwoName.text,self.textPlayerOneName.text,frameScorePlayer2 - frameScorePlayer1];
        
    } else {
        // players tied
        data = [NSString stringWithFormat:@"%d remaining. %@ and %@ are level",pointsRemaining,self.textPlayerOneName.text,self.textPlayerTwoName.text];
    }
    
    return data;
}


-(NSString*) composeMessage {
    
    NSString *matchheader = @"<h1>Match Statistics</h1>";
    NSString *matchJoinedResults =@"";
    
    for (NSMutableArray *obj in self.joinedFrameResult) {
        matchJoinedResults = [NSString stringWithFormat:@"%@  %@", matchJoinedResults, obj];
    }
    
    matchheader = [NSString stringWithFormat:@"%@</br>Scores:%@</br></br>",matchheader,matchJoinedResults];
    
    NSString *tableHeader = [NSString stringWithFormat: @"<table bgcolor='#F8F8FF' border=0 cellpadding='10'><tr><td width=50%% valign='top'><h2>%@:%d</h2>%@</td><td width=50%% valign='top'><h2>%@:%d</h2>%@</td></tr>",self.textPlayerOneName.text, self.labelScoreMatchPlayer1.matchScore,
        [self getFrameBreakdown :1 :self.matchData :@"</br>" :-1], self.textPlayerTwoName.text, self.labelScoreMatchPlayer2.matchScore, [self getFrameBreakdown :2 :self.matchData :@"</br>" :-1]];
    
    NSString *dataFrameHeader =@"";
    NSString *tableDetail = @"";
    NSString *dataPlayer1;
    NSString *dataPlayer2;
    NSString *scorePlayer1;
    NSString *scorePlayer2;
    
    for (int frameIndex = 0; frameIndex < self.frameNumber - 1; frameIndex++) {
        dataFrameHeader = [NSString stringWithFormat:@"<tr><td><h3>Frame no%d</h3></td><td></td></tr>",frameIndex+1];
        scorePlayer1 = [NSString stringWithFormat:@"Score: %d</br>",[self.frameGraphView getPointsInASingleFrame:self.matchData :1 :frameIndex+1]];
        scorePlayer2 = [NSString stringWithFormat:@"Score: %d</br>",[self.frameGraphView getPointsInASingleFrame:self.matchData :2 :frameIndex+1]];

        dataPlayer1 = [self composePlayerStatsForFrame:1 :frameIndex+1];
        dataPlayer2 = [self composePlayerStatsForFrame:2 :frameIndex+1];
        
        
        tableDetail = [NSString stringWithFormat:@"%@%@<tr><td>%@</td><td>%@</td></tr><tr><td valign='top'>%@</td><td valign='top'>%@</td></tr>", tableDetail,dataFrameHeader,scorePlayer1,scorePlayer2,dataPlayer1,dataPlayer2];
    }
    NSString *tableFooter = @"</table>";
    NSString *data = [NSString stringWithFormat:@"%@%@%@%@",matchheader, tableHeader, tableDetail, tableFooter];
    return data;
}




-(ball*)findBall:(int)selectedBall {
    if (selectedBall == 1) {
        return self.buttonRed;
    } else if (selectedBall == 2) {
        return self.buttonYellow;
    } else if (selectedBall == 3) {
        return self.buttonGreen;
    } else if (selectedBall == 4) {
        return self.buttonBrown;
    }else if (selectedBall == 5) {
        return self.buttonBlue;
    }else if (selectedBall == 6) {
        return self.buttonPink;
    }else {
        return self.buttonBlack;
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showAdjustNumberPicker"]){
        AdjustPointsViewController *controller = (AdjustPointsViewController *)segue.destinationViewController;
        controller.delegate = self;
        controller.sumOfPlayerFouls = self.currentPlayer.currentFrame.foulScore;
        controller.ballIndex = self.buttonRed.quantity+self.buttonYellow.quantity+self.buttonGreen.quantity+self.buttonBrown.quantity+self.buttonBlue.quantity+self.buttonPink.quantity+self.buttonBlack.quantity;
        controller.advancedCounting = self.advancedCounting;
        
        if (self.currentPlayer == self.textScorePlayer1) {
            controller.playerName = self.textPlayerOneName.text;
        } else {
            controller.playerName = self.textPlayerTwoName.text;
        }
    }
}


- (void)addItemViewController:(AdjustPointsViewController *)controller didPickDeduction:(int)selectedPoints {
    [self.currentPlayer setFoulScore:selectedPoints];
}


- (void)addItemViewController:(AdjustPointsViewController *)controller didPickBallAdjust:(int)ballIndex {
    ball* currentBall;
    
    
    if (ballIndex > 6) {
        currentColour = 1;
        colourQuantityAtStartOfBreak = ballIndex - 6;
        
    } else {
        currentColour = 8 - ballIndex;
        colourQuantityAtStartOfBreak = 1;
    }
    
    // disable all ball buttons
    for (int i = 1; i <= 7; i++)
    {
        currentBall = [self findBall:i];
        currentBall.enabled = false;
        currentBall.quantity = 0;
        
    }
    
    // reset ball buttons required in reverse order!
    for (int i = 7; i >= currentColour; i--)
    {
        currentBall = [self findBall:i];
        if (i==1) {
            currentBall.enabled = true;
            currentBall.quantity = colourQuantityAtStartOfBreak;
        } else {
            currentBall.enabled = true;
            currentBall.quantity = 1;
        }
    }
}






- (IBAction)switchChanged:(id)sender {
    
    if ([self.switchFoul isOn] ) {
        self.foulLabel.hidden = false;
        
    } else {
        self.foulLabel.hidden = true;
    }
    
    
}



-(void)selectStatPlayerOneTap:(UITapGestureRecognizer *)gesture
{
    self.statPlayer1item++;
    if (self.statPlayer1item==5) {
        self.statPlayer1item=1;
    }
    
        self.statContentLabelPlayer1.text = [self getFrameBreakdown :1 :[self.frameGraphView frameData] :@"\n" :self.statPlayer1item];
    
}


-(void)selectStatPlayerTwoTap:(UITapGestureRecognizer *)gesture
{
    self.statPlayer2item++;
    if (self.statPlayer2item==5) {
        self.statPlayer2item=1;
    }
        self.statContentLabelPlayer2.text = [self getFrameBreakdown :2 :[self.frameGraphView frameData] :@"\n" :self.statPlayer2item];
    }



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.frameGraphView visitNumberOfBalls];
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    // missing foul detail and also player..
    
    if (self.frameGraphView.visitBallCollection.count >0) {
    
        UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:102];
        UILabel *ballLabel = (UILabel *)[cell viewWithTag:103];
        ball *selectedBall = [self.frameGraphView.visitBallCollection objectAtIndex:indexPath.row];

        NSNumber *isfoul = [self.frameGraphView visitIsFoul];
        
        NSString *points;
        if ([isfoul intValue] == 0  ) {
            points = [NSString stringWithFormat:@"%d",selectedBall.pottedPoints];
        }
        else {
            points = [NSString stringWithFormat:@"%d",selectedBall.foulPoints];
        }
        
        ballLabel.text = points;
        
        if (selectedBall.pottedPoints==1) {
            collectionImageView.image = [UIImage imageNamed:@"ball_largex_red01.png"];
        } else if (selectedBall.pottedPoints==2) {
            collectionImageView.image = [UIImage imageNamed:@"ball_largex_yellow02.png"];
        } else if (selectedBall.pottedPoints==3) {
            collectionImageView.image = [UIImage imageNamed:@"ball_largex_green03.png"];
        } else if (selectedBall.pottedPoints==4) {
            collectionImageView.image = [UIImage imageNamed:@"ball_largex_brown04.png"];
        } else if (selectedBall.pottedPoints==5) {
            collectionImageView.image = [UIImage imageNamed:@"ball_largex_blue05.png"];
        } else if (selectedBall.pottedPoints==6) {
            collectionImageView.image = [UIImage imageNamed:@"ball_largex_pink06.png"];
        } else {
        collectionImageView.image = [UIImage imageNamed:@"ball_largex_black07.png"];
        }
        
        

    }
    //cell.backgroundColor=[UIColor greenColor];
    return cell;
    
    
}


- (IBAction)clearClicked:(id)sender {
    ball* currentBall;
    
    if (self.isButtonStateClear) {
        // Clear current break process - some updates needed here perhaps...?
        if (self.currentPlayersBreak.breakScore > 0) {
            
            [self.currentPlayer setNbrBallsPotted:(self.currentPlayer.nbrBallsPotted - (int)self.currentPlayersBreak.pottedBalls.count)];
            
            self.currentPlayer.currentFrame.frameBallsPotted -= (int)self.currentPlayersBreak.pottedBalls.count;
            
            [self.currentPlayersBreak clearBreak:self.imagePottedBall];
            [self clearIndicators :hide];
            
            // reset counters impacted!
            for (int i = colourStateAtStartOfBreak; i <= currentColour; i++)
            {
                currentBall = [self findBall:i];
                
                if (i==1) {
                    currentBall.quantity=colourQuantityAtStartOfBreak;
                    currentBall.enabled = true;
                } else {
                    currentBall.quantity=1;
                    currentBall.enabled = true;
                    
                }
                
            }
            currentColour = colourStateAtStartOfBreak;
            self.buttonAdjust.hidden = false;
            [self.buttonClear setTitle:@"Undo" forState:UIControlStateNormal];
            self.isButtonStateClear = false;
            //self.buttonClear.hidden = true;
        }
        
    } else {
        // undo last entry
        
        
        if (self.frameGraphView.frameData.count == 0 ) {
                // nothing to do!
            
            
            NSString *alertMessage;
            NSString *titleMessage;

            titleMessage = @"Nothing to do!";
            alertMessage = @"No entries to undo in current frame";
            
            self.alertOkNotification = [[UIAlertView alloc] initWithTitle:titleMessage message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            self.alertOkNotification.alertViewStyle = UIAlertViewStyleDefault ;
            [self.alertOkNotification show];
            
        } else {
            NSMutableDictionary *lastEntryData = [[NSMutableDictionary alloc] init];
            lastEntryData = [self.frameGraphView.frameData objectAtIndex:self.frameGraphView.frameData.count - 1];
            NSString *visitPlayerName;
            NSNumber *visitPlayerIndex = [lastEntryData valueForKey:@"player"];
            NSNumber *visitIsFoul = [lastEntryData valueForKey:@"isfoul"];
            //NSString *visitTimeStamp = [lastEntryData valueForKey:@"datestamp"];
            
            int visitBreakAmount = [self.frameGraphView getBreakAmountFromBalls:[lastEntryData valueForKey:@"ballTransaction"] :visitIsFoul] ;
            
            if ([visitPlayerIndex intValue]==1) {
                visitPlayerName = self.textPlayerOneName.text;
            } else {
                visitPlayerName = self.textPlayerTwoName.text;
            }
            
            
            
            NSString *alertMessage;
            NSString *titleMessage;
            
            if ([visitIsFoul intValue] == 0) {
            
            titleMessage = @"Undo Break";
            
            alertMessage = [NSString stringWithFormat:@"You can either undo %@'s entry of %d points or the whole frame if you want a rerack.  Alternatively you may wish to press cancel if this was a mistake.",visitPlayerName,  visitBreakAmount];
            
            } else {
                
                titleMessage = @"Undo Foul";
                
                alertMessage = [NSString stringWithFormat:@"You can either undo the foul points of %d received by %@ or the whole frame if you want a rerack.  Alternatively you may wish to press cancel if this was a mistake.",visitBreakAmount,visitPlayerName];
            }
            
            
            
            self.alertUndoEntry = [[UIAlertView alloc] initWithTitle:titleMessage message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Last Entry", @"Rerack", nil];
            self.alertUndoEntry.alertViewStyle = UIAlertViewStyleDefault ;
            [self.alertUndoEntry show];
        }
        
    }
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == self.alertEndScores) {
        if (buttonIndex == 1) {
            [self endMatch];
        }
    } else if (alertView==self.alertUndoEntry) {
        if (buttonIndex == 1) {
            //undo last entry!
            [self.frameGraphView.frameData removeObjectAtIndex:self.frameGraphView.frameData.count - 1];
            // now we need to update the items impacted!!!
            
            [self.textScorePlayer1 updateFrameScore:[self.frameGraphView getPointsInFrame:[self.frameGraphView frameData]:1]];
            [self.textScorePlayer2 updateFrameScore:[self.frameGraphView getPointsInFrame:[self.frameGraphView frameData]:2]];
            [self selectPlayerOne];

  
        } else if (buttonIndex == 2) {
            //rerack!
            [self.frameGraphView.frameData removeAllObjects];
            // now we need to tidy up!!
            [self.textScorePlayer1 updateFrameScore:0];
            [self.textScorePlayer2 updateFrameScore:0];
            [self selectPlayerOne];
            
        }
    }
}


-(int)getMatchVisits :(int)playerIndex {
    int totalVisits = 0;
    //match array
    totalVisits = [self.frameGraphView getAmountOfVisitsInFrame:self.matchData :playerIndex];
    // current frame array
    totalVisits += [self.frameGraphView getAmountOfVisitsInFrame:[self.frameGraphView frameData] :playerIndex];
    return totalVisits;
}



-(int)getMatchBallsPotted :(int)playerIndex {
    int totalBallsPotted = 0;
    //match array
    totalBallsPotted = [self.frameGraphView getAmountOfBallsPottedInFrame:self.matchData :playerIndex :0];
    // current frame array
    totalBallsPotted += [self.frameGraphView getAmountOfBallsPottedInFrame:[self.frameGraphView frameData] :playerIndex :0];
    return totalBallsPotted;
}



-(float)getAverageBreakAmountInMatch :(int)playerIndex {
    int totalPottedPoints = 0;
    int totalVisits = 0;
    
    totalPottedPoints = [self.frameGraphView getPointsByTypeInFrame:self.matchData :playerIndex :0 :0] + [self.frameGraphView getPointsByTypeInFrame:[self.frameGraphView frameData] :playerIndex :0 :0];
    
    totalVisits = [self.frameGraphView getAmountOfVisitsInFrame:self.matchData :playerIndex] + [self.frameGraphView getAmountOfVisitsInFrame:[self.frameGraphView frameData] :playerIndex];
    
    float avgAmount = 0.0;
    
    avgAmount = (float)totalPottedPoints / (float)totalVisits;
    
    if isnan(avgAmount) {
        avgAmount=0.0;
    }

    return avgAmount;
}


-(int)getMatchHighestBreak :(int)playerIndex {
    int highestBreakInMatch = 0;
    //match array

    int highestBreakInFrame = [self.frameGraphView getHighestBreakAmountInFrame:self.matchData :playerIndex :0];
        
    if (highestBreakInFrame > highestBreakInMatch) {
        highestBreakInMatch = highestBreakInFrame;
    }
    // current frame array
    int highestBreakInCurrentFrame = [self.frameGraphView getHighestBreakAmountInFrame:[self.frameGraphView frameData] :playerIndex :0];
    
    if (highestBreakInCurrentFrame > highestBreakInMatch) {
        highestBreakInMatch = highestBreakInCurrentFrame;
    }

    return highestBreakInMatch;
}

@end
