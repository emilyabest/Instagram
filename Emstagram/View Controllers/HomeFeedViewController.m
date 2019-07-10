//
//  HomeFeedViewController.m
//  Emstagram
//
//  Created by emilyabest on 7/9/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

//NSLog(@"☀️ Checkpoint 1");


#import "HomeFeedViewController.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "Post.h"

@interface HomeFeedViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) Post *post;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

/**
 User tapped the camera button
 */
- (IBAction)didTapCamera:(id)sender {
    // Instantiate a UIImagePickerController
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    // Check if camera is supported
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // Present UIImagePickerController
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

/**
 The delegate method
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
//    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    // Calling the method implemented in the delegate VC. Boss (HomeFeedVC) calls the delegate (ComposeVC) with the protocol it knows the delegate has implemented.
//    self.chosenImage = editedImage;
//    self.post.image = editedImage;
    [self.delegate receiveImage:editedImage];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"composeSegue" sender:nil];
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
