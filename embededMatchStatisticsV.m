//
//  matchStatisticsVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 15/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "embededMatchStatisticsV.h"
#import "matchListingTVC.h"
#import "breakEntry.h"
#import "breakBallCell.h"

@interface embededMatchStatisticsV () < UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation embededMatchStatisticsV


-(void)initDB {
    /* most times the database is already existing */
    self.db = [[dbHelper alloc] init];
    //    [self.db deleteDB:@"snookmast.db"];
    [self.db dbCreate :@"snookmast.db"];
    
    
    self.activeMatchData = [self.db entriesRetreive :self.m.matchid :nil :nil :nil :nil :nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDB];
    // Do any additional setup after loading the view.
    
    NSData *pngdata;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    pngdata = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.p1.photoLocation]];
    
    UIImage *img = [UIImage imageWithData:pngdata];
    
    if (img==nil) {
        img = [UIImage imageNamed:@"female_icon.png"];
    }

    [self.player1Photo setImage:img];
    
    self.player1Photo.frame = CGRectMake(self.player1Photo.frame.origin.x, self.player1Photo.frame.origin.y, 50, 50);
    self.player1Photo.clipsToBounds = YES;
    self.player1Photo.layer.cornerRadius = 50/2.0f;
    self.player1Photo.layer.borderWidth=1.5f;
    self.player1Photo.layer.borderColor = [UIColor colorWithRed:51.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    
    pngdata = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.p2.photoLocation]];
    
    img = [UIImage imageWithData:pngdata];
    
    if (img==nil) {
        img = [UIImage imageNamed:@"female_icon.png"];
    }
    
    [self.player2Photo setImage:img];
    
    self.player2Photo.frame = CGRectMake(self.player2Photo.frame.origin.x, self.player2Photo.frame.origin.y, 50, 50);
    self.player2Photo.clipsToBounds = YES;
    self.player2Photo.layer.cornerRadius = 50/2.0f;
    self.player2Photo.layer.borderWidth=1.5f;
    self.player2Photo.layer.borderColor = [UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f].CGColor;
    
    
    
    if (self.m.matchid == self.activeMatchPlayers.matchid) {
        self.player1Score.text = [NSString stringWithFormat:@"%@", self.activeMatchPlayers.Player1FrameWins];
        self.player2Score.text = [NSString stringWithFormat:@"%@", self.activeMatchPlayers.Player2FrameWins];
    } else {
        self.player1Score.text = [NSString stringWithFormat:@"%@", self.m.Player1FrameWins];
        self.player2Score.text = [NSString stringWithFormat:@"%@", self.m.Player2FrameWins];
    }
    

    self.player1Name.text=self.p1.nickName;
    self.player2Name.text=self.p2.nickName;
    
    self.graphStatisticView.p1 = self.p1;
    self.graphStatisticView.p2 = self.p2;
    
    

    self.graphStatisticView.selectedData = self.activeMatchData;
    
    self.graphStatisticView.matchStatistics=true;
    self.graphStatisticView.numberOfFrames=[self.m.Player1FrameWins intValue] + [self.m.Player2FrameWins intValue];
    
    if (self.graphStatisticView.numberOfFrames==0) {
        // maybe we have selected the current frame..
        breakEntry *stateOfSelectedMatch = [self.activeMatchData lastObject];
        if (stateOfSelectedMatch.active==[NSNumber numberWithInt:1]) {
            self.graphStatisticView.numberOfFrames = [stateOfSelectedMatch.frameid intValue];
        }
    }
    
    
    self.graphStatisticView.matchFramePoints = [[NSMutableArray alloc] init];
    self.graphStatisticView.frameData = [[NSMutableArray alloc] init];
    
    /* maximum stepper will be frame */
    self.graphStepper.maximumValue = self.graphStatisticView.numberOfFrames;
    self.graphStepper.value = 0;

    
    self.graphStepper.tintColor = [UIColor darkGrayColor];
 
    self.p1HiBreakCollection.dataSource = self;
    self.p1HiBreakCollection.delegate = self;
    
    self.p2HiBreakCollection.dataSource = self;
    self.p2HiBreakCollection.delegate = self;
    
    [self loadBreakBalls:[NSNumber numberWithInt:1]];
    [self loadBreakBalls:[NSNumber numberWithInt:2]];
  

}

