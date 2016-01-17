//
//  playerDetailVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 07/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "playerDetailVC.h"
#import "dbHelper.h"

@interface playerDetailVC () <PlayersListingDelegate, HeadToHeadDelegate, MatchListingDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonPlayers;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonHeadToHeads;
@property (weak, nonatomic) IBOutlet UICollectionView *historyHighestBreakBallsCollection;
@property (weak, nonatomic) IBOutlet UIImageView *breakBallDetailImage;
@property (weak, nonatomic) IBOutlet UIButton *playerListButton;
@property (weak, nonatomic) IBOutlet UIButton *headToHeadButton;
@property (weak, nonatomic) IBOutlet UIButton *matchListButton;

@end




@implementation playerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

    
    
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerImageTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.imageSelectedPlayer addGestureRecognizer:singleTap];
    [self.imageSelectedPlayer  setUserInteractionEnabled:YES];
    
    
    if (self.imagePathPhoto==nil || [self.imagePathPhoto isEqualToString:@""] ) {
        [self.imageSelectedPlayer setImage:[UIImage imageNamed:@"female_icon.png"] ];
        
    } else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSData *pngData = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.imagePathPhoto]];
        
        [self.imageSelectedPlayer setImage:[UIImage imageWithData:pngData]];
    }
    
    if (self.playerIndex==0) {
        self.playerListButton.hidden = true;
        self.headToHeadButton.hidden = true;
        self.matchListButton.hidden = true;
        self.navigationItem.title = @"New Player";
    } else {
        self.navigationItem.title = @"Preview";
    }

    self.playerNickName.text = self.nickName;
    self.playerEmail.text = self.email;
    
    

    
    
    
    

    
    
    
}


-(void)viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    
    
    
    dbHelper *db = [[dbHelper alloc] init];
    [db dbCreate :@"snookmast.db"];
    
    self.historyBreakShots = [db findHistoryActivePlayersHiBreakBalls :[NSNumber numberWithInt:self.currentPlayerNumber] :[NSNumber numberWithInt:self.staticPlayer1Number] :[NSNumber numberWithInt:self.staticPlayer2Number] :self.currentPlayerHiBreak :self.currentPlayerHighestBreakHistory];
    
    
    self.historyHighestBreakBallsCollection.dataSource = self;
    self.historyHighestBreakBallsCollection.delegate = self;
    
    
    
    [self.historyHighestBreakBallsCollection reloadData];
    
    
    
    
    
}


