//
//  matchStatisticsVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 15/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "embededMatchStatisticsVC.h"
#import "breakEntry.h"
#import "breakBallCell.h"

@interface embededMatchStatisticsVC () < UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate, graphViewDelegate>
@end



@implementation embededMatchStatisticsVC {
    UISwipeGestureRecognizer *swipeRight;
    enum themes {greenbaize, dark, modern};
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activeMatchData = [self.db entriesRetreive :self.m.matchid :nil :nil :nil :nil :nil :nil :true];
    self.breakShots = [[NSMutableArray alloc] init];
    NSData *pngdata;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    pngdata = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.p1.photoLocation]];
    
    UIImage *img = [UIImage imageWithData:pngdata];
    
    if (img==nil) {
        img = [UIImage imageNamed:@"avatar.png"];
    }

    [self.player1Photo setImage:img];
    
    self.player1Photo.frame = CGRectMake(self.player1Photo.frame.origin.x, self.player1Photo.frame.origin.y, 50, 50);
    self.player1Photo.clipsToBounds = YES;
    self.player1Photo.layer.cornerRadius = 50/2.0f;
    self.player1Photo.layer.borderWidth=3.0f;
    self.player1Photo.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    
    pngdata = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.p2.photoLocation]];
    
    img = [UIImage imageWithData:pngdata];
    
    if (img==nil) {
        img = [UIImage imageNamed:@"avatar.png"];
    }
    
    [self.player2Photo setImage:img];
    
    self.player2Photo.frame = CGRectMake(self.player2Photo.frame.origin.x, self.player2Photo.frame.origin.y, 50, 50);
    self.player2Photo.clipsToBounds = YES;
    self.player2Photo.layer.cornerRadius = 50/2.0f;
    self.player2Photo.layer.borderWidth=3.0f;
    self.player2Photo.layer.borderColor = [UIColor colorWithRed:255.0f/255.0f green:45.0f/255.0f blue:85.0f/255.0f alpha:1.0f].CGColor;
    
    self.player1Name.text=self.p1.nickName;
    self.player2Name.text=self.p2.nickName;
    
    
    self.graphStatisticView.overlay=false;
    self.graphStatisticsOverlayView.overlay=true;
    
    
    self.graphStatisticView.p1 = self.p1;
    self.graphStatisticView.p2 = self.p2;
    
    self.graphStatisticsOverlayView.p1 = self.p1;
    self.graphStatisticsOverlayView.p2 = self.p2;

    self.graphStatisticView.numberOfFrames=[self.m.Player1FrameWins intValue] + [self.m.Player2FrameWins intValue];
    
    if (self.activeMatchStatistcsShown)  {
        self.graphStatisticView.numberOfFrames ++;
        self.graphStatisticsOverlayView.numberOfFrames ++;
    }
    
    self.graphStatisticView.selectedData = self.activeMatchData;
    self.graphStatisticsOverlayView.selectedData = self.activeMatchData;
    
    if (self.graphStatisticView.numberOfFrames==0) {
        // maybe we have selected the current frame..
        breakEntry *stateOfSelectedMatch = [self.activeMatchData lastObject];
        if (stateOfSelectedMatch.active==[NSNumber numberWithInt:1]) {
            self.graphStatisticView.numberOfFrames = [stateOfSelectedMatch.frameid intValue];
                    } else if (stateOfSelectedMatch.active==[NSNumber numberWithInt:2] && self.activeMatchData.count>1) {
            self.graphStatisticView.numberOfFrames = [stateOfSelectedMatch.frameid intValue] - 1;
            
        }
        self.graphStatisticsOverlayView.numberOfFrames = self.graphStatisticView.numberOfFrames;
    }
    
    /* maximum stepper will be frame */
    self.graphStepper.maximumValue = self.graphStatisticView.numberOfFrames;
    
    if (self.activeMatchStatistcsShown) {
        self.borderLabel.hidden = false;
        
        swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightPopPlayersStats:)];
        swipeRight.numberOfTouchesRequired = 1;//give required num of touches here ..
        swipeRight.delegate = (id)self;
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeRight];
        self.graphStatisticView.matchStatistics=false;
        self.graphStatisticsOverlayView.matchStatistics=false;
        self.graphStepper.value = self.graphStatisticView.numberOfFrames;
    } else {
        self.graphStatisticView.matchStatistics=true;
        self.graphStatisticsOverlayView.matchStatistics=true;
        self.graphStepper.value = 0;
    }


    self.graphStatisticView.matchFramePoints = [[NSMutableArray alloc] init];
    self.graphStatisticView.frameData = [[NSMutableArray alloc] init];
    
    
    self.graphStatisticsOverlayView.matchFramePoints = [[NSMutableArray alloc] init];
    self.graphStatisticsOverlayView.frameData = [[NSMutableArray alloc] init];
    
    self.graphStepper.tintColor = [UIColor darkGrayColor];
 

    self.breakCollection.dataSource = self;
    self.breakCollection.delegate = self;

    
    self.p1HiBreakCollection.dataSource = self;
    self.p1HiBreakCollection.delegate = self;
    
    self.p2HiBreakCollection.dataSource = self;
    self.p2HiBreakCollection.delegate = self;
    
    
    [self reloadActiveGraph];
    
    /* set display as we expect it to be from last entry */
    int workerDisplayState = self.displayState;

    if (workerDisplayState>=4) {
        [self manageMoreBreak :true];
        workerDisplayState -= 4;
    }
    if (workerDisplayState>=2) {
        [self manageMorePlayer:self.player2StatView :[NSNumber numberWithInt:2] :2 :true];
        workerDisplayState -= 2;
    }
    if (workerDisplayState>=1) {
        [self manageMorePlayer:self.player1StatView :[NSNumber numberWithInt:1] :1 :true];
        workerDisplayState -= 1;
    }

    self.P2BreakInfo.hidden = true;
    self.p2BreakInfoBall.hidden = true;
    self.P1BreakInfo.hidden = true;
    self.p1BreakInfoBall.hidden = true;
    
    self.P1AmountBreak.hidden = false;
    self.P2AmountBreak.hidden = false;
    
    [self updateSummaryLabelContent :self.graphSummaryLabel];
    
    if (self.activeMatchStatistcsShown) {
        self.frameDuration = [common getFrameDuration :self.graphStatisticView.frameData];
        [self updateDurationVisitLabelContent:self.DurationVisitsLabel];
    }
    
    
    // some necessary formatting required of player stats
    
    [self.p1TopBreaks sizeToFit];
    [self.p2TopBreaks sizeToFit];
    
    self.redColour = [UIColor colorWithRed:174.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:1.0];
    
    self.yellowColour = [UIColor colorWithRed:255.0f/255.0f green:247.0f/255.0f blue:93.0f/255.0f alpha:1.0];
    self.greenColour = [UIColor colorWithRed:27.0f/255.0f green:84.0f/255.0f blue:27.0f/255.0f alpha:1.0];
    self.brownColour = [UIColor colorWithRed:80.0f/255.0f green:21.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    self.blueColour = [UIColor colorWithRed:39.0f/255.0f green:38.0f/255.0f blue:198.0f/255.0f alpha:1.0];
    self.pinkColour = [UIColor colorWithRed:201.0f/255.0f green:128.0f/255.0f blue:184.0f/255.0f alpha:1.0];
    self.blackColour = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    
    
    UIImage *changecolourimage = [[UIImage imageNamed:@"ios7-arrow-back-128-000000.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton setImage:changecolourimage forState:UIControlStateNormal];
    self.backButton.tintColor = [UIColor whiteColor];
    changecolourimage = [[UIImage imageNamed:@"ios7-arrow-forward-128-000000.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.forwardButton setImage:changecolourimage forState:UIControlStateNormal];
    self.forwardButton.tintColor = [UIColor whiteColor];
    
    
    if (self.theme == dark) {
        [self.view setBackgroundColor:[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0]];
        [self.graphStatisticView setBackgroundColor:[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0]];
    }
    
}

-(void)viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];

    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.delegate addItemViewController:self keepDisplayState:self.displayState];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)swipeRightPopPlayersStats:(UISwipeGestureRecognizer *)gesture {
    
    [self.delegate addItemViewController:self keepDisplayState:self.displayState];
    [self.navigationController popViewControllerAnimated:YES];
    
}


/* last modified 20160203 */
/* frame/match graph */

-(void)reloadActiveGraph {
    
    if (self.graphStepper.value==0.0f) {
        self.graphReferenceLabel.text = @"Match";
        self.graphStatisticView.graphReferenceId=0;
        
         self.graphStatisticsOverlayView.graphReferenceId=0;
        
        if (self.m.matchid == self.activeMatchPlayers.matchid) {
            self.player1Score.text = [NSString stringWithFormat:@"%@", self.activeMatchPlayers.Player1FrameWins];
            self.player2Score.text = [NSString stringWithFormat:@"%@", self.activeMatchPlayers.Player2FrameWins];
        } else {
            if (self.m.Player1FrameWins==nil) {
                self.player1Score.text = @"0";
            } else {
                self.player1Score.text = [NSString stringWithFormat:@"%@", self.m.Player1FrameWins];
            }
            if (self.m.Player2FrameWins==nil) {
                 self.player2Score.text = @"0";
            } else {
                self.player2Score.text = [NSString stringWithFormat:@"%@", self.m.Player2FrameWins];
            }
        }
        
        
    } else {
        self.graphStatisticView.graphReferenceId=self.graphStepper.value;
        
        self.graphStatisticsOverlayView.graphReferenceId=self.graphStepper.value;
        
        [self.graphStatisticView loadSharedData];
        [self.graphStatisticsOverlayView loadSharedData];
        
     
        if (self.graphStatisticView.graphReferenceId == self.graphStatisticView.numberOfFrames) {
            self.player1Score.text = [NSString stringWithFormat:@"%d", self.graphStatisticView.scorePlayer1+[self.p1.activeBreak intValue]];
            self.player2Score.text = [NSString stringWithFormat:@"%d", self.graphStatisticView.scorePlayer2+[self.p2.activeBreak intValue]];
            
        } else {
            self.player1Score.text = [NSString stringWithFormat:@"%d", self.graphStatisticView.scorePlayer1];
            self.player2Score.text = [NSString stringWithFormat:@"%d", self.graphStatisticView.scorePlayer2];
        }
        
        self.graphReferenceLabel.text = [NSString stringWithFormat:@"Frame no%d",self.graphStatisticView.graphReferenceId];
        
        
    }

    
    if (self.player2StatView.hidden == false) {
        [self loadPlayerStatistics:[NSNumber numberWithInt:2]];
        [self loadBreakBalls:[NSNumber numberWithInt:2]];
    }
    if (self.player1StatView.hidden == false) {
        [self loadPlayerStatistics:[NSNumber numberWithInt:1]];
        [self loadBreakBalls:[NSNumber numberWithInt:1]];
    }
    
    [self.graphStatisticView setNeedsDisplay];

}








/* player frame/match statistics */

-(void)loadBreakBalls :(NSNumber *) playerIndex {
    if (self.graphStatisticView.graphReferenceId>0) {
        if (playerIndex==[NSNumber numberWithInt:1]) {
            self.p1BreakBalls = [common getHiBreakBalls:[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        } else {
            self.p2BreakBalls = [common getHiBreakBalls:[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        }
    } else {

        if (playerIndex==[NSNumber numberWithInt:1]) {
            self.p1BreakBalls = [common getHiBreakBalls:self.activeMatchData :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        } else {
            self.p2BreakBalls = [common getHiBreakBalls:self.activeMatchData :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        }
    }
 
    if ([playerIndex intValue]==1) {

        [self.p1HiBreakCollection reloadData];
        [self.p1HiBreakCollection layoutIfNeeded];
    } else {

        [self.p2HiBreakCollection reloadData];
        [self.p2HiBreakCollection layoutIfNeeded];
    }
}




/* player frame/match statistics */

-(void)loadPlayerStatistics :(NSNumber *) playerIndex {
    
    
    int hibreak = [common getHiBreak :self.activeMatchData :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
    float avgbreak, avgball, avgShotTime;
    int redcount, yellowcount, greencount, browncount, bluecount, pinkcount, blackcount;
    NSString *potfouls, *topbreaks;
    
    //getTotalPottedPoints
    
    if (self.graphStatisticView.graphReferenceId>0) {
        redcount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:1]];
        yellowcount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:2]];
        greencount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:3]];
        browncount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:4]];
        bluecount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:5]];
        pinkcount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:6]];
        blackcount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:7]];
        avgbreak = [common getAvgBreakAmt :[self.graphStatisticView frameData] :playerIndex];
        avgball = [common getAvgBallAmt :[self.graphStatisticView frameData] :playerIndex];
        
        potfouls = [NSString stringWithFormat:@"%d : %d", [common getSumOfShotsByType :[self.graphStatisticView frameData] :playerIndex :Potted], [common getSumOfShotsByType :[self.graphStatisticView frameData] :playerIndex :Foul]];
        
        topbreaks = [common getTopRangeOfPlayerBreaks:[self.graphStatisticView frameData] :playerIndex];
        
        
        avgShotTime = [common getAvgShotDuration:[self.graphStatisticView frameData]  :playerIndex];
        
        
    } else {
        redcount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:1]];
        yellowcount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:2]];
        greencount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:3]];
        browncount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:4]];
        bluecount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:5]];
        pinkcount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:6]];
        blackcount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:7]];
        avgbreak = [common getAvgBreakAmt :self.activeMatchData :playerIndex];
        avgball = [common getAvgBallAmt :self.activeMatchData :playerIndex];
        
        potfouls = [NSString stringWithFormat:@"%d : %d", [common getSumOfShotsByType :self.activeMatchData :playerIndex :Potted], [common getSumOfShotsByType :self.activeMatchData :playerIndex :Foul]];
        topbreaks = [common getTopRangeOfPlayerBreaks:self.activeMatchData :playerIndex];
        avgShotTime = [common getAvgShotDuration:self.activeMatchData :playerIndex];
    }
    
    if ([playerIndex intValue]==1) {
        self.p1HiBreakLabel.text = [NSString stringWithFormat:@"%d",hibreak];
        self.p1AvgBreakLabel.text = [NSString stringWithFormat:@"%.02f",avgbreak];
        self.p1BallAvgLabel.text = [NSString stringWithFormat:@"%.02f",avgball];
        self.p1RedCountLabel.text = [NSString stringWithFormat:@"%d",redcount];
        self.p1YellowCountLabel.text = [NSString stringWithFormat:@"%d",yellowcount];
        self.p1GreenCountLabel.text = [NSString stringWithFormat:@"%d",greencount];
        self.p1BrownCountLabel.text = [NSString stringWithFormat:@"%d",browncount];
        self.p1BlueCountLabel.text = [NSString stringWithFormat:@"%d",bluecount];
        self.p1PinkCountLabel.text = [NSString stringWithFormat:@"%d",pinkcount];
        self.p1BlackCountLabel.text = [NSString stringWithFormat:@"%d",blackcount];
        self.p1SumPotsFouls.text = potfouls;
        self.p1TopBreaks.text = topbreaks;
        self.p1ShotAvgTimeLabel.text = [NSString stringWithFormat:@"%.02f",avgShotTime];
    } else {
        self.p2HiBreakLabel.text = [NSString stringWithFormat:@"%d",hibreak];
        self.p2AvgBreakLabel.text = [NSString stringWithFormat:@"%.02f",avgbreak];
        self.p2BallAvgLabel.text = [NSString stringWithFormat:@"%.02f",avgball];
        self.p2RedCountLabel.text = [NSString stringWithFormat:@"%d",redcount];
        self.p2YellowCountLabel.text = [NSString stringWithFormat:@"%d",yellowcount];
        self.p2GreenCountLabel.text = [NSString stringWithFormat:@"%d",greencount];
        self.p2BrownCountLabel.text = [NSString stringWithFormat:@"%d",browncount];
        self.p2BlueCountLabel.text = [NSString stringWithFormat:@"%d",bluecount];
        self.p2PinkCountLabel.text = [NSString stringWithFormat:@"%d",pinkcount];
        self.p2BlackCountLabel.text = [NSString stringWithFormat:@"%d",blackcount];
        self.p2SumPotsFouls.text = potfouls;
        self.p2TopBreaks.text = topbreaks;
        self.p2ShotAvgTimeLabel.text = [NSString stringWithFormat:@"%.02f",avgShotTime];
    }
 
}




- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (collectionView == self.p1HiBreakCollection) {
        return self.p1BreakBalls.count;
    }
    else if (collectionView == self.p2HiBreakCollection) {
        return self.p2BreakBalls.count;
    } else {
        return self.breakShotsCount;
    }
    
}

/* last modified 20160206 */
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (collectionView == self.p1HiBreakCollection) {
        /* player 1 highest break in current frame/match */
        
        breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"P1Cell" forIndexPath:indexPath];
        [[cell contentView] setFrame:[cell bounds]];
        cell.ball = [self.p1BreakBalls objectAtIndex:indexPath.row];
        
        if (!self.isHollow) {
            [cell setBorderWidth:0.0f];
        } else {
            [cell setBorderWidth:2.5f];
        }
        
        
        return cell;
        
    } else if (collectionView == self.p2HiBreakCollection) {
        /* player 2 highest break in current frame/match */
        
        breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"P2Cell" forIndexPath:indexPath];
        [[cell contentView] setFrame:[cell bounds]];
        cell.ball = [self.p2BreakBalls objectAtIndex:indexPath.row];
        
        if (!self.isHollow) {
            [cell setBorderWidth:0.0f];
        } else {
            [cell setBorderWidth:2.5f];
        }
        
        
        return cell;
        
    } else {
        /* player visit level */
        
        breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"breakCell" forIndexPath:indexPath];
        //[[cell contentView] setFrame:[cell bounds]];
        cell.ball = [self.breakShots objectAtIndex:indexPath.row];
        
        
        cell.ballStoreImage.highlightedImage = [UIImage imageNamed:@"selected.png"];

        if (!self.isHollow) {
            [cell setBorderWidth:0.0f];
        } else {
            [cell setBorderWidth:3.5f];
        }
        
        return cell;
        
    }


}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.breakCollection) {
        NSLog(@"clicked cell in breakCollection View");

       
        ballShot *ball = [self.breakShots objectAtIndex:indexPath.row];
        int currentRow = (int)indexPath.row;
        [self loadBall :ball :currentRow];
        
        
    }
}




