//
//  HomeFeedViewController.m
//  Emstagram
//
//  Created by emilyabest on 7/9/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

#import "HomeFeedViewController.h"
#import <Parse/Parse.h>

@interface HomeFeedViewController ()

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 User tapped the logout button
 */
- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
