//
//  ExtractedImageScrollViewController.m
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

#import "ExtractedImageScrollViewController.h"

@implementation ExtractedImageScrollViewController

- (void) loadView {
    [super loadView];
    
    self.scrollView.backgroundColor = [UIColor redColor];


    CGSize pageSize = self.scrollView.frame.size;
    
    self.scrollView.contentSize = CGSizeMake(pageSize.width * [self.extractedImages count], pageSize.height);
    
//    int imageNum = 0;
//    for (UIImage* img in self.extractedImages) {
//        
//        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageNum * pageSize.width, 0, pageSize.width, pageSize.height)];
//        imgView.image = img;
//        imgView.contentMode = UIViewContentModeScaleAspectFit;
//        imgView.clipsToBounds = YES;
//        [self.scrollView addSubview:imgView];
//        imgView.backgroundColor = [UIColor greenColor];
//    }
    

    self.scrollView.pagingEnabled = YES;

    


}

@end