/* last modified 20160714 */
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(breakBallCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.ballStoreImage.layer.borderColor = [self getColourFromBallName:cell.ball].CGColor;
    if (!self.isHollow) cell.ballStoreImage.backgroundColor = [self getColourFromBallName:cell.ball];
}


/* used by tweeting process to obtain break to share on twitter */
/* created 20150929 */
- (UIImage *) imageWithCollectionView:(UICollectionView *)collectionBreakView
{
    CGSize widthHeight = CGSizeMake(collectionBreakView.contentSize.width, collectionBreakView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(widthHeight, collectionBreakView.opaque, 0.0);
    [collectionBreakView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.breakCollection) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        float cellWidth = screenWidth / 10.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
        CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
    }
    else {
        /* return something back that is expected for other collection views */
        CGSize defaultSize = [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
        return defaultSize    ;
    }
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context
       withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    
    context.nextFocusedView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    
    //GameCell is a subclass of UICollectionViewCell
    if ([context.previouslyFocusedView isKindOfClass:[breakBallCell class]]) {
        context.previouslyFocusedView.layer.backgroundColor = self.breakCollection.backgroundColor.CGColor;
    }
}


/* visit level detail - displays balls in visit/break */

-(bool) loadBreakShots:(int) breakShotsIndex :(BOOL) fromGraph {
    // example.  need to obtain items ball count..
    
    int index = breakShotsIndex;

    if (self.graphStatisticView.frameData.count < breakShotsIndex) {
        index = (int)self.graphStatisticView.frameData.count;
    }
    if (index == 0) {
        return false;
    }
    
    if (self.player1StatView.hidden==false || self.player2StatView.hidden==false) {
        return false;
    }
    
    
    breakEntry *data = [self.graphStatisticView.frameData objectAtIndex:index-1];

    
    self.breakShots = data.shots;
    
    
    self.breakShotsCount = data.shots.count;
    self.breakShotsPlayerId = data.playerid;
    self.breakShotsType = data.lastshotid;
    
    if (self.breakShotsPlayerId==[NSNumber numberWithInt:1]) {
        self.P1AmountBreak.text = [NSString stringWithFormat:@"%@",data.points];
    } else {
        self.P2AmountBreak.text = [NSString stringWithFormat:@"%@",data.points];
    }
    
    
    
    if (self.breakShotsCount>1 && [self.breakShotsType integerValue] != Potted  ) {
        self.breakShotsType = [NSNumber numberWithInt:Potted];
    }

    self.breakShotsPoints = data.points;
    self.breakShotsReference = [NSString stringWithFormat:@"%d/%d",index,(int)self.activeFrameData.count];
    self.breakShotsIndex = index;
    if (fromGraph) {
        [self manageMoreBreak :false];
    }
    [self reloadGrid];
    
    NSLog(@"Tapped a bar with index %d, value", index);
    
    [self updateDurationVisitLabelContent :self.DurationVisitsLabel];
    
    return true;
}



/* visit level detail - displays balls in visit/break */
-(void)reloadGrid {
    
    NSString *typeOfPoints;
    
    NSNumber *shotId;
    shotId = self.breakShotsType;
    
    if ([shotId integerValue] == Potted) {
        typeOfPoints = @"break";
    } else if ([shotId integerValue] == Foul) {
        typeOfPoints = @"foul shot";
    } else if ([shotId integerValue] == Missed) {
        typeOfPoints = @"missed pot";
    } else if ([shotId integerValue] == Safety) {
        typeOfPoints = @"safety shot";
    } else if ([shotId integerValue] == Bonus) {
        typeOfPoints = @"bonus points";
    }
    
    int points = 0;
    if (self.breakShotsPoints != nil) {
        points = [self.breakShotsPoints intValue];
    }
    
    if (!self.graphStatisticsOverlayView.hidden) {
    if (self.breakShotsPlayerId==[NSNumber numberWithInt:1]) {
        self.player2View.hidden=true;
        self.player1View.hidden=false;
        
    } else {
        self.player2View.hidden=false;
        self.player1View.hidden=true;
    }
    
    }
    
    //self.visitDetailsLable.text = [NSString stringWithFormat:@"%@ %@ %d", playerName, typeOfPoints,points];
    //self.VisitPlayer.text = [NSString stringWithFormat:@"%@ : %@", [self.statsView visitRef], [self.statsView timeStamp]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Reload the respective collection view row using the main thread.
        [self.breakCollection reloadData];

        
        [self.view layoutIfNeeded];
        
    }];
    
   

}





