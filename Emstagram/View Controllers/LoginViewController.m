//
//  LoginViewController.m
//  Emstagram
//
//  Created by emilyabest on 7/8/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/PFUser.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

/**
 Initial screen view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
}
/**
 User tapped the login button; login the user and segue to HomeFeedVC.
 */
- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
    [self performSegueWithIdentifier:@"homeFeedSegue" sender:nil];
}

/**
 Logs in the user
 */
- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError * error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
        }
    }];
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
