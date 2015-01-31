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
@property (weak, nonatomic) IBOutlet UILabel *statNameLabelPlayer1;
@property (weak, nonatomic) IBOutlet UILabel *statNameLabelPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *statContentLabelPlayer2;
@property (weak, nonatomic) IBOutlet UIView *PlayerStatsView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navButtonNew;
@property (weak, nonatomic) IBOutlet UILabel *frameInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonClear;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdjust;
@property (weak, nonatomic) IBOutlet UIView *disabledView;
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
@synthesize currentColour;
@synthesize colourStateAtStartOfBreak;
@synthesize colourQuantityAtStartOfBreak;

@synthesize ballReplaced;
enum scoreStatus { FrameScore, FrameHighestBreak, HighestBreak, FrameBallsPotted, BallsPotted };
enum scoreStatus scoreState;
enum IndicatorStyle {highlight, hide};

#pragma mark -standard methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    
    UITapGestureRecognizer *endBreakTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(endBreakTap:)];
    endBreakTap.numberOfTapsRequired = 1;
    [self.viewBreak addGestureRecognizer:endBreakTap];
    

    UITapGestureRecognizer *tapHideStats = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(tapHidePlayersStats:)];
    tapHideStats.numberOfTapsRequired = 1;
    [self.PlayerStatsView addGestureRecognizer:tapHideStats];
    
    
    
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
    [self.textScorePlayer1 createFrame:(self.frameNumber)];
    [self.textScorePlayer2 createFrame:(self.frameNumber)];
    
    self.joinedFrameResult = [[NSMutableArray alloc] init];
    
    
    
}

-(void)swipeRightShowPlayersStats:(UISwipeGestureRecognizer *)gesture
{
    self.navButtonNew.title  = @"";
    self.navButtonNew.enabled=false;
    
    
  //  NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
  //  self.statNameLabelPlayer1.attributedText = [[NSAttributedString alloc] initWithString:self.textPlayerOneName.text attributes:underlineAttribute];
  //  self.statNameLabelPlayer2.attributedText = [[NSAttributedString alloc] initWithString:self.textPlayerTwoName.text attributes:underlineAttribute];
    
    
    
    self.statNameLabelPlayer1.Text = self.textPlayerOneName.text ;
    self.statNameLabelPlayer2.Text = self.textPlayerTwoName.text ;
    
    
    self.statContentLabelPlayer1.text = [self getBreakdown :self.textScorePlayer1 :@"\n"];

    self.statContentLabelPlayer2.text = [self getBreakdown :self.textScorePlayer2 :@"\n"];
    
    self.playerStatsPosition.constant=0;
    
    self.frameInfo.text = [self getFrameBoxInfo];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.PlayerStatsView layoutIfNeeded];
    }];
    
    self.disabledView.hidden=false;
    
}

-(void)tapHidePlayersStats:(UISwipeGestureRecognizer *)gesture
{
    [self hidePlayersStats];
}

-(void)swipeLeftHidePlayersStats:(UISwipeGestureRecognizer *)gesture
{
    [self hidePlayersStats];
}

