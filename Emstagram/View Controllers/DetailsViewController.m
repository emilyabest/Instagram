//
//  DetailsViewController.m
//  Emstagram
//
//  Created by emilyabest on 7/11/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

#import "DetailsViewController.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UITextView *postCaption;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set image, timestamp, and caption
    self.postImage.image = [[UIImage alloc] initWithData:self.post.image.getData];
    self.postDate.text = self.post.createdAt.timeAgoSinceNow;
    self.postCaption.text = self.post.caption;
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
