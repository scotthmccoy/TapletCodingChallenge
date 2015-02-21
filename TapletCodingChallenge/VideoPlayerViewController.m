//
//  VideoPlayerViewController.m
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

//Header
#import "VideoPlayerViewController.h"

//VCs
#import "ExtractedImagesCollectionViewController.h"

//Other
@import MediaPlayer;

//Constants
static NSString* segueIdendifier = @"showExtractedImages";


@interface VideoPlayerViewController ()
@property MPMoviePlayerController* player;
@property UIBarButtonItem* nextButton;
@property NSMutableArray* extractedImages;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Set up NextButton
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(showExtractedImages:)];
    self.navigationItem.rightBarButtonItem = self.nextButton;

    //Set up array to contain pulled images
    self.extractedImages = [[NSMutableArray alloc] init];
    
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

//This handles rotations
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
- (void) showExtractedImages:(id) sender {
    if ([self.extractedImages count] == 0) {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"No Images Selected" message:@"Tap the screen to select some images!" delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    [self performSegueWithIdentifier:segueIdendifier sender:self];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:segueIdendifier])
    {
        ExtractedImagesCollectionViewController* vc = (ExtractedImagesCollectionViewController*)segue.destinationViewController;
        vc.extractedImages = self.extractedImages;
    }
}

#pragma mark - Touches
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
    //DebugLogWhereAmI();
    NSDictionary* userInfo = [notification userInfo];
    UIImage* img = [userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
    
    //Queue up addObject calls to imagesSaved since it's not thread safe
    dispatch_async(dispatch_get_main_queue(), ^(void){

        //Check if we're the topmost VC. Otherwise, we don't want to mutate extractedImages.
        if ([self.navigationController.viewControllers lastObject] != self)
        {
            DebugLog(@"Notification received while not top VC. Bailing.");
        }

        [self.extractedImages addObject:img];
        self.nextButton.title = [NSString stringWithFormat:@"Next (%i)", self.extractedImages.count];
        
        [UIView animateWithDuration:2.0 animations:^{
            self.nextButton.tintColor = [UIColor blueColor];
        } completion:NULL];
        
    });
    
}



@end