-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)breakStatisticsPressed:(id)sender {
    
    [self manageMoreBreak :false];
    
    
}

/* frame level stepper to switch between each frame or match graph view */
/* last modified 20160206 */
- (IBAction)stepperChanged:(id)sender {
    [self reloadActiveGraph];
    
    [self loadBreakShots:1 :false];
    
    self.graphStatisticsOverlayView.plotHighlightIndex = 1;
    if (self.stepperFrame.value>0) {
        [self.graphStatisticsOverlayView loadSharedData];
        self.frameDuration = [common getFrameDuration :self.graphStatisticView.frameData];
    }
    [self.graphStatisticsOverlayView setNeedsDisplay];

        
    self.P2BreakInfo.hidden = true;
    self.p2BreakInfoBall.hidden = true;
    self.P1BreakInfo.hidden = true;
    self.p1BreakInfoBall.hidden = true;
        
    self.P1AmountBreak.hidden = false;
    self.P2AmountBreak.hidden = false;

    [self updateSummaryLabelContent :self.graphSummaryLabel];
    

    [self updateDurationVisitLabelContent :self.DurationVisitsLabel];
   
}



/* when a single frame graph is in view, user may press the frame detail */
-(void)manageMoreBreak :(bool)toload {

    if (self.player1StatView.hidden && self.player2StatView.hidden && self.stepperFrame.value>0) {
        if (!toload) {
            //self.overlayView.hidden = !self.overlayView.hidden;
            self.graphStatisticsOverlayView.hidden = !self.graphStatisticsOverlayView.hidden;
            self.background.hidden = !self.background.hidden;
            self.breakStatistcsView.hidden = !self.breakStatistcsView.hidden;
        } else {
            self.graphStatisticsOverlayView.hidden = false;
            self.background.hidden = false;
            self.breakStatistcsView.hidden = false;
        }
    
        if (self.graphStatisticsOverlayView.hidden == false) {
            
            [self.actionButton setImage:[UIImage imageNamed:@"tweet_black64x64.png"] forState:UIControlStateNormal];
            [self loadBreakShots:self.breakShotsIndex :false];
            
            self.stepperFrame.minimumValue=1;
            
            if (!toload) {
                self.displayState += 4;
            }
        } else {
            
            self.player2View.hidden=false;
            self.player1View.hidden=false;
            self.graphStatisticsOverlayView.hidden = true;
            self.background.hidden = true;
            self.breakStatistcsView.hidden = true;
            
            
            self.graphStatisticsOverlayView.hidden=true;
            [self.actionButton setImage:[UIImage imageNamed:@"export2.png"] forState:UIControlStateNormal];
            
            if (!toload) {
                self.displayState -= 4;
            }
            self.stepperFrame.minimumValue=0;
        }
    }
}



