//
//  ProfileViewController.m
//  Emstagram
//
//  Created by emilyabest on 7/11/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

#import "ProfileViewController.h"
#import "Post.h"
#import "PostCollectionViewCell.h"
#import "Parse/Parse.h"
#import <UIKit/UIKit.h>

@interface ProfileViewController () <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *postsArray;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // instatiate the gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.profileImage addGestureRecognizer:tapGestureRecognizer];
    self.profileImage.userInteractionEnabled = YES;
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    
    // set the username
    self.userName.text = PFUser.currentUser.username;
    
    // collection view
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchPosts];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    // set up layout
    CGFloat imagesPerLine = 3;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (imagesPerLine - 1)) / imagesPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    // set profile image shape
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    
    // set profile image
    if (PFUser.currentUser[@"profileImage"]) {
        PFFileObject *imageFile = PFUser.currentUser[@"profileImage"];
        UIImage *image = [[UIImage alloc] initWithData:imageFile.getData];
        self.profileImage.image = image;
    }
}

/**
 Get the 20 most recent instagram posts.
 */
- (void)fetchPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:PFUser.currentUser];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postsArray = [NSMutableArray arrayWithArray:posts];
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
    self.profileImage.image = editedImage;
    PFFileObject *imageFilePF = [Post getPFFileFromImage:editedImage];
    [PFUser.currentUser setObject:imageFilePF forKey:@"profileImage"];
    [PFUser.currentUser saveInBackground];
        
    [self dismissViewControllerAnimated:YES completion:nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Access next cell
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    
    // set the cell image and username
    Post *post = self.postsArray[indexPath.row];
    UIImage *image = [[UIImage alloc] initWithData:post.image.getData];
    cell.collectionViewPost.image = image;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postsArray.count;
}

@end
