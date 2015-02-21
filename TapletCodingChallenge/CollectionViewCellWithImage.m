//
//  CollectionViewCellWithImage.m
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

//Header
#import "CollectionViewCellWithImage.h"

//Other
#import <QuartzCore/QuartzCore.h>

@implementation CollectionViewCellWithImage

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    //Set up imageView
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview: self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;

    //Add Border
    self.layer.borderWidth=1.0f;
    self.layer.borderColor=[UIColor grayColor].CGColor;
    
    return self;
}

@end
