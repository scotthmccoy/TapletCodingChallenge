//
//  ExtractedImageScrollViewController.m
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

#import "ExtractedImageScrollViewController.h"



@implementation ExtractedImageScrollViewController




//Frame sizes from AutoLayout are not valid until viewDidLayoutSubviews,
//so we must wait until here to set up the scrollview.
- (void) viewDidLayoutSubviews {

    //Clear the scrollview
    NSArray *viewsToRemove = [self.scrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    //Set the scrollView's scrollable size equal to it's width multiplied by the number of images.
    CGSize pageSize = self.scrollView.frame.size;    
    self.scrollView.contentSize = CGSizeMake(pageSize.width * [self.extractedImages count], pageSize.height);
    
    //Walk the list of images
    int imageNum = 0;
    for (UIImage* img in self.extractedImages) {
        //Make an imageView for each, and 
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageNum * pageSize.width, 0, pageSize.width, pageSize.height)];
        imgView.image = img;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        [self.scrollView addSubview:imgView];

        imageNum++;
    }
    
    self.scrollView.delegate = self;
    
    //Set up paging
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentOffset = CGPointMake([self.imageIndex intValue] * pageSize.width, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat floatPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    self.imageIndex = [NSNumber numberWithInt:(int) floatPage];
}


@end
