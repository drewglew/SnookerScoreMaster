//
//  DeductPointsViewController.h
//  snookerScorer2
//
//  Created by andrew glew on 16/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class adjustVC;

@protocol AdjustPointsDelegate <NSObject>
- (void)addItemViewController:(adjustVC *)controller didPickDeduction:(int)selectedPoints;
- (void)addItemViewController:(adjustVC *)controller didPickBallAdjust:(int)startBallIndex :(int)ballIndex;
@end

@interface adjustVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) id <AdjustPointsDelegate> delegate;
@property (assign) int sumOfPlayerFouls;
@property (assign) int ballIndex;
@property (assign) int selectedValue;
@property (strong, nonatomic) NSString *playerName;
@property (assign) int skins;
@property (strong, nonatomic) NSString *skinPrefix;
@property (weak, nonatomic) IBOutlet UIButton *adjustButton;


@end