//
//  DeductPointsViewController.h
//  snookerScorer2
//
//  Created by andrew glew on 16/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdjustPointsViewController;

@protocol AdjustPointsDelegate <NSObject>
- (void)addItemViewController:(AdjustPointsViewController *)controller didPickDeduction:(int)selectedPoints;
@end

@interface AdjustPointsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) id <AdjustPointsDelegate> delegate;
@property (assign) int sumOfPlayerFouls;
@property (assign) int selectedValue;
@property (strong, nonatomic) NSString *playerName;
@end