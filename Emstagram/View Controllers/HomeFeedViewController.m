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
#import "PostCell.h"
#import "Post.h"
#import "DetailsViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ComposeViewController.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
//@property (weak, nonatomic) IBOutlet UITextView *cellCaption;
@property (strong, nonatomic) NSArray *postsArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation HomeFeedViewController

/**
 Initial home screen opening
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@" ☀️ view did load");
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 400; //DELETE WHEN AUTOLAYOUT APPLIED
    
    // Reload the data and fill with posts
    [self.tableView reloadData];
    [self fetchPosts];
    
    // Refresh the list when user pulls down
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

/**
 Opening home screen frequently
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchPosts];
    NSLog(@" ☀️ view did appear");
}

/**
 Get the 20 most recent instagram posts.
 */
- (void)fetchPosts {
    // Start the activity indicator (appears when first opening app)
    [self.activityIndicator startAnimating];
    
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postsArray = [NSMutableArray arrayWithArray:posts];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        
        // Stop refresh
        [self.refreshControl endRefreshing];
        
        // Stop the activity indicator, hides automatically if "Hides When Stopped" is enabled
        [self.activityIndicator stopAnimating];
    }];
}

/**
 User tapped the logout button. Sign out the user and transition to the login screen.
 */
- (IBAction)didTapLogout:(id)sender {
    // Logout the user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    // Transition to the LoginVC
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginVC;
}

/**
 */
- (IBAction)didTapCamera:(id)sender {
    // Transition to the composeVC
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ComposeViewController *composeVC = [storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    appDelegate.window.rootViewController = composeVC;
}

/**
 User tapped the camera button. Transition to the ComposeVC.
 */
//- (IBAction)didTapCamera:(id)sender {
    // Transition to the composeVC
//    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ComposeViewController *composeVC = [storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
//    appDelegate.window.rootViewController = composeVC;
//}

#pragma mark - Navigation

/**
 Passes info of post cell to DetailsViewController
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Check if segue to detailsVC
    if ([[segue identifier] isEqualToString:@"detailsSegue"]) {
        // Access tapped movie cell
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.postsArray[indexPath.row];
        
        // Pass selected movie to the new view controller
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
    // Else, segue to composeVC
    else {
        UINavigationController *navigationController = [segue destinationViewController];
    }
    

}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    // Set the cell image and caption
    Post *post = self.postsArray[indexPath.row];
    UIImage *image = [[UIImage alloc] initWithData:post.image.getData];
    cell.postCellImage.image = image;
//    cell.postCellCaption.text = post[@"caption"];
//    cell.commentCount.text = [NSString stringWithFormat:@"%d", post[@"commentCount"]];
//    cell.likeCount.text = [NSString stringWithFormat:@"%d", post[@"likeCount"]];
    cell.userName.text = post.author.username;
    
    return cell;
}

/**
 Get data from PFObject to UIImageView
*/
//- (UIImageView *)getImageData {
//    PFImageView *view = [[PFImageView alloc] initWithImage:post[@"image"]];
//}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

@end