-(void)hidePlayersStats {
    
    self.playerStatsPosition.constant=-298;
    [UIView animateWithDuration:0.5f animations:^{
        [self.PlayerStatsView layoutIfNeeded];
    }];
    self.navButtonNew.title  = @"New";
    self.navButtonNew.enabled=true;
    self.disabledView.hidden=true;
    
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
    if ( [self.currentPlayer highestBreak] < [self.currentPlayersBreak breakScore] ) {
        [self.currentPlayer setHighestBreak:[self.currentPlayersBreak breakScore] :self.frameNumber :self.currentPlayersBreak.pottedBalls];
    }
    if (self.currentPlayer.currentFrame.frameHighestBreak < [self.currentPlayersBreak breakScore]) {
        [self.currentPlayer.currentFrame setFrameHighestBreak:[self.currentPlayersBreak breakScore] :self.frameNumber :self.currentPlayersBreak.pottedBalls];
    }
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
        self.buttonClear.hidden = false;
        
    }
    
    
    if ([self.switchFoul isOn] ) {
        [self closeBreak];
        // add the foul points to opposing player
        [self.opposingPlayer setFoulScore:pottedBall.foulPoints];
        [self.currentPlayersBreak clearBreak:self.imagePottedBall];
        [self.switchFoul setOn:false];
        self.foulLabel.hidden=true;
        [self swapPlayers];
        
    } else {

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
        [self processCurrentUsersHighestBreak];
        [self.currentPlayersBreak clearBreak:self.imagePottedBall];
        [self clearIndicators :hide];
        self.ballReplaced=false;
        self.buttonAdjust.hidden = false;
        self.buttonClear.hidden = true;
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
        scoreState = FrameHighestBreak;
        NSString *labelHighestBreak = [NSString stringWithFormat:@"%d",[self.currentPlayer.currentFrame frameHighestBreak]];
        self.textScorePlayer1.text  =labelHighestBreak;
        self.labelStatePlayer1.text = @"Frame Hi Break";
    } else if (scoreState == FrameHighestBreak && modified == false) {
        scoreState = HighestBreak;
        [self.currentPlayer displayHighestBreak];
        self.labelStatePlayer1.text = @"Match Hi Break";
    } else if (scoreState == HighestBreak && modified == false) {
        scoreState = FrameBallsPotted;
        NSString *labelFrameBallsPotted = [NSString stringWithFormat:@"%d",[self.currentPlayer.currentFrame frameBallsPotted]];
        self.textScorePlayer1.text = labelFrameBallsPotted;
        self.labelStatePlayer1.text = @"Frame Potted";
    } else if (scoreState == FrameBallsPotted && modified == false) {
        scoreState = BallsPotted;
        [self.currentPlayer displayBallsPotted];
        self.labelStatePlayer1.text = @"Match Potted";
    } else if (scoreState == BallsPotted && modified == false) {
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
        scoreState = FrameHighestBreak;
        NSString *labelHighestBreak = [NSString stringWithFormat:@"%d",[self.currentPlayer.currentFrame frameHighestBreak]];
        self.textScorePlayer2.text = labelHighestBreak;
        self.labelStatePlayer2.text = @"Frame Hi Break";
        
    } else if (scoreState == FrameHighestBreak && modified == false) {
        scoreState = HighestBreak;
        [self.currentPlayer displayHighestBreak];
        self.labelStatePlayer2.text = @"Match Hi Break";
    } else if (scoreState == HighestBreak && modified == false) {
        scoreState = FrameBallsPotted;
        NSString *labelFrameBallsPotted = [NSString stringWithFormat:@"%d",[self.currentPlayer.currentFrame frameBallsPotted]];
        self.textScorePlayer2.text = labelFrameBallsPotted;
        self.labelStatePlayer2.text = @"Frame Potted";
    } else if (scoreState == FrameBallsPotted && modified == false) {
        scoreState = BallsPotted;
        [self.currentPlayer displayBallsPotted];
        self.labelStatePlayer2.text = @"Match Potted";
    } else if (scoreState == BallsPotted && modified == false) {
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
        
    
    UIAlertView *alertEndScores = [[UIAlertView alloc] initWithTitle:titleMessage message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    alertEndScores.alertViewStyle = UIAlertViewStyleDefault ;
    [alertEndScores addButtonWithTitle:@"Go"];
    [alertEndScores show];
    
    
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self endMatch];
    }
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
    self.buttonClear.hidden = true;
    
    [self resetBalls];
}



