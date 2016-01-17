//
//  playerDetailVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 07/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playerListingTVC.h"
#import "HeadToHeadTVC.h"
#import "matchListingTVC.h"
#import "player.h"
#import "breakBallCell.h"
#import "ballShot.h"
#import "match.h"

@class playerDetailVC;
@protocol PlayerDelegate <NSObject>
- (void)addItemViewController:(playerDetailVC *)controller didUpdatePlayer :(NSNumber*) newPlayerNumber :(int)playerId :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated;
- (void)addItemViewController:(playerDetailVC *)controller didInsertPlayer :(int)nextPlayerNumber :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated;
@end
@interface playerDetailVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) id <PlayerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageSelectedPlayer;
@property (weak, nonatomic) IBOutlet UITextField *playerNickName;
@property (weak, nonatomic) IBOutlet UITextField *playerEmail;
@property (assign) int playerIndex;
@property (assign) int nextPlayerNumber;
@property (assign) int currentPlayerNumber;
//@property (assign) int currentPlayerHiBreak;
@property (assign) int staticPlayer1Number;
@property (assign) int staticPlayer2Number;
@property (assign) int staticPlayer1CurrentBreak;
@property (assign) int staticPlayer2CurrentBreak;
@property (strong,nonatomic) NSNumber* currentPlayerHiBreak;
@property (strong,nonatomic) NSNumber* activeMatchId;
@property (strong, nonatomic) NSMutableArray     *currentPlayerHighestBreakHistory;


@property (assign) bool photoUpdated;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *imagePathPhoto;
@property (strong, nonatomic) NSMutableArray *historyBreakShots;
@property (strong, nonatomic) match *activeMatchPlayers;
@end
