//
//  ExtractedImagesCollectionCollectionViewController.m
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

#import "ExtractedImagesCollectionViewController.h"

@interface ExtractedImagesCollectionViewController ()

@end

@implementation ExtractedImagesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.extractedImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImage* thumbnail = [self.extractedImages objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor colorWithPatternImage:thumbnail];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


@end
