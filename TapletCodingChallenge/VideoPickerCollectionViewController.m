//
//  ViewController.m
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

//Header
#import "VideoPickerCollectionViewController.h"

//Other
#import <AssetsLibrary/AssetsLibrary.h>
#import "VideoPlayerViewController.h"

//Constants
NSString* cellIdentifier = @"Cell";
NSString* segueIdendifier = @"showVideo";


@interface VideoPickerCollectionViewController ()

@property ALAssetsLibrary* assetLibrary;
@property NSMutableArray* videoArray; //Array of ALAsset objects
@property ALAsset* selectedAsset;
@end

@implementation VideoPickerCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Set up asset Library
    self.assetLibrary = [[ALAssetsLibrary alloc] init];
    
    //Set up CollectionView
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
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
    
    //Prompt for
    
    switch([ALAssetsLibrary authorizationStatus]) {
        case ALAuthorizationStatusRestricted:
        case ALAuthorizationStatusDenied:
        {
            [self cameraRollAccessDeniedAlertView];
            
            //Clear the array
            self.videoArray = [NSMutableArray array];
            
            return;
        }
            
        case ALAuthorizationStatusNotDetermined: // User has not yet made a choice with regards to this application
        case ALAuthorizationStatusAuthorized:
        default:
            break;
    }

    

    
    
    //Since we're using ALAAssetsGroupAll, this will get called once with a valid group and once with a nil (presumably the nil is a sentinel)
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if(group)
        {
            //Get videos
            self.videoArray = [self getContentFrom:group withAssetFilter:[ALAssetsFilter allVideos]];
            
            if ([self.videoArray count] == 0) {
                DebugLog(@"No Videos");
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"You don't have any videos" message:@"You should probably record some!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [av show];
                
                //TODO: Have this run a tutorial to record videos
            }
            
            [self.collectionView reloadData];
            //DebugLog(@"self.videoArray = [%@]", self.videoArray);
        }
        
    } failureBlock:^(NSError *error) {
        DebugLog(@"Error Description %@",[error description]);
        
        //TODO: Check this code
        if ([error code] == -3311) {
            [self cameraRollAccessDeniedAlertView];
        }
    }];
}


- (NSMutableArray *) getContentFrom:(ALAssetsGroup *) group withAssetFilter:(ALAssetsFilter *)filter
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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    ALAsset* asset = [self.videoArray objectAtIndex:indexPath.row];
    
    UIImage* thumbnail = [UIImage imageWithCGImage:asset.thumbnail];
    cell.backgroundColor = [UIColor colorWithPatternImage:thumbnail];
    return cell;
    
}

#pragma mark - UICollectionView

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DebugLog(@"Touched Cell = [%i]", indexPath.row);
    
    //Get the asset and push the next VC
    ALAsset* asset = [self.videoArray objectAtIndex:indexPath.row];
    self.selectedAsset = asset;
    [self performSegueWithIdentifier:segueIdendifier sender:self];
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:segueIdendifier])
    {
        VideoPlayerViewController* vc = (VideoPlayerViewController*)segue.destinationViewController;
        vc.selectedAsset = self.selectedAsset;
    }
}

#pragma mark - Camera Roll Access Prompt
- (void) cameraRollAccessDeniedAlertView {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Can't Access Camera Roll" message:@"Would you like to go to the Settings App to re-enable camera roll access?" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Yes, Please!", nil];
    [av show];
}

#pragma mark - UIAlertViewDelegate methods
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DebugLog(@"ButtonIndex: [%i]", buttonIndex);
    
    if (buttonIndex != 1)
        return;
    
    //TODO: open the Settings App
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


@end
