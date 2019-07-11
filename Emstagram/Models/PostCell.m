//
//  PostCell.m
//  Emstagram
//
//  Created by emilyabest on 7/10/19.
//  Copyright © 2019 emilyabest. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

///**
// Use a PFImageView to display images stored as PFFile
// */
//- (void)setPost:(Post *)post {
//    self.post = post;
//    self.photoImageView = [post[@"image"] getDataInBackground];
//    self.photoImageView.file = post[@"image"];
//    [self.photoImageView loadInBackground];
//}

@end
