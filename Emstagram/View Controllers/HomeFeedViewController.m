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

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
//@property (weak, nonatomic) IBOutlet UITextView *cellCaption;
@property (strong, nonatomic) NSArray *postsArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 400; //DELETE WHEN AUTOLAYOUT APPLIED
    
    [self fetchPosts];
    
    // Refresh the list when user pulls down
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

/**
 Get the 20 most recent instagram posts.
 */
- (void)fetchPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//    PFQuery *postQuery = [Post query];
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
    }];
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
    // Segue to ComposeVC
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    // Set the cell image and caption
    Post *post = self.postsArray[indexPath.row];
    UIImage *image = [[UIImage alloc] initWithData:post.image.getData];
    cell.postCellImage.image = image;
    cell.postCellCaption.text = post[@"caption"];
    
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
