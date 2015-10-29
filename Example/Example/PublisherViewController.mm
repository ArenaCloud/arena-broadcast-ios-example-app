//
//  PublisherViewController.m
//  Example
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 ArenaCloud.com. All rights reserved.
//

#import "PublisherViewController.h"
#import <ArenaCloud/broadcast/ArenaCloudBroadcast.h>
#import <AVFoundation/AVFoundation.h>

@interface PublisherViewController ()

@end

@implementation PublisherViewController

- (void)viewDidLoad
{
    //-- A/V setup
    self.orientationLocked = NO; // set to YES to turn off rotation support in UI
    self.videoSize = CGSizeMake(720, 1280);
    self.framesPerSecond = 30;
    self.videoBitRate = 1500000;
    self.sampleRateInHz = 44100; // either 44100 or 22050

    // must be called _after_ we set up our properties, as our superclass
    // will use them in its viewDidLoad method
    [super viewDidLoad];

    //-- ArenaCloud.com setup

    // read our ArenaCloud.com configuration from a plist bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"broadcast-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"settings: %@", settings);

    // create a new ACBRClient to fetch our stream information
    ACBRClient *client = [[ACBRClient alloc] init];
    client.projectPublicKey = settings[@"PROJECT_PUBLIC_KEY"];
    [self updateStatus:@"Configuring stream using ArenaCloud.com..."];
    [client getStream:settings[@"STREAM_ID"]
           byPassword:settings[@"STREAM_PASSWORD"]
        withCompletionHandler:^(NSError *error, ACBRStream *stream) {
        if (error) {
            [self updateStatus:@"ERROR: couldn't get stream information from ArenaCloud.com"];
        } else {
            self.publishUrl = [stream publishUrl];
            self.publishStreamName = [stream publishStreamName];

            // once we've fully-configured our properties, we can enable the
            // UI controls on our view
            [self enableControls];
            
            // take a screen shot, for example
            [self takeScreenShot];
        }
    }];
}

- (void)toggleStreaming:(id)sender
{
    switch(self.streamState) {
        case ACBRStreamStateNone:
        case ACBRStreamStatePreviewStarted:
        case ACBRStreamStateEnded:
        case ACBRStreamStateError:
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            break;
        default:
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            break;
    }
    
    // start / stop the actual stream
    [super toggleStreaming:sender];
}

- (void)didGotScreenShot:(CGImageRef)image
{
    [super didGotScreenShot:image];

    // save screenshot
    if (image != nil)
    {
        UIImage *uiImage = [UIImage imageWithCGImage:image];
        
        NSData* imageData = UIImagePNGRepresentation(uiImage);
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        // Now we get the full path to the file
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"ScreenShot.png"];
        // and then we write it out
        [imageData writeToFile:fullPathToFile atomically:NO];
    }
}

@end
