//
//  ViewController.m
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

//Header
#import "VideoPickerCollectionViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoPickerCollectionViewController ()

@property ALAssetsLibrary* assetLibrary;
@property NSMutableArray* videoArray; //Array of ALAsset objects
@end

@implementation VideoPickerCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Set up asset Library
    self.assetLibrary = [[ALAssetsLibrary alloc] init];
    
    //Set up CollectionView
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}


- (void) viewDidAppear:(BOOL)animated {
    [self getVideosAndReload];
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

#pragma mark - Get Assets
- (void) getVideosAndReload {
    
    if([ALAssetsLibrary authorizationStatus])
    {
        //Library Access code goes here
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission Denied" message:@"Please allow the application to access your photo and videos in settings panel of your device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        
        //Clear the array
        self.videoArray = [NSMutableArray array];
        
        return;
    }
    
    
    //Since we're using ALAAssetsGroupAll, this will get called once with a valid group and once with a nil (presumably the nil is a sentinel)
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if(group)
        {
            //Get videos
            self.videoArray = [self getContentFrom:group withAssetFilter:[ALAssetsFilter allVideos]];
            [self.collectionView reloadData];
            DebugLog(@"self.videoArray = [%@]", self.videoArray);
        }
        
    } failureBlock:^(NSError *error) {
        DebugLog(@"Error Description %@",[error description]);
    }];
}


-(NSMutableArray *) getContentFrom:(ALAssetsGroup *) group withAssetFilter:(ALAssetsFilter *)filter
{
    NSMutableArray *contentArray = [NSMutableArray array];
    [group setAssetsFilter:filter];
    
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        //ALAssetRepresentation holds all the information about the asset being accessed.
        if(result)
        {
            //Add the values to photos array.
            [contentArray addObject:result];
        }
    }];
    return contentArray;
}



#pragma mark - UICollectionViewDataSource 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videoArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    ALAsset* asset = [self.videoArray objectAtIndex:indexPath.row];
    
    UIImage* thumbnail = [UIImage imageWithCGImage:asset.thumbnail];
    cell.backgroundColor = [UIColor colorWithPatternImage:thumbnail];
    return cell;
    
}

#pragma mark - UICollectionView

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DebugLog(@"Touched Cell = [%lu]", indexPath.row);
}





@end
