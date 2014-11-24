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

@end




@implementation matchview 
@synthesize joinedFrameResult;
@synthesize frameNumber;
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
    self.buttonYellow.imageNameLarge = @"ball_large_yellow02.png";
    self.buttonYellow.imageNameSmall = @"ball_small_yellow02.png";
    
    self.buttonGreen.colour = @"Green";
    self.buttonGreen.foulPoints = 4;
    self.buttonGreen.pottedPoints = 3;
    self.buttonGreen.imageNameLarge = @"ball_large_green03.png";
    self.buttonGreen.imageNameSmall = @"ball_small_green03.png";

    self.buttonBrown.colour = @"Brown";
    self.buttonBrown.foulPoints = 4;
    self.buttonBrown.pottedPoints = 4;
    self.buttonBrown.imageNameLarge = @"ball_large_brown04.png";
    self.buttonBrown.imageNameSmall = @"ball_small_brown04.png";
    
    self.buttonBlue.colour = @"Blue";
    self.buttonBlue.foulPoints = 5;
    self.buttonBlue.pottedPoints = 5;
    self.buttonBlue.imageNameLarge = @"ball_large_blue05.png";
    self.buttonBlue.imageNameSmall = @"ball_small_blue05.png";
    
    self.buttonPink.colour = @"Pink";
    self.buttonPink.foulPoints = 6;
    self.buttonPink.pottedPoints = 6;
    self.buttonPink.imageNameLarge = @"ball_large_pink06.png";
    self.buttonPink.imageNameSmall = @"ball_small_pink06.png";
    
    self.buttonBlack.colour = @"Black";
    self.buttonBlack.foulPoints = 7;
    self.buttonBlack.pottedPoints = 7;
    self.buttonBlack.imageNameLarge = @"ball_large_black07.png";
    self.buttonBlack.imageNameSmall = @"ball_small_black07.png";
    
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
    swipeRight.numberOfTouchesRequired = 1;//give required num of touches here ..
    swipeRight.delegate = (id)self;
    swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    self.frameNumber=1;
    [self.textScorePlayer1 createFrame:(self.frameNumber)];
    [self.textScorePlayer2 createFrame:(self.frameNumber)];
    
    self.joinedFrameResult = [[NSMutableArray alloc] init];
    
}

//to do - hide/show switch around!


-(void)swipeRightShowPlayersStats:(UISwipeGestureRecognizer *)gesture
{
    self.playerStatsPosition.constant=-198;
    [UIView animateWithDuration:0.5f animations:^{
        [self.PlayerStatsView layoutIfNeeded];
    }];
}

-(void)tapHidePlayersStats:(UISwipeGestureRecognizer *)gesture
{
    self.playerStatsPosition.constant=-198;
    [UIView animateWithDuration:0.5f animations:^{
        [self.PlayerStatsView layoutIfNeeded];
    }];
}
    

