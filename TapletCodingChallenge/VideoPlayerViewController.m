//
//  VideoPlayerViewController.m
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

//Header
#import "VideoPlayerViewController.h"

//Other
@import MediaPlayer;

@interface VideoPlayerViewController ()
@property MPMoviePlayerController* player;
@property UIBarButtonItem* nextButton;
@property NSMutableArray* imagesSaved;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Set up NextButton
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(showImages:)];
    self.navigationItem.rightBarButtonItem = self.nextButton;

    //Set up array to contain pulled images
    self.imagesSaved = [[NSMutableArray alloc] init];
    
    //Listen for MPMoviePlayerThumbnailImageRequestDidFinishNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observer_MPMoviePlayerThumbnailImageRequestDidFinishNotification:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    
    //Create Video Player
    NSURL* contentURL = [[self.selectedAsset defaultRepresentation] url];
    self.player = [[MPMoviePlayerController alloc] initWithContentURL: contentURL];
    [self.player prepareToPlay];
    UIView* playerView = self.player.view;
    [playerView setFrame: self.view.bounds];  // player's frame must match parent's
    [self.view addSubview: playerView];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.player play];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    DebugLogWhereAmI();
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        //Update the player's frame
        [self.player.view setFrame: self.view.bounds];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
         
    }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


#pragma mark - Button Callbacks
- (void) showImages:(id) sender {
    if ([self.imagesSaved count] == 0) {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"No Images Selected" message:@"Tap the screen to select some images!" delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
        [av show];
    }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //Request a thumbnail
    NSNumber* currentPlayTime = [NSNumber numberWithDouble:self.player.currentPlaybackTime];
    NSArray* currentPlayTimeArray = [NSArray arrayWithObject:currentPlayTime];
    [self.player requestThumbnailImagesAtTimes:currentPlayTimeArray timeOption:MPMovieTimeOptionExact];
    
    //Call Super
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Observers
- (void) observer_MPMoviePlayerThumbnailImageRequestDidFinishNotification:(id)notification {
    DebugLogWhereAmI();
    NSDictionary* userInfo = [notification userInfo];
    UIImage* img = [userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
    
    //Queue up addObject calls to imagesSaved since it's not thread safe
    dispatch_async(dispatch_get_main_queue(), ^(void){
        DebugLogWhereAmI();
        [self.imagesSaved addObject:img];
        self.nextButton.title = [NSString stringWithFormat:@"Next (%i)", self.imagesSaved.count];
        
        [UIView animateWithDuration:2.0 animations:^{
            self.nextButton.tintColor = [UIColor blueColor];
        } completion:NULL];
        
    });
    
}



@end
