//
//  ballSumIV.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 14/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "ballSumIV.h"

@implementation ballSumIV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width / 2.0;
 
    if (self.tag==1) {
        self.layer.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:60.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==2 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:168.0f/255.0f blue:0.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==3 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:101.0f/255.0f blue:116.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==4 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:114.0f/255.0f green:43.0f/255.0f blue:22.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==5 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:79.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==6 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:81.0f/255.0f blue:143.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==7 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:4.0f/255.0f green:3.0f/255.0f blue:8.0f/255.0f alpha:1.0].CGColor;
    }
    
}

@end