-(void)swipeLeftHidePlayersStats:(UISwipeGestureRecognizer *)gesture
{
    self.statNameLabelPlayer1.text = self.textPlayerOneName.text;
    self.statContentLabelPlayer1.text = [self getBreakdown :self.textScorePlayer1];
    self.statNameLabelPlayer2.text = self.textPlayerTwoName.text;
    self.statContentLabelPlayer2.text = [self getBreakdown :self.textScorePlayer2];
    self.playerStatsPosition.constant=0;
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.PlayerStatsView layoutIfNeeded];
    }];
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
    }
    
    if ([self.switchFoul isOn] ) {
        
        [self processCurrentUsersHighestBreak];
  
        
        // if user is inside a break when they foul
        if (self.currentPlayersBreak.breakScore>0) {
            // not sure if the balls potted needs to be incremented here..
            [self.currentPlayer incrementNbrBalls:1];
            [self.currentPlayer setFrameScore:self.currentPlayersBreak.breakScore];
            [self.currentPlayer.currentFrame incrementFrameBallsPotted];
            [self clearIndicators :hide];
        }
        // add the foul points to opposing player
        [self.opposingPlayer setFoulScore:pottedBall.foulPoints];
        [self.currentPlayersBreak clearBreak:self.imagePottedBall];
        [self.switchFoul setOn:false];
        [self swapPlayers];
    } else {
        // it is a pot, so credit the current user
        [self.currentPlayersBreak incrementScore:pottedBall :self.imagePottedBall ];
        [self.currentPlayer incrementNbrBalls:1];
        [self.currentPlayer.currentFrame incrementFrameBallsPotted];
        //[pottedBall decreaseQty];
        pottedBall.potsInBreakCounter ++;
        indicatorBall.text = [NSString stringWithFormat:@"%d",pottedBall.potsInBreakCounter];
        [self clearIndicators :highlight];
        [indicatorBall setFont:[UIFont boldSystemFontOfSize:14]];
        indicatorBall.textColor = [UIColor whiteColor];
        indicatorBall.hidden = false;
        
    }
    
    [self.currentPlayer.currentFrame increaseFrameScore:self.currentPlayer.frameScore];
    
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
        alertMessage = [NSString stringWithFormat:@"You won the match!\n %@ to %@\n\nNow send the results to anyone who may be interested.",self.labelScoreMatchPlayer1.text,self.labelScoreMatchPlayer2.text];
    } else if (self.labelScoreMatchPlayer1.matchScore < self.labelScoreMatchPlayer2.matchScore) {
        titleMessage = [NSString stringWithFormat:@"Congratulations %@",self.textPlayerTwoName.text];
        alertMessage = [NSString stringWithFormat:@"You won the match!\n %@ to %@\n\nNow send the results to anyone who may be interested.",self.labelScoreMatchPlayer1.text,self.labelScoreMatchPlayer2.text];

    } else {
       titleMessage = @"Match tied";
        alertMessage =[NSString stringWithFormat:@"Score was %@ to %@\n\nNow send the results to anyone who may be interested.",self.labelScoreMatchPlayer1.text,self.labelScoreMatchPlayer2.text];
    }
        
    
    UIAlertView *alertEndScores = [[UIAlertView alloc] initWithTitle:titleMessage message:alertMessage delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    alertEndScores.alertViewStyle = UIAlertViewStyleDefault ;
    [alertEndScores show];
    
    /* next part attempts to compose an email and offer the user to load recipients & send an email */
    BOOL ok = [MFMailComposeViewController canSendMail];
    if (!ok) return;
    
    NSString *body = [self composeMessage];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
    MFMailComposeViewController* snookerScorerMailComposer = [MFMailComposeViewController new];
    snookerScorerMailComposer.mailComposeDelegate = self;
    [snookerScorerMailComposer setSubject:[NSString stringWithFormat:@"SnookerScorer - Matchday :%@", [DateFormatter stringFromDate:[NSDate date]]]];
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
    
    self.frameNumber=1;
    [self.joinedFrameResult removeAllObjects];
    
    self.textScorePlayer1.frameScore=0;
    self.textScorePlayer1.text=@"0";
    
    self.textScorePlayer2.frameScore=0;
    self.textScorePlayer2.text=@"0";
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



-(NSString*) getBreakdown :(player*) currentPlayerStats {
    
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
    
    NSString *result = [NSString stringWithFormat:@"Highest Break = %ld\n\n",playersHighestBreak];
    NSString *breakstats =@"";
    
    
    if (counter140to147 > 0) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 140 = %d\n",breakstats, counter140to147];
        nbrOfRanges ++;
    }
    
    if (counter130To139 > 0) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 130 = %d\n",breakstats, counter130To139];
        nbrOfRanges ++;
    }
    
    if (counter120To129 > 0) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 120 = %d\n",breakstats, counter120To129];
        nbrOfRanges ++;
    }
    
    
    if (counter110To119 > 0) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 110 = %d\n",breakstats, counter110To119];
        nbrOfRanges ++;
    }
    
    if (counter100To109 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 100 = %d\n",breakstats, counter100To109];
        nbrOfRanges ++;
    }
    
    if (counter90To99 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 90 = %d\n",breakstats, counter90To99];
        nbrOfRanges ++;
    }
    
    if (counter80To89 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 80 = %d\n",breakstats, counter80To89];
        nbrOfRanges ++;
    }
    
    if (counter70To79 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 70 = %d\n",breakstats, counter70To79];
        nbrOfRanges ++;
    }
    
    if (counter60To69 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 60 = %d\n",breakstats, counter60To69];
        nbrOfRanges ++;
    }
    
    if (counter50To59 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 50 = %d\n",breakstats, counter50To59];
        nbrOfRanges ++;
    }
    
    if (counter40To49 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 40 = %d\n",breakstats, counter40To49];
        nbrOfRanges ++;
    }
    
    if (counter30To39 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 30 = %d\n",breakstats, counter30To39];
        nbrOfRanges ++;
    }
  
    if (counter20To29 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 20 = %d\n",breakstats, counter20To29];
        nbrOfRanges ++;
    }
    
    if (counter10To19 > 0 && nbrOfRanges < maxNbrOfRanges) {
        breakstats = [NSString stringWithFormat:@"%@Breaks > 10 = %d\n",breakstats, counter10To19];
        nbrOfRanges ++;
    }
    
    
    if (counter8To9 > 0 && nbrOfRanges < maxNbrOfRanges) {
        result = [NSString stringWithFormat:@"%@Breaks > 7 = %d\n",result, counter8To9];
        nbrOfRanges ++;
    }
    
    
    if([breakstats isEqualToString:@""]) {
        breakstats = @"Player has not yet had any breaks of note!";
    }
    
    return [NSString stringWithFormat:@"%@%@",result,breakstats];
}


-(NSString*) composeMessage {
    
    NSString *matchheader = @"<h1>Match Statistics</h1>";
    NSString *matchJoinedResults =@"";
    
    for (NSMutableArray *obj in self.joinedFrameResult) {
        matchJoinedResults = [NSString stringWithFormat:@"%@  %@", matchJoinedResults, obj];
    }
    
    matchheader = [NSString stringWithFormat:@"%@</br>Scores:%@</br></br>",matchheader,matchJoinedResults];
    
    float avgPlayer;
    avgPlayer = (float)self.textScorePlayer1.sumOfBreaks / (float)self.textScorePlayer1.nbrOfBreaks;
    NSString *dataAvgPlayer1 = [NSString stringWithFormat:@"Average Break:%0.2f", avgPlayer];
    avgPlayer = (float)self.textScorePlayer2.sumOfBreaks / (float)self.textScorePlayer2.nbrOfBreaks;
    NSString *dataAvgPlayer2 = [NSString stringWithFormat:@"Average Break:%0.2f", avgPlayer];
    
    NSString *tableHeader = [NSString stringWithFormat: @"<table bgcolor='#F8F8FF' border=1 cellpadding='10'><tr><td width=50%%><h2>%@:%d</h2>%@</td><td width=50%%><h2>%@:%d</h2>%@</td></tr>",self.textPlayerOneName.text, self.labelScoreMatchPlayer1.matchScore, dataAvgPlayer1, self.textPlayerTwoName.text, self.labelScoreMatchPlayer2.matchScore, dataAvgPlayer2];
    
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

- (IBAction)clearClicked:(id)sender {
    if (self.currentPlayersBreak.breakScore > 0) {
        [self.currentPlayersBreak clearBreak:self.imagePottedBall];
        [self clearIndicators :hide];
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






@end
