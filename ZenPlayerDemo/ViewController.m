//
//  ViewController.m
//  ZenPlayerDemo
//
//  Created by noradaiko on 7/17/12.
//  Copyright (c) 2012 noradaiko. All rights reserved.
//

#import "ViewController.h"
#import "debug.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize zenPlayerButton=_zenPlayerButton;
@synthesize player = _player;
@synthesize timerProgress = _timerProgress;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create new zen player button
    self.zenPlayerButton = [[ZenPlayerButton alloc] initWithFrame:CGRectMake(108, 178, 104, 104)];
    // listening to tap event on the button
    [self.zenPlayerButton addTarget:self
                             action:@selector(zenPlayerButtonDidTouchUpInside:) 
                   forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.zenPlayerButton];
    [self queryMusic];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{
    NSLog(@"ViewController dealloc\n");
    [self.player endGeneratingPlaybackNotifications];
}

- (void) updateTime:(NSTimer *)timer
{
    if(self.player.playbackState == MPMusicPlaybackStatePlaying)
    {
        CGFloat progress = [self.player currentPlaybackTime] / [[self.player.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration] doubleValue];
        self.zenPlayerButton.progress = progress;
        NSLog(@"progress : %f\n", progress);
    }
}

- (void) queryMusic
{
    MPMediaQuery *q = [[MPMediaQuery alloc] init];
    [q addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType]];
    [q setGroupingType:MPMediaGroupingTitle];
    
    self.player = [MPMusicPlayerController applicationMusicPlayer];
    [self.player setRepeatMode:MPMusicRepeatModeAll];
    [self.player setShuffleMode:MPMusicShuffleModeSongs];
    [self.player setQueueWithQuery: q];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleItemChanged:) 
                                                 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleStateChanged:)
                                                 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                               object:nil];
    
    [self.player beginGeneratingPlaybackNotifications];
}

- (IBAction) rewind:(id)sender;
{
    self.zenPlayerButton.progress = 0.0f;
}

- (IBAction) forward:(id)sender;
{
    self.zenPlayerButton.progress += 0.1f;
}

- (IBAction) changeState:(id)sender;
{
    self.zenPlayerButton.state = ZenPlayerButtonStatePlaying;
}

- (void) zenPlayerButtonDidTouchUpInside:(id)sender;
{
    LOG_CURRENT_METHOD;
    if(self.zenPlayerButton.state == ZenPlayerButtonStateNormal)
    {
        [self.player pause];
        [self.timerProgress invalidate];
    }
    else
    {
        [self.player play];
        self.timerProgress = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                                              target:self 
                                                            selector:@selector(updateTime:) 
                                                            userInfo:nil 
                                                             repeats:YES];
        self.zenPlayerButton.state = ZenPlayerButtonStatePlaying;
    }
}

#pragma mark -- MPMusicPlayerController Notifications
- (void)handleItemChanged:(id)notification
{
    NSLog(@"ItemChanged:\n");
    if(self.player.playbackState == MPMusicPlaybackStatePlaying)
    {
        self.zenPlayerButton.state = ZenPlayerButtonStateLoading;
        self.zenPlayerButton.state = ZenPlayerButtonStatePlaying;
    }
}

- (void)handleStateChanged:(id)notification
{
    NSLog(@"StateChanged:%d\n", self.player.playbackState);
    
}

@end
