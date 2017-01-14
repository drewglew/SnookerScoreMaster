//
//  helpPageVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 04/12/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "helpPageVC.h"

@interface helpPageVC ()

@end

@implementation helpPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ballPageIndicator.layer.cornerRadius =  self.ballPageIndicator.frame.size.width / 2.0;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closeHelpPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

@end
