//
//  ExtractedImagesCollectionCollectionViewController.m
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

//Header
#import "ExtractedImagesCollectionViewController.h"

//Other
#import "CollectionViewCellWithImage.h"
#import "ExtractedImageScrollViewController.h"

//Constants
static NSString* segueIdendifier = @"showSingleImage";


@interface ExtractedImagesCollectionViewController ()
@property NSNumber* imageIndex;
@end

@implementation ExtractedImagesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Choose an Image";
    
    // Register cell classes
    [self.collectionView registerClass:[CollectionViewCellWithImage class] forCellWithReuseIdentifier:reuseIdentifier];
}

//TODO: Have collectionView change cell sizes after rotation


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.extractedImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCellWithImage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImage* thumbnail = [self.extractedImages objectAtIndex:indexPath.row];
    cell.imageView.image = thumbnail;
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.imageIndex = [NSNumber numberWithInteger:indexPath.row];
    [self performSegueWithIdentifier:segueIdendifier sender:self];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:segueIdendifier])
    {
        ExtractedImageScrollViewController* vc = (ExtractedImageScrollViewController*)segue.destinationViewController;
        vc.extractedImages = self.extractedImages;
        vc.imageIndex = self.imageIndex;
    }
}



#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat length = fmin(self.view.bounds.size.width, self.view.bounds.size.height) / 3;
    return CGSizeMake(length, length);
}

@end