/* called when user presses more button for either player or when view is loaded */
-(void)manageMorePlayer:(UIView*) playerStat :(NSNumber*)playerId :(int)displayValue :(bool) toload {
    

    if (self.graphStatisticsOverlayView.hidden) {
        [self  loadPlayerStatistics:playerId];
        if (!toload) {
            playerStat.hidden = !playerStat.hidden;
        } else {
            [self loadBreakBalls:playerId];
            playerStat.hidden = false;
        }
        if (playerStat.hidden == false) {
            if (!toload) {
                [self  loadBreakBalls:playerId];
                self.displayState += displayValue;
            }
        } else {
            if (!toload) {
                self.displayState -= displayValue;
            }
        }
    }
}



- (IBAction)buttonMorePlayer1Pressed:(id)sender {
    [self manageMorePlayer:self.player1StatView :[NSNumber numberWithInt:1] :1 :false];
}

- (IBAction)buttonMorePlayer2Pressed:(id)sender {
    [self manageMorePlayer:self.player2StatView :[NSNumber numberWithInt:2] :2 :false];
    
}


/* visit level - next */

- (IBAction)forwardButtonPressed:(id)sender {
    [self loadBreakShots:self.breakShotsIndex + 1 :false];
    if (self.breakShots.count > 0) {

        self.graphStatisticsOverlayView.plotHighlightIndex = self.breakShotsIndex;
        [self.graphStatisticsOverlayView loadSharedData];
        [self.graphStatisticsOverlayView setNeedsDisplay];
        
        
        self.P1BreakInfo.hidden = true;
        self.p1BreakInfoBall.hidden = true;
        
        self.P2BreakInfo.hidden = true;
        self.p2BreakInfoBall.hidden = true;
        
        self.P1AmountBreak.hidden = false;
        self.P2AmountBreak.hidden = false;
        
    }
}



