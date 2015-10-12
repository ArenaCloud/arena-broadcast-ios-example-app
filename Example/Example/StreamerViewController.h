//
//  StreamerViewController.h
//  Example
//
//  Created by Jeffrey Wescott on 6/18/14.
//  Copyright (c) 2014 ArenaCloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <ArenaCloud/broadcast/ArenaCloudBroadcast.h>

@interface StreamerViewController : ACBRPlayerViewController

@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)playButtonPressed:(id)sender;

@end
