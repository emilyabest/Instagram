//
//  ComposeViewController.m
//  Emstagram
//
//  Created by emilyabest on 7/10/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

#import "ComposeViewController.h"
#import "HomeFeedViewController.h"
#import "Post.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *composeImage;
@property (weak, nonatomic) IBOutlet UITextView *composeCaption;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Instatiate the gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.composeImage addGestureRecognizer:tapGestureRecognizer];
    self.composeImage.userInteractionEnabled = YES;
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
}

/**
 Tap gesture method
 */
- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer {
    // Initialize camera/camera roll view
    [self initializeCamera];
}


/**
 Opens a camera/camera roll
 */
- (void)initializeCamera {
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
 The delegate method for UIImagePickerControllerDelegate
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    //    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.composeImage.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to ComposeVC
    [self dismissViewControllerAnimated:YES completion:nil];
}

///**
// Resizing a UIImage
// */
//- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
//    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//
//    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
//    resizeImageView.image = image;
//
//    UIGraphicsBeginImageContext(size);
//    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return newImage;
//}

/**
 Close compose screen when cancel button is tapped.
 */
- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

/**
 Share the composed post when the user taps share.
 */
- (IBAction)didTapShare:(id)sender {
    // call Post's + (void) postUserImage:(UIImage *)image withCaption:(NSString *)caption withCompletion:(PFBooleanResultBlock)completion {
    [Post postUserImage:self.composeImage.image withCaption:self.composeCaption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        // calls code from the method's implementation in Post
    }];
    
    // Close the compose screen
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
