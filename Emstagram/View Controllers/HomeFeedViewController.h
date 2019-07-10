//
//  HomeFeedViewController.h
//  Emstagram
//
//  Created by emilyabest on 7/9/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CanReceiveImageDelegate <NSObject>

// Contract method
- (void)receiveImage:(UIImage *) image;

@end

@interface HomeFeedViewController : UIViewController
//@property (strong, nonatomic) UIImage *chosenImage;

// Property of boss. Delegate can be of any type and receives protocol
@property (nonatomic, weak) id <CanReceiveImageDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
