//
//  DetailsViewController.h
//  Emstagram
//
//  Created by emilyabest on 7/11/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