/* visit level - previous */

- (IBAction)backButtonPressed:(id)sender {
    
    if (self.breakShotsIndex>0) {
 
        if ([self loadBreakShots :self.breakShotsIndex - 1 :false]) {;
            if (self.breakShots.count > 0) {
         
                self.graphStatisticsOverlayView.plotHighlightIndex = self.breakShotsIndex;
                [self.graphStatisticsOverlayView loadSharedData];
                [self.graphStatisticsOverlayView setNeedsDisplay];
                
                self.P1BreakInfo.hidden = true;
                self.p1BreakInfoBall.hidden = true;
                
                self.P2BreakInfo.hidden = true;
                self.p2BreakInfoBall.hidden = true;
                
                self.P1AmountBreak.hidden = false;
                self.P2AmountBreak.hidden = false;
                
            }

        }
    }
}

/* frame detail view level */


-(UIColor*) getColourFromBallName :(ballShot*) ball {
    
    
    if ([ball.colour isEqualToString:@"RED"]) {
        return self.redColour;
    } else if ([ball.colour isEqualToString:@"YELLOW"]) {
        return self.yellowColour;
    } else if ([ball.colour isEqualToString:@"GREEN"]) {
        return self.greenColour;
    } else if ([ball.colour isEqualToString:@"BROWN"]) {
        return self.brownColour;
    } else if ([ball.colour isEqualToString:@"BLUE"]) {
        return self.blueColour;
    } else if ([ball.colour isEqualToString:@"PINK"]) {
        return self.pinkColour;
    } else if ([ball.colour isEqualToString:@"BLACK"]) {
        return self.blackColour;
    } else {
         return [UIColor clearColor];
    }
}



-(void) loadBall :(ballShot*) ball :(int)currentRow {
    
    if (self.player1View.hidden==true) {
        //self.p2BreakInfoBall.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png",self.skinPrefix,ball.imageNameLarge]];
       
        self.p2BreakInfoBall.backgroundColor = [self getColourFromBallName:ball];
        
    } else {
        //self.p1BreakInfoBall.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png",self.skinPrefix,ball.imageNameLarge]];
        self.p1BreakInfoBall.backgroundColor = [self getColourFromBallName:ball];
    }
    
    if (ball.shotid==[NSNumber numberWithInt:Potted]) {
        int breakInTime=0;
        for (int i=0; i<= currentRow; i++ ) {
            ballShot *item = [self.breakShots objectAtIndex:i];
            breakInTime += [item.value intValue];
        }
         if (self.player1View.hidden==true) {
             self.P2BreakInfo.text = [NSString stringWithFormat:@"Points = %@\nSequence = %d\nBreak = %d\nTime = %@\n%@", [ball getBallShotText], currentRow+1,breakInTime, [ball.getBallDetailDTText substringFromIndex: [ball.getBallDetailDTText length] - 8], ball.getBallDetailText];
         } else {
             self.P1BreakInfo.text = [NSString stringWithFormat:@"Points = %@\nSequence = %d\nBreak = %d\nTime = %@\n%@", [ball getBallShotText], currentRow+1,breakInTime, [ball.getBallDetailDTText substringFromIndex: [ball.getBallDetailDTText length] - 8], ball.getBallDetailText];
         }

    } else {
        if (self.player1View.hidden==true) {
            self.P2BreakInfo.text = [NSString stringWithFormat:@"Points = %@\nSequence = %d\nTime = %@\n%@", [ball getBallShotText], currentRow+1, [ball.getBallDetailDTText substringFromIndex: [ball.getBallDetailDTText length] - 8], ball.getBallDetailText];
        } else {
            self.P1BreakInfo.text = [NSString stringWithFormat:@"Points = %@\nSequence = %d\nTime = %@\n%@", [ball getBallShotText], currentRow+1, [ball.getBallDetailDTText substringFromIndex: [ball.getBallDetailDTText length] - 8], ball.getBallDetailText];
        }
    }
    
    if (ball.pocketid==[NSNumber numberWithInt:0]) {
        self.snookerTable.hidden=true;
    } else {
        self.snookerTable.hidden=false;
    }
    
    if (!self.graphStatisticsOverlayView.hidden) {
    
    self.P1AmountBreak.hidden = true;
    self.P2AmountBreak.hidden = true;
    
    
    self.P1BreakInfo.hidden = false;
    self.p1BreakInfoBall.hidden = false;
    
    self.P2BreakInfo.hidden = false;
    self.p2BreakInfoBall.hidden = false;
    
    }
}



