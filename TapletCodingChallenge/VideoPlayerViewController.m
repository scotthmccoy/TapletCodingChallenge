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
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(showImages:)];
    self.navigationItem.rightBarButtonItem = nextButton;

    


    


}

- (void) viewDidAppear:(BOOL)animated {
    NSURL* contentURL = [[self.selectedAsset defaultRepresentation] url];
    self.player = [[MPMoviePlayerController alloc] initWithContentURL: contentURL];
    [self.player prepareToPlay];
    [self.player.view setFrame: self.view.bounds];  // player's frame must match parent's
    [self.view addSubview: self.player.view];
    [self.player play];
}


#pragma mark - Button Callbacks 

- (void) showImages:(id) sender {
    DebugLogWhereAmI();
}

@end