-(void)viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)stepperChanged:(id)sender {
    
    
    
    if (self.graphStepper.value==0.0f) {
        self.graphReferenceLabel.text = @"Match";
        self.graphStatisticView.graphReferenceId=0;
        
        
        
        if (self.m.matchid == self.activeMatchPlayers.matchid) {
            self.player1Score.text = [NSString stringWithFormat:@"%@", self.activeMatchPlayers.Player1FrameWins];
            self.player2Score.text = [NSString stringWithFormat:@"%@", self.activeMatchPlayers.Player2FrameWins];
        } else {
            self.player1Score.text = [NSString stringWithFormat:@"%@", self.m.Player1FrameWins];
            self.player2Score.text = [NSString stringWithFormat:@"%@", self.m.Player2FrameWins];
    
        }
    } else {
        self.graphStatisticView.graphReferenceId=self.graphStepper.value;
        [self.graphStatisticView loadSharedData];
        
        
        
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


- (IBAction)buttonMorePlayer1Pressed:(id)sender {
    
    if (self.breakStatistcsView.hidden) {
    
        self.player1StatView.hidden = !self.player1StatView.hidden;
        if (self.player1StatView.hidden == false) {
            [self  loadPlayerStatistics:[NSNumber numberWithInt:1]];
            [self  loadBreakBalls:[NSNumber numberWithInt:1]];
        }
    }
}

- (IBAction)buttonMorePlayer2Pressed:(id)sender {
    
    
    if (self.breakStatistcsView.hidden) {
    
        self.player2StatView.hidden = !self.player2StatView.hidden;
    
        if (self.player2StatView.hidden == false) {
            [self loadPlayerStatistics:[NSNumber numberWithInt:2]];
            [self loadBreakBalls:[NSNumber numberWithInt:2]];
        }
    
    }
    
}



-(void)loadBreakBalls :(NSNumber *) playerIndex {
    if (self.graphStatisticView.graphReferenceId>0) {
        if (playerIndex==[NSNumber numberWithInt:1]) {
            self.p1BreakBalls = [self getHiBreakBalls:[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        } else {
            self.p2BreakBalls = [self getHiBreakBalls:[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        }
    } else {

        if (playerIndex==[NSNumber numberWithInt:1]) {
            self.p1BreakBalls = [self getHiBreakBalls:self.activeMatchData :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        } else {
            self.p2BreakBalls = [self getHiBreakBalls:self.activeMatchData :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        }
    }
    
    if ([playerIndex intValue]==1) {
        [self.p1HiBreakCollection reloadData];
    } else {
        [self.p2HiBreakCollection reloadData];
    }
}




-(void)loadPlayerStatistics :(NSNumber *) playerIndex {
    
    
    int hibreak = [self getHiBreak :self.activeMatchData :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
    float avgbreak;
    int redcount, yellowcount, greencount, browncount, bluecount, pinkcount, blackcount;
    
    
    if (self.graphStatisticView.graphReferenceId>0) {
        redcount = [self getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:1]];
        yellowcount = [self getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:2]];
        greencount = [self getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:3]];
        browncount = [self getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:4]];
        bluecount = [self getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:5]];
        pinkcount = [self getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:6]];
        blackcount = [self getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:7]];
        avgbreak = [self getAvgBreakAmt :[self.graphStatisticView frameData] :playerIndex];
        
    } else {
        redcount = [self getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:1]];
        yellowcount = [self getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:2]];
        greencount = [self getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:3]];
        browncount = [self getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:4]];
        bluecount = [self getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:5]];
        pinkcount = [self getQtyOfBallsByColor :self.activeMatchData:playerIndex :[NSNumber numberWithInt:6]];
        blackcount = [self getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:7]];
        avgbreak = [self getAvgBreakAmt :self.activeMatchData :playerIndex];
    }
    
    if ([playerIndex intValue]==1) {
        self.p1HiBreakLabel.text = [NSString stringWithFormat:@"%d",hibreak];
        self.p1AvgBreakLabel.text = [NSString stringWithFormat:@"%.02f",avgbreak];
        self.p1RedCountLabel.text = [NSString stringWithFormat:@"%d",redcount];
        self.p1YellowCountLabel.text = [NSString stringWithFormat:@"%d",yellowcount];
        self.p1GreenCountLabel.text = [NSString stringWithFormat:@"%d",greencount];
        self.p1BrownCountLabel.text = [NSString stringWithFormat:@"%d",browncount];
        self.p1BlueCountLabel.text = [NSString stringWithFormat:@"%d",bluecount];
        self.p1PinkCountLabel.text = [NSString stringWithFormat:@"%d",pinkcount];
        self.p1BlackCountLabel.text = [NSString stringWithFormat:@"%d",blackcount];
    } else {
        self.p2HiBreakLabel.text = [NSString stringWithFormat:@"%d",hibreak];
        self.p2AvgBreakLabel.text = [NSString stringWithFormat:@"%.02f",avgbreak];
        self.p2RedCountLabel.text = [NSString stringWithFormat:@"%d",redcount];
        self.p2YellowCountLabel.text = [NSString stringWithFormat:@"%d",yellowcount];
        self.p2GreenCountLabel.text = [NSString stringWithFormat:@"%d",greencount];
        self.p2BrownCountLabel.text = [NSString stringWithFormat:@"%d",browncount];
        self.p2BlueCountLabel.text = [NSString stringWithFormat:@"%d",bluecount];
        self.p2PinkCountLabel.text = [NSString stringWithFormat:@"%d",pinkcount];
        self.p2BlackCountLabel.text = [NSString stringWithFormat:@"%d",blackcount];

    }
}