-(NSString*) composePlayerStats :(frame*) currentFrame  {
    /* content within each table detail */
    NSString *hiBreakPlayer = [NSString stringWithFormat:@"</br>Highest Break: %d</br>",currentFrame.frameHighestBreak];
    NSString *bonusPoints = [NSString stringWithFormat:@"</br>Bonus Points: %d",currentFrame.foulScore];
    NSString *PottedPoints = [NSString stringWithFormat:@"</br>Potted Points: %d ",currentFrame.frameScore - currentFrame.foulScore];
    
    NSString *hiBreakBallsPlayer = @"(";
    NSString *hiBreakBallsImagePlayer  = @"</br>";

    for (ball *ballObj in currentFrame.frameHighestBreakHistory) {
        UIImage *emailImage = [UIImage imageNamed:ballObj.imageNameSmall];
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(emailImage)];
    
        NSString *base64String = [imageData base64EncodedStringWithOptions:0 ];
        NSString *ballImageData = [NSString stringWithFormat:@"<img src='data:image/png;base64,%@'>",base64String];
        hiBreakBallsPlayer = [NSString stringWithFormat:@"%@%@->",hiBreakBallsPlayer, ballObj.colour];
        hiBreakBallsImagePlayer = [NSString stringWithFormat:@"%@%@",hiBreakBallsImagePlayer, ballImageData];
    }
    
    
    NSString *ballsPotted = [NSString stringWithFormat:@"</br>Total Pots: %d</br>",currentFrame.frameBallsPotted ];
    NSString *dataPlayer = [NSString stringWithFormat:@"%@%@%@%@%@END)%@",ballsPotted, PottedPoints, bonusPoints, hiBreakPlayer, hiBreakBallsPlayer,hiBreakBallsImagePlayer];
    return dataPlayer;
}



