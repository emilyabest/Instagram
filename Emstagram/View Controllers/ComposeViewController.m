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

@interface ComposeViewController () <CanReceiveImageDelegate> // ComposeVC conforms to receive image
@property (weak, nonatomic) IBOutlet UIImageView *composeImage;
@property (weak, nonatomic) IBOutlet UITextView *composeCaption;
//@property (strong, nonatomic) HomeFeedViewController *homeVC;
//@property (strong, nonatomic) Post *post;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.composeImage.image = [self resizeImage:self.homeVC.chosenImage withSize: CGSizeMake(100, 100)];
//    self.composeImage.image = self.homeVC.chosenImage;
//    self.composeImage.image = self.post.image;
}

/**
 Resizing a UIImage
 */
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    HomeFeedViewController *homeVC = [segue destinationViewController];
    
    //set ourselves as a delegate
    homeVC.delegate = self;
}


- (void)receiveImage:(nonnull UIImage *)image {
    [self resizeImage:image withSize:CGSizeMake(400, 400)];
    self.composeImage.image = image;
}

@end
