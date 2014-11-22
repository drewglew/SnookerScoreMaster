//
//  buttonBall.m
//  SnookerScorer
//
//  Created by andrew glew on 06/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "ball.h"

@implementation ball

@synthesize pottedPoints;
@synthesize foulPoints;
@synthesize quantity;
@synthesize colour;
@synthesize imageNameSmall;

-(id)init {
    if (self = [super init])  {
        self.foulPoints = 4;
        self.quantity = 1;
    }
    return self;
}

-(int)pottedPoints {
    return pottedPoints;
}

-(void)setPottedPoints:(int) value {
    pottedPoints = value;
}


-(int)foulPoints {
    return foulPoints;
}

-(void)setFoulPoints:(int) value {
    foulPoints = value;
}

-(NSString *)colour {
    return colour;
}

-(void)setColour:(NSString *) value {
    colour = value;
}

-(NSString *)imageNameSmall {
    return imageNameSmall;
}

-(void)setImageNameSmall:(NSString *) value {
    imageNameSmall = value;
}

-(NSString *)imageNameLarge {
    return imageNameLarge;
}

-(void)setImageNameLarge:(NSString *) value {
    imageNameLarge = value;
}


-(int)quantity {
    return quantity;
}

-(void)setQuantity:(int) value {
    quantity = value;
}

-(void)decreaseQty {
    quantity--;
    if (quantity == 0) {
        self.hidden = true;
    }
}


@end
