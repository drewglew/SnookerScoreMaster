//
//  buttonBall.h
//  SnookerScorer
//
//  Created by andrew glew on 06/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ball : UIButton {
    int pottedPoints;
    int foulPoints;
    int quantity;
    NSString *colour;
    NSString *imageNameSmall;
    NSString *imageNameLarge;
    
}

@property (assign) int pottedPoints;
@property (assign) int foulPoints;
@property (assign) int quantity;
@property (nonatomic) NSString *colour;
@property (nonatomic) NSString *imageNameSmall;
@property (nonatomic) NSString *imageNameLarge;

-(void)decreaseQty;
@end
