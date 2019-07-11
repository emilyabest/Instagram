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
#import "AppDelegate.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *composeImage;
@property (weak, nonatomic) IBOutlet UITextView *composeCaption;

@end

@implementation ComposeViewController

/**
 Initial screen view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // instatiate the gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.composeImage addGestureRecognizer:tapGestureRecognizer];
    self.composeImage.userInteractionEnabled = YES;
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
}

/**
 User tapped the UIImageView. Open the camera.
 */
- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer {
    [self initializeCamera];
}


/**
 Opens a camera/camera roll.
 */
- (void)initializeCamera {
    // instantiate a UIImagePickerController
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    // check if camera is supported
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // present UIImagePickerController
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

/**
 The delegate method for UIImagePickerControllerDelegate.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary<NSString *,id> *)info {
    // get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // do something with the images (based on your use case)
    self.composeImage.image = editedImage;
    
    // dismiss UIImagePickerController to go back to ComposeVC
    [self dismissViewControllerAnimated:YES completion:nil];
}

///**
// Resizes a UIImage. NOTE: this method was provided, but not used. Images loaded without neededing resize.
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
 User tapped cancel; close ComposeVC.
 */
- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

/**
 User tapped share; save the post to the database and close ComposeVC.
 */
- (IBAction)didTapShare:(id)sender {
    // save the post to the database (calls code from the method's implementation in Post)
    [Post postUserImage:self.composeImage.image withCaption:self.composeCaption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }];
}

@end
