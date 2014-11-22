//
//  DeductPointsViewController.m
//  snookerScorer2
//
//  Created by andrew glew on 16/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "AdjustPointsViewController.h"

@interface AdjustPointsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *PointsPicker;
@property (weak, nonatomic) IBOutlet UILabel *labelExplanation;
@end

@implementation AdjustPointsViewController

@synthesize selectedValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.sumOfPlayerFouls == 0) {
        self.labelExplanation.text = [NSString stringWithFormat:@"%@ has not received any foul points from the other player in this frame.\nYou may increase this players score however.",self.playerName];
    } else {
    self.labelExplanation.text = [NSString stringWithFormat:@"%@ has a total of %d foul points awarded.\nYou may  deduct this amount from the score.\nAlternatively you can increase this score.",self.playerName,self.sumOfPlayerFouls];
    }
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (NSInteger)self.sumOfPlayerFouls + 1 + 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld", (long)row - self.sumOfPlayerFouls];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
   self.selectedValue = (int)row;
}

- (void)addItemViewController:(AdjustPointsViewController *)controller didPickDeduction:(int)selectedPoints {
}

- (IBAction)selectClicked:(id)sender {
    self.selectedValue = ( self.selectedValue - self.sumOfPlayerFouls);
    [self.delegate addItemViewController:self didPickDeduction:self.selectedValue];
    [self.navigationController popViewControllerAnimated:YES];
}




@end
