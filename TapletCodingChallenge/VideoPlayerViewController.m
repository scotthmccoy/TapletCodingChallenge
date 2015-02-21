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
    

    
    
    //Add Next Button
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(showImages:)];
    self.navigationItem.rightBarButtonItem = nextButton;

    //Create Video Player
    NSURL* contentURL = [[self.selectedAsset defaultRepresentation] url];
    self.player = [[MPMoviePlayerController alloc] initWithContentURL: contentURL];
    [self.player prepareToPlay];
    UIView* playerView = self.player.view;
    [playerView setFrame: self.view.bounds];  // player's frame must match parent's
    [self.view addSubview: playerView];
    

    ////////////
    //AutoLayout
    ////////////
    
//    UIView* parent = self.view;
//    parent.translatesAutoresizingMaskIntoConstraints = NO;
//    //playerView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    
//    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(playerView, parent);
//    
//    [self.view addConstraints: [NSLayoutConstraint
//                                 constraintsWithVisualFormat:@"|[playerView(parent)]|"
//                                 options:NSLayoutFormatAlignAllBaseline metrics:nil
//                                 views:viewsDictionary]];
    
    
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
    DebugLogWhereAmI();
}

@end
