//
//  ViewController.m
//  TapletCodingChallenge
//
//  Created by Scott McCoy on 2/20/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

//Header
#import "ViewController.h"

//Other
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) { // authorized
        [self takeFoto];
    }
    else if(status == AVAuthorizationStatusDenied){ // denied
        [self showCameraDeniedError];
    }
    else if(status == AVAuthorizationStatusRestricted){ // restricted
        [self showCameraDeniedError];
    }
    else if(status == AVAuthorizationStatusNotDetermined){ // not determined
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){ // Access has been granted ..do something
                [self takeFoto];
            } else {
                [self showCameraDeniedError];
            }
        }];
    }
     */
}

- (void) viewDidAppear:(BOOL)animated {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = NO;
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,      nil];
        picker.delegate = self;
        
        [self presentViewController:picker animated:NO completion:nil];
        
    } else {
        DebugLog(@"Photo Library Not Available!");
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    DebugLogWhereAmI();
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    DebugLogWhereAmI();    
}

@end
