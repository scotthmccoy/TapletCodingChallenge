//
//  ExtractedImageScrollViewController.h
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtractedImageScrollViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property NSArray* extractedImages;
@property NSNumber* imageIndex;
@end