-(NSString*) getBreakdown :(player*) currentPlayerStats :(NSString*) lineBreak {
    
    long breakValue;
    int counter8To9=0, counter10To19=0, counter20To29=0, counter30To39=0, counter40To49=0, counter50To59=0, counter60To69=0, counter70To79=0, counter80To89=0, counter90To99=0, counter100To109=0, counter110To119=0, counter120To129=0, counter130To139=0, counter140to147=0;
    long playersHighestBreak=0;
    
    for (int index=0; index < [currentPlayerStats.playersBreaks count]; index++) {
 
        breakValue = [[currentPlayerStats.playersBreaks objectAtIndex:index] integerValue];
        
        if (breakValue > playersHighestBreak) {
            playersHighestBreak = breakValue;
        }
        
        if (breakValue >=140) {
            counter140to147 ++;
        } else if (breakValue >=130) {
            counter130To139 ++;
        } else if (breakValue >= 120) {
            counter120To129 ++;
        } else if (breakValue >= 110) {
            counter110To119 ++;
        } else if (breakValue >= 100) {
            counter100To109 ++;
        } else if (breakValue >= 90) {
            counter90To99 ++;
        } else if (breakValue >= 80) {
            counter80To89 ++;
        } else if (breakValue >= 70) {
            counter70To79 ++;
        } else if (breakValue >= 60) {
            counter60To69 ++;
        } else if (breakValue >= 50) {
            counter50To59 ++;
        } else if (breakValue >= 40) {
            counter40To49 ++;
        } else if (breakValue >= 30) {
            counter30To39 ++;
        } else if (breakValue >= 20) {
            counter20To29 ++;
        } else if (breakValue >= 10) {
            counter10To19 ++;
        } else if (breakValue >= 8) {
            counter8To9 ++;
        }
    }

    int maxNbrOfRanges = 4;
    int nbrOfRanges = 0;
    float avgPlayer = 0.0;
    
    avgPlayer = (float)currentPlayerStats.sumOfBreaks / (float)currentPlayerStats.nbrOfBreaks;
    
    if isnan(avgPlayer) {
        avgPlayer=0.0;
    }
    
    NSString *dataAvgPlayer = [NSString stringWithFormat:@"Average Break = %0.2f", avgPlayer];
    
    NSString *dataNbrOfPots = [NSString stringWithFormat:@"Number of Pots = %d%@", currentPlayerStats.nbrBallsPotted,lineBreak];
    
    NSString *dataScoringVisits = [NSString stringWithFormat:@"Scoring Visits = %d%@", currentPlayerStats.nbrOfBreaks,lineBreak];
    
    
    NSString *result = [NSString stringWithFormat:@"Highest Break = %ld%@%@%@%@%@%@",playersHighestBreak,lineBreak,dataAvgPlayer,lineBreak,dataNbrOfPots,dataScoringVisits,lineBreak];
    
    NSString *breakstats = @"";
    
    
    if (counter140to147 > 0) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 140 = %d%@",breakstats, counter140to147,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter130To139 > 0) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 130 = %d%@",breakstats, counter130To139,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter120To129 > 0) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 120 = %d%@",breakstats, counter120To129,lineBreak];
        nbrOfRanges ++;
    }
    
    
    if (counter110To119 > 0) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 110 = %d%@",breakstats, counter110To119,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter100To109 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 100 = %d%@",breakstats, counter100To109,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter90To99 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 90 = %d%@",breakstats, counter90To99,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter80To89 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 80 = %d%@",breakstats, counter80To89,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter70To79 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 70 = %d%@",breakstats, counter70To79,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter60To69 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 60 = %d%@",breakstats, counter60To69,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter50To59 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 50 = %d%@",breakstats, counter50To59,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter40To49 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 40 = %d%@",breakstats, counter40To49,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter30To39 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 30 = %d%@",breakstats, counter30To39,lineBreak];
        nbrOfRanges ++;
    }
  
    if (counter20To29 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 20 = %d%@",breakstats, counter20To29,lineBreak];
        nbrOfRanges ++;
    }
    
    if (counter10To19 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 10 = %d%@",breakstats, counter10To19,lineBreak];
        nbrOfRanges ++;
    }
    
    
    if (counter8To9 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 7 = %d%@",breakstats, counter8To9,lineBreak];
        nbrOfRanges ++;
    }
    
    
    if([breakstats isEqualToString:@""]) {
        breakstats = @"Player has not yet had any breaks of note!";
    }
    
    return [NSString stringWithFormat:@"%@%@",result,breakstats];
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
    frameScorePlayer1 = self.textScorePlayer1.frameScore;
    frameScorePlayer2 = self.textScorePlayer2.frameScore;
    
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
    
    NSString *tableHeader = [NSString stringWithFormat: @"<table bgcolor='#F8F8FF' border=0 cellpadding='10'><tr><td width=50%% valign='top'><h2>%@:%d</h2>%@</td><td width=50%% valign='top'><h2>%@:%d</h2>%@</td></tr>",self.textPlayerOneName.text, self.labelScoreMatchPlayer1.matchScore, [self getBreakdown :self.textScorePlayer1 :@"</br>"], self.textPlayerTwoName.text, self.labelScoreMatchPlayer2.matchScore, [self getBreakdown :self.textScorePlayer2 :@"</br>"]];
    
    NSString *dataFrameHeader =@"";
    NSString *tableDetail = @"";
    NSString *dataPlayer1;
    NSString *dataPlayer2;
    NSString *scorePlayer1;
    NSString *scorePlayer2;
    
    for (int frameIndex = 0; frameIndex < self.textScorePlayer1.frames.count; frameIndex++) {
        dataFrameHeader = [NSString stringWithFormat:@"<tr><td><h3>Frame no%d</h3></td><td></td></tr>",frameIndex+1];
        
        scorePlayer1 = [NSString stringWithFormat:@"Score: %d</br>",[[self.textScorePlayer1.frames objectAtIndex:frameIndex] frameScore]];
        scorePlayer2 = [NSString stringWithFormat:@"Score: %d</br>",[[self.textScorePlayer2.frames objectAtIndex:frameIndex] frameScore]];
        
        dataPlayer1 = [self composePlayerStats:[self.textScorePlayer1.frames objectAtIndex:frameIndex] ];
        dataPlayer2 = [self composePlayerStats:[self.textScorePlayer2.frames objectAtIndex:frameIndex] ];
        
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

- (IBAction)clearClicked:(id)sender {
    ball* currentBall;
    
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
        self.buttonClear.hidden = true;
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





@end
