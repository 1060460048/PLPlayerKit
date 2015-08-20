//
//  AudioPlayerViewController.m
//  PLPlayerKit
//
//  Created by 0day on 15/8/16.
//  Copyright (c) 2015年 0dayZh. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>

static NSString *states[] = {
    @"Stopped",
    @"Preparing",
    @"Ready",
    @"Caching",
    @"Playing",
    @"Paused"
};

@interface AudioPlayerViewController ()
<
PLAudioPlayerControllerDelegate
>

@property (nonatomic, strong) PLAudioPlayerController   *audioPlayerController;

@end

@implementation AudioPlayerViewController

- (instancetype)initWithURL:(NSURL *)url parameters:(NSDictionary *)parameters {
    self = [super init];
    if (self) {
        self.url = url;
        self.parameters = parameters;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioPlayerController = [PLAudioPlayerController audioPlayerControllerWithContentURL:self.url
                                                                                   parameters:self.parameters];
    self.audioPlayerController.delegate = self;
//    self.audioPlayerController.backgroundPlayEnable = YES;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:PLAudioSessionRouteDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif) {
        NSLog(@"Recieved: %@", PLAudioSessionRouteDidChangeNotification);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:PLAudioSessionDidInterrupteNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif) {
        NSLog(@"Recieved: %@", PLAudioSessionDidInterrupteNotification);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.audioPlayerController stop];
    [super viewWillDisappear:animated];
}

#pragma mark - <PLAudioPlayerControllerDelegate>

- (void)audioPlayerController:(PLAudioPlayerController *)controller playerStateDidChange:(PLPlayerState)status {
    NSLog(@"%@", states[status]);
}

- (void)audioPlayerControllerWillBeginBackgroundTask:(PLAudioPlayerController *)controller {
    NSLog(@"Will begin background task");
}

- (void)audioPlayerController:(PLAudioPlayerController *)controller willEndBackgroundTask:(BOOL)isExpirationOccured {
    NSLog(@"Will end background task");
}

@end
