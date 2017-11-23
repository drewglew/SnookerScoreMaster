//
//  frameStatisticCellTVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 08/11/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "frameStatisticCellTVC.h"

@implementation frameStatisticCellTVC



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.redColour = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:60.0f/255.0f alpha:1.0];
    self.yellowColour = [UIColor colorWithRed:255.0f/255.0f green:168.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    self.greenColour = [UIColor colorWithRed:0.0f/255.0f green:101.0f/255.0f blue:116.0f/255.0f alpha:1.0];
    self.brownColour = [UIColor colorWithRed:114.0f/255.0f green:43.0f/255.0f blue:22.0f/255.0f alpha:1.0];
    self.blueColour = [UIColor colorWithRed:0.0f/255.0f green:79.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    self.pinkColour = [UIColor colorWithRed:255.0f/255.0f green:81.0f/255.0f blue:143.0f/255.0f alpha:1.0];
    self.blackColour = [UIColor colorWithRed:4.0f/255.0f green:3.0f/255.0f blue:8.0f/255.0f alpha:1.0];

    self.frameBallCollectionView.delegate = self;
    self.frameBallCollectionView.dataSource = self;

    self.visitIndictorView.layer.cornerRadius =  self.visitIndictorView.frame.size.width / 2.0;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cellContentView.layer.cornerRadius = 5.0;;
    self.cellContentView.layer.borderWidth = 1,0;
    self.cellContentView.layer.masksToBounds = YES;
 
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - CollectionView handling

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.balls.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"breakCell" forIndexPath:indexPath];
    [[cell contentView] setFrame:[cell bounds]];
    cell.ball = [self.balls objectAtIndex:indexPath.row];
    [cell setBorderWidth:0.0f];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(breakBallCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    

    [cell setBorderWidth:0.0f];
    
    if ([cell.ball.imageNameLarge isEqualToString:@"red_01"]) {
        cell.ballStoreImage.layer.borderColor = self.redColour.CGColor;
        //cell.imageBall.layer.borderColor = self.redColour.CGColor;
        //cell.imageBall.backgroundColor = self.redColour;
        cell.ballStoreImage.backgroundColor = self.redColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"yellow_02"]) {
        cell.ballStoreImage.layer.borderColor = self.yellowColour.CGColor;
       cell.ballStoreImage.backgroundColor = self.yellowColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"green_03"]) {
        cell.ballStoreImage.layer.borderColor = self.greenColour.CGColor;
        cell.ballStoreImage.backgroundColor = self.greenColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"brown_04"]) {
        cell.ballStoreImage.layer.borderColor = self.brownColour.CGColor;
        cell.ballStoreImage.backgroundColor = self.brownColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"blue_05"]) {
        cell.ballStoreImage.layer.borderColor = self.blueColour.CGColor;
        cell.ballStoreImage.backgroundColor = self.blueColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"pink_06"]) {
        cell.ballStoreImage.layer.borderColor = self.pinkColour.CGColor;
        cell.ballStoreImage.backgroundColor = self.pinkColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"black_07"]) {
        cell.ballStoreImage.layer.borderColor = self.blackColour.CGColor;
        cell.ballStoreImage.backgroundColor = self.blackColour;
    }

}







@end