/* created 20150927 */
-(int)getHiBreak:(NSMutableArray*) activeDataSet :(NSNumber*)playerId :(NSNumber*)frameId {
    int highestBreak=0;
    for (breakEntry *data in activeDataSet) {
        if (playerId == data.playerid && (frameId == data.frameid || frameId==[NSNumber numberWithInt:0])) {
            int totalBreak = 0;
            for (ballShot *shot in data.shots) {
                if (shot.shotid==[NSNumber numberWithInt:Potted]) {
                    totalBreak += [shot.value intValue];
                }
            }
            if (totalBreak > highestBreak) {
                highestBreak = totalBreak;
            }
        }
    }
    return highestBreak;
}





/* AVERAGE CALCULATIONS */

/* created 20150927 */
-(float)getAvgBreakAmt:(NSMutableArray*) activeDataSet :(NSNumber*)playerId {
    int totalPottedPoints = 0;
    int totalVisits = 0;
    totalPottedPoints = [self getScoreByShotId: activeDataSet :playerId :[NSNumber numberWithInt:Potted]];
    totalVisits = [self getTotalScoringVisits: activeDataSet :playerId];
    float avgAmount = 0.0;
    avgAmount = (float)totalPottedPoints / (float)totalVisits;
    if isnan(avgAmount) {
        avgAmount=0.0;
    }
    return avgAmount;
}

/* created 20150927 */
-(int)getScoreByShotId:(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)shotId {
    // This method is used to obtain either the potted points a player has made or the foul points a
    // player has received.
    
    int retValue=0;
    for (breakEntry *data in frameDataSet) {
        if (playerId == data.playerid) {
            if (shotId==[NSNumber numberWithInt:Potted]) {
                for (ballShot *shot in data.shots) {
                    if (shot.shotid == [NSNumber numberWithInt:Potted]) {
                        retValue+=[shot.value intValue];
                    }
                }
            } else if (shotId==[NSNumber numberWithInt:Bonus]) {
                
                for (ballShot *shot in data.shots) {
                    if (shot.shotid == [NSNumber numberWithInt:Bonus]) {
                        retValue+=[shot.value intValue];
                    }
                }
            }
        }
    }
    return retValue;
}

