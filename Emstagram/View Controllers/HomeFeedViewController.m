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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation HomeFeedViewController

/**
 Initial screen view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 400; // TODO: DELETE WHEN AUTOLAYOUT APPLIED
    
    // reload the data and fill with posts
    [self.tableView reloadData];
    [self fetchPosts];
    
    // refresh the list when user pulls down
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // set the navigation bar font
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:@"Billabong" size:35]}];
}

/**
Frequenting screen view
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchPosts];
}

/**
 Get the 20 most recent instagram posts.
 */
- (void)fetchPosts {
    // start the activity indicator (appears when first opening app)
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
        
        // stop refresh
        [self.refreshControl endRefreshing];
        
        // stop the activity indicator, hides automatically if "Hides When Stopped" is enabled
        [self.activityIndicator stopAnimating];
    }];
}

/**
 User tapped the logout button; sign out the user and transition to the LoginVC.
 */
- (IBAction)didTapLogout:(id)sender {
    // logout the user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    // transition to the LoginVC
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginVC;
}

/**
 User tapped the camera button; transition to the ComposeVC.
 */
- (IBAction)didTapCamera:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ComposeViewController *composeVC = [storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    appDelegate.window.rootViewController = composeVC;
}

#pragma mark - Navigation

/**
 Prepares for two view controller segues. First checks which segue is being performed. For segue to DetailsVC, prepares info of PostCell to pass with segue.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // check if segue to detailsVC
    if ([[segue identifier] isEqualToString:@"detailsSegue"]) {
        // access tapped PostCell
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.postsArray[indexPath.row];
        
        // pass selected post to DetailsVC
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
    // else, segue to composeVC
    else {
        // no data needs to be passed, just perform the modal segue
    }
}

/**
 Loads the data for the PostCell at the next index.
 */
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    // set the cell image and username
    Post *post = self.postsArray[indexPath.row];
    UIImage *image = [[UIImage alloc] initWithData:post.image.getData];
    cell.postCellImage.image = image;
    cell.userName.text = post.author.username;
    
    return cell;
}

/**
 Loads as many table rows as there is data for, max is 20.
 */
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

@end