-(void)updateDurationVisitLabelContent :(UILabel*) titleInfo {
    
    titleInfo.text = [NSString stringWithFormat:@"Duration:%@\nVisits:%d/%lu",self.frameDuration, self.breakShotsIndex, (unsigned long)self.graphStatisticView.frameData.count];
}

/* created 20160204 */
/* last modified 20160205 */

 -(void)updateSummaryLabelContent :(UILabel*) frameInfo {
 
// missing optional text if match is still ongoing
     
 NSString *data;
     
     int player1Score;
     int player2Score;
     
     if (self.stepperFrame.value==0) {
         player1Score = [self.m.Player1FrameWins intValue];
         player2Score = [self.m.Player2FrameWins intValue];
     } else {
         
         if (self.graphStatisticView.graphReferenceId == self.graphStatisticView.numberOfFrames) {
             player1Score = self.graphStatisticView.scorePlayer1+[self.p1.activeBreak intValue];
             player2Score = self.graphStatisticView.scorePlayer2+[self.p2.activeBreak intValue];
         } else {
             player1Score = self.graphStatisticView.scorePlayer1+[self.p1.activeBreak intValue];
             player2Score = self.graphStatisticView.scorePlayer2+[self.p2.activeBreak intValue];
         }
             
     }
 

     if (player1Score > player2Score) {
         //  player one has either won or is winning
         if (self.graphStatisticView.graphReferenceId == self.graphStatisticView.numberOfFrames && ([self.m.matchEndDate isEqualToString:@""] || self.m.matchEndDate==nil)) {
             
             /* we need to locate remaining points */
             data = [NSString stringWithFormat:@"%d points remain. %@ leads %@ by %d",self.activeFramePointsRemaining,self.player1Name.text,self.player2Name.text, player1Score - player2Score];
 
         } else if (self.graphStatisticView.graphReferenceId != 0) {
             data = [NSString stringWithFormat:@"%@ beat %@ by %d point(s)",self.player1Name.text,self.player2Name.text, player1Score - player2Score];
 
         } else if ([self.m.matchEndDate isEqualToString:@""] || self.m.matchEndDate==nil) {
             data = [NSString stringWithFormat:@"%@ is beating %@ by %d frame(s)" ,self.player1Name.text,self.player2Name.text, player1Score - player2Score];
             
         } else {
             data = [NSString stringWithFormat:@"%@ beat %@ by %d frame(s)" ,self.player1Name.text,self.player2Name.text, player1Score - player2Score];
             
         }
         
         frameInfo.textColor = [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
 
     } else if (player2Score > player1Score) {
        //  player two has either won or is winning
         if (self.graphStatisticView.graphReferenceId == self.graphStatisticView.numberOfFrames && ([self.m.matchEndDate isEqualToString:@""] || self.m.matchEndDate==nil)) {
             
             /* we need to locate remaining points */
             
             data = [NSString stringWithFormat:@"%d points remain. %@ leads %@ by %d",self.activeFramePointsRemaining,self.player2Name.text,self.player1Name.text, player2Score - player1Score];
         } else if (self.graphStatisticView.graphReferenceId != 0) {
             data = [NSString stringWithFormat:@"%@ beat %@ by %d point(s)",self.player2Name.text,self.player1Name.text, player2Score - player1Score];
         } else if ([self.m.matchEndDate isEqualToString:@""] || self.m.matchEndDate==nil) {
             data = [NSString stringWithFormat:@"%@ is beating %@ by %d frame(s)" ,self.player2Name.text,self.player1Name.text, player2Score - player1Score];
             
         } else {
             data = [NSString stringWithFormat:@"%@ beat %@ by %d frame(s)" ,self.player2Name.text,self.player1Name.text, player2Score - player1Score];
             
         }

         
         frameInfo.textColor = [UIColor colorWithRed:255.0f/255.0f green:45.0f/255.0f blue:85.0f/255.0f alpha:1.0f];
     } else {
         // players tied
         if (self.graphStatisticView.graphReferenceId != 0) {
             if (self.activeFramePointsRemaining>0) {
                 data = [NSString stringWithFormat:@"%d remain. %@ and %@ are level",self.activeFramePointsRemaining,self.player1Name.text,self.player2Name.text];
             } else {
                 data = [NSString stringWithFormat:@"%@ and %@ are level",self.player1Name.text,self.player2Name.text];
             }
         } else {
             // general text to fit both cases of match completed and current
             data = [NSString stringWithFormat:@"%@ and %@ are tied",self.player1Name.text,self.player2Name.text];
         }
         //player 1 colour
         frameInfo.textColor = [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1];
 
     }
     frameInfo.text = data;
 }




/* export file functions */

/* created 20151012 */
/* last modified 20151029 */
-(NSString*) exportDataFile :(NSMutableArray*) matchDataSet {
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *exportDate = [dateFormatter stringFromDate:date];
    
    
    NSString *fileData = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@",self.m.matchkey, self.p1.nickName, self.m.Player1FrameWins, self.m.Player1HiBreak, self.p1.playerkey, self.p2.nickName, self.m.Player2FrameWins, self.m.Player2HiBreak, self.p2.playerkey,exportDate, self.m.matchDate,self.m.matchEndDate];
    
    int tempFrameid=1;
    NSNumber *frameIdx = [NSNumber numberWithInt:0];
    int tempEntryid=0;
    
    for (breakEntry *data in matchDataSet) {
        
        if (frameIdx != data.frameid) {
            tempFrameid ++;
            frameIdx = data.frameid;
            NSMutableArray *startDate = [self.db entriesRetreive:self.m.matchid :nil :frameIdx :nil :nil :nil :nil :false];
            breakEntry *tempEntry = [[breakEntry alloc] init];
            tempEntry = [startDate objectAtIndex:0];
            fileData = [NSString stringWithFormat:@"%@\n%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@",fileData, tempEntry.entryid,tempEntry.endbreaktimestamp,tempEntry.frameid,@"0",@"0",@"0",@"0",@"FS",@"0",@"0",@"0"];
        }
        int potIndex = 0;
        
        for (ballShot *ball in data.shots) {
            int ballPoint;
            ballPoint = [ball.value intValue];
            NSNumber *shotDetail1;
            NSNumber *shotDetail2;
            NSNumber *pocketid;
            
            pocketid = ball.pocketid;
            
            if (ball.shotid == [NSNumber numberWithInt:Potted]) {
                shotDetail1 = ball.distanceid;
                shotDetail2 = ball.effortid;
            } else if (ball.shotid == [NSNumber numberWithInt:Foul]) {
                shotDetail1 = ball.foulid;
                shotDetail2 = [NSNumber numberWithInt:0];
            } else if (ball.shotid == [NSNumber numberWithInt:Missed]) {
                shotDetail1 = ball.distanceid;
                shotDetail2 = ball.effortid;
            } else if (ball.shotid == [NSNumber numberWithInt:Safety]) {
                shotDetail1 = ball.safetyid;
                shotDetail2 = [NSNumber numberWithInt:0];
            } else if (ball.shotid == [NSNumber numberWithInt:Bonus]) {
                shotDetail1 = ball.foulid;
                shotDetail2 =[NSNumber numberWithInt:0];
            }  else if (ball.shotid == [NSNumber numberWithInt:Adjustment]) {
                shotDetail1 = ball.foulid;
                shotDetail2 = [NSNumber numberWithInt:0];
            }
            fileData = [NSString stringWithFormat:@"%@\n%@;%@;%@;%@;%@;%@;%@;%@;%d;%@;%@",fileData, data.entryid, data.endbreaktimestamp,data.frameid,data.playerid,ball.shotid,shotDetail1,shotDetail2,ball.colour,ballPoint,ball.shottimestamp,pocketid];
            
            potIndex ++;
            
        }
        tempEntryid = [data.entryid intValue];
    }
    
    frameIdx = [NSNumber numberWithInt:tempFrameid];
    
    fileData = [NSString stringWithFormat:@"%@\n%d;%@;%@;%@;%@;%@;%@;%@;%@;%@",fileData, tempEntryid+1 ,[dateFormatter stringFromDate:[NSDate date]],frameIdx,@"0",@"0",@"0",@"0",@"ME",@"0",@"0"];
    
    
    
    return fileData;
}


- (IBAction)exportMatchPressed:(id)sender {
    
    
    if (self.breakStatistcsView.hidden == true ) {
        
        /* export the current match selected to file and send through email */
        
        
        
        
        NSString *filecontent = [self exportDataFile :self.activeMatchData];
        
        /* needs to be mailed/sent somehow */
        
        
        /* next part attempts to compose an email and offer the user to load recipients & send an email */
        BOOL ok = [MFMailComposeViewController canSendMail];
        if (!ok) return;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePathSSM = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"MatchData.ssm"];
        
        [fileManager removeItemAtPath:filePathSSM error:nil];
        
        NSError *error;
        
        [filecontent writeToFile:filePathSSM atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        
        NSString *body = [NSString stringWithFormat:@"Match between %@ and %@ exported to file.  It is possible once email is received to import this match onto another iOS device running Snooker Score Master!</br></br>Player One (%@):%@ frames, highest break of %@</br>Player Two (%@):%@ frames, highest break of %@", self.p1.nickName, self.p2.nickName,self.p1.nickName,self.m.Player1FrameWins,self.m.Player1HiBreak,self.p2.nickName,self.m.Player2FrameWins, self.m.Player2HiBreak];
        
        
        MFMailComposeViewController* snookerScorerMailComposer = [MFMailComposeViewController new];
        snookerScorerMailComposer.mailComposeDelegate = self;
        [snookerScorerMailComposer setSubject:[NSString stringWithFormat:@"Snooker Score Master - Matchday :%@", self.m.matchDate]];
        
        [snookerScorerMailComposer setToRecipients:[NSArray arrayWithObjects:self.p1.emailAddress, self.p2.emailAddress, nil]];
        
        [snookerScorerMailComposer setMessageBody:body isHTML:YES];
        
        /* attach files */
        NSData *ssmFile = [NSData dataWithContentsOfFile:filePathSSM];
        [snookerScorerMailComposer addAttachmentData:ssmFile
                                            mimeType:@"text/plain"
                                            fileName:@"MatchData.ssm"];
        
        [self presentViewController:snookerScorerMailComposer animated:YES completion:nil];
        
        
        
        
    } else {
        
        /* tweet break selected */
        
        UIImage *image;
        
        image = [self imageWithCollectionView :self.breakCollection];
        
        
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheetOBJ setInitialText: [NSString stringWithFormat:@"#snooker #score. Nice Score! @earsmusic73 #SnookerScoreMaster"]];
            [tweetSheetOBJ addImage:image];
            [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
        }
        
        
    }
    
}





- (void)addItemViewController:(embededMatchStatisticsVC *)controller keepDisplayState:(int)displayState {
    
}


@end
