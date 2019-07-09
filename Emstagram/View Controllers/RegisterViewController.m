//
//  RegisterViewController.m
//  Emstagram
//
//  Created by emilyabest on 7/8/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/PFUser.h>

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 User tapped the sign up button
 */
- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}

/**
 Registers a new user for an account
 */
- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];

    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;

    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
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