- (void)viewDidLayoutSubviews {
 
    /* circulize the photo */
    self.imageSelectedPlayer.layer.borderWidth = 1.0f;
    self.imageSelectedPlayer.layer.borderColor = [UIColor orangeColor].CGColor;
    self.imageSelectedPlayer.layer.masksToBounds = NO;
    self.imageSelectedPlayer.clipsToBounds = YES;
    self.imageSelectedPlayer.layer.cornerRadius = self.imageSelectedPlayer.bounds.size.width/2.0f;
    self.imageSelectedPlayer.layer.masksToBounds = YES;
    
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
    
    if([segue.identifier isEqualToString:@"openListing"]){
        playerListingTVC *controller = (playerListingTVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.viewOption = @"playerListing";
        controller.activePlayerNumber = [NSNumber numberWithInt:self.currentPlayerNumber];
        
    } else if([segue.identifier isEqualToString:@"HeadToHeads"]){
        HeadToHeadTVC *controller = (HeadToHeadTVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.activePlayerNumber = [NSNumber numberWithInt:self.currentPlayerNumber];
        controller.staticPlayer1Number = self.staticPlayer1Number;
        controller.staticPlayer2Number = self.staticPlayer2Number;
    } else if([segue.identifier isEqualToString:@"Matches"]){
        matchListingTVC *controller = (matchListingTVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.activePlayerNumber = [NSNumber numberWithInt:self.currentPlayerNumber];
        controller.staticPlayer1Number = self.staticPlayer1Number;
        controller.staticPlayer2Number = self.staticPlayer2Number;
        controller.staticPlayer1CurrentBreak = self.staticPlayer1CurrentBreak;
        controller.staticPlayer2CurrentBreak = self.staticPlayer2CurrentBreak;
        controller.activeMatchId = self.activeMatchId;
        controller.activeMatchPlayers = self.activeMatchPlayers;
    }
    
    
}





- (void)playerImageTapped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%@", [gestureRecognizer view]);
    
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }else
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
        [self presentViewController:picker animated:YES completion:NULL];
        
    }

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageSelectedPlayer.image = chosenImage;
    
    
    // Create path.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (self.playerIndex!=0) {
        self.imagePathPhoto =[ NSString stringWithFormat:@"photo_of_player_%d.png",self.currentPlayerNumber];
    } else {
        self.imagePathPhoto =[ NSString stringWithFormat:@"photo_of_player_%d.png",self.nextPlayerNumber];
    }
    
    self.photoUpdated = true;

    
    NSData* data = UIImagePNGRepresentation([self.imageSelectedPlayer image]);
    [data writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.imagePathPhoto] atomically:YES];

    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)updatePlayerPressed:(id)sender {
    
    if (self.playerIndex!=0) {
        [self.delegate addItemViewController:self didUpdatePlayer :[NSNumber numberWithInt:self.currentPlayerNumber] :self.playerIndex :self.playerNickName.text :self.playerEmail.text :self.imagePathPhoto :self.photoUpdated];
        
    } else {
     [  self.delegate addItemViewController:self didInsertPlayer:self.nextPlayerNumber :self.playerNickName.text :self.playerEmail.text :self.imagePathPhoto :self.photoUpdated];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}








- (IBAction)closePlayerDetailPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissKBNickName:(id)sender {
    
    [self.playerNickName becomeFirstResponder];
    [self.playerNickName resignFirstResponder];
    
}

- (IBAction)dismissKBEmail:(id)sender {
    
    [self.playerEmail becomeFirstResponder];
    [self.playerEmail resignFirstResponder];
}

- (void)addItemViewController:(playerDetailVC *)controller didUpdatePlayer :(NSNumber*) newPlayerNumber :(int)playerId :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated {
}

- (void)addItemViewController:(playerDetailVC *)controller didInsertPlayer :(int)nextPlayerNumber :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated {
}



- (void)addItemViewController:(playerListingTVC *)controller loadPlayerDetails :(player*) playerSelected {
    

    if (self.currentPlayerNumber == [playerSelected.playerNumber intValue]) {
        int a=a;
        /* nothing to do */
    } else {
        self.currentPlayerNumber = [playerSelected.playerNumber intValue];
        self.photoUpdated = true;
        
        self.imagePathPhoto = playerSelected.photoLocation;
        self.nickName = playerSelected.nickName;
        self.email = playerSelected.emailAddress;
        
        if (playerSelected.photoLocation==nil || [playerSelected.photoLocation isEqualToString:@""] ) {
            [self.imageSelectedPlayer setImage:[UIImage imageNamed:@"female_icon.png"] ];
            
        } else {
           
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSData *pngData = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.imagePathPhoto]];
            
            [self.imageSelectedPlayer setImage:[UIImage imageWithData:pngData]];
        }
        
        
        self.playerNickName.text = self.nickName;
        self.playerEmail.text = self.email;
        
        
        /* lastly match player index for this player (1 or 2) will need to be updated too */
        
        
        
    }
    
    
    
}


#pragma mark - CollectionView handling

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.historyBreakShots.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"balls" forIndexPath:indexPath];

    //UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:233];

    ballShot *selectedBall = [self.historyBreakShots objectAtIndex:indexPath.row];
    cell.ball = [self.historyBreakShots objectAtIndex:indexPath.row];
    cell.imageBall.image = [UIImage imageNamed:selectedBall.imageNameLarge];

    
 
    return cell;
}



/*
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"clicked cell");
    
    ballShot *ball = [self.historyBreakShots objectAtIndex:indexPath.row];
    self.breakBallDetailImage.image = [UIImage imageNamed:ball.imageNameLarge];

}
*/


@end
