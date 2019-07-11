//
//  PostCell.h
//  Emstagram
//
//  Created by emilyabest on 7/10/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postCellImage;
@property (weak, nonatomic) IBOutlet UITextView *postCellCaption;

@end

NS_ASSUME_NONNULL_END