/*created 20150927 */
-(int)getTotalScoringVisits:(NSMutableArray*) frameDataSet  :(NSNumber*)playerId {
    int totalVisits=0;
    for (breakEntry *data in frameDataSet) {
        ballShot *firstShot = [data.shots firstObject];
        if (playerId == data.playerid && firstShot.shotid==[NSNumber numberWithInt:Potted]) {
            totalVisits ++;
        }
    }
    return totalVisits;
}


/* COLOUR COUNTS */

/* refactored 20150911 */
-(int)getQtyOfBallsByColor:(NSMutableArray*) activeDataSet  :(NSNumber*)playerid :(NSNumber*) reqBallPoint {
    
    int totalPotsOfWantedBall=0;
    for (breakEntry *singleBreak in activeDataSet) {
        if ([playerid isEqualToNumber:singleBreak.playerid] || [playerid intValue] == 0) {
            NSNumber *ballPoint;
            for (ballShot *shot in singleBreak.shots) {
                ballPoint = shot.value;
                if ([ballPoint isEqualToNumber:reqBallPoint] && ([shot.shotid isEqualToNumber:[NSNumber numberWithInt:Potted]] || [shot.foulid isEqualToNumber:[NSNumber numberWithInt:adjusted]])) {
                    totalPotsOfWantedBall ++;
                }
            }
        }
    }
    return totalPotsOfWantedBall;
}





/* BALL COLLECTION item */

/* created 20150928 */
-(NSMutableArray *)getHiBreakBalls:(NSMutableArray*) activeDataSet :(NSNumber*)playerId :(NSNumber*)frameId {
    int highestBreak=0;
    int ballsInBreak=0;
    NSMutableArray *balls;
    
    for (breakEntry *data in activeDataSet) {
        if (playerId == data.playerid && (frameId == data.frameid || frameId == [NSNumber numberWithInt:0])) {
            int totalBreak = 0;
            for (ballShot *ball in data.shots) {
                if (ball.shotid==[NSNumber numberWithInt:Potted]) {
                    totalBreak+=[ball.value intValue];
                }
            }
            if (totalBreak > highestBreak) {
                // update highest break!
                highestBreak = totalBreak;
                balls = data.shots;
                ballsInBreak = (int)balls.count;
            } else if (totalBreak == highestBreak && ballsInBreak > (int)data.shots.count) {
                // save the combination that has the most pots in it.
                balls = data.shots;
                ballsInBreak = (int)data.shots.count;
            }
        }
        
    }
    return balls;
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

     if (collectionView == self.p1HiBreakCollection) {
        return self.p1BreakBalls.count;
    }
    else {
        return self.p2BreakBalls.count;
    }
    
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (collectionView == self.p1HiBreakCollection) {
        
        breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"P1Cell" forIndexPath:indexPath];
        
        UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:106];
       // UILabel *ballLabel = (UILabel *)[cell viewWithTag:107];
        ballShot *selectedBall = [self.p1BreakBalls objectAtIndex:indexPath.row];
        cell.ball = [self.p1BreakBalls objectAtIndex:indexPath.row];
        collectionImageView.image = [UIImage imageNamed:selectedBall.imageNameLarge];
       // ballLabel.text = [selectedBall getBallShotText];
       // ballLabel.textColor = [UIColor whiteColor];
        
        return cell;
    }
    else {
        
        breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"P2Cell" forIndexPath:indexPath];
        
        UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:108];
       // UILabel *ballLabel = (UILabel *)[cell viewWithTag:109];
        ballShot *selectedBall = [self.p2BreakBalls objectAtIndex:indexPath.row];
        cell.ball = [self.p2BreakBalls objectAtIndex:indexPath.row];
        collectionImageView.image = [UIImage imageNamed:selectedBall.imageNameLarge];
       // ballLabel.text = [selectedBall getBallShotText];
      //  ballLabel.textColor = [UIColor whiteColor];
        
        return cell;
        
    }


}

- (IBAction)exportMatchPressed:(id)sender {
    
    
    
    
    
    
    
}


- (IBAction)breakStatisticsPressed:(id)sender {
    
    
    if (self.player1StatView.hidden && self.player2StatView.hidden) {
        self.breakStatistcsView.hidden = !self.breakStatistcsView.hidden;
    }
    
    
}





@end
