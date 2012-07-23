//
//  ViewController.h
//  ZenPlayerDemo
//
//  Created by noradaiko on 7/17/12.
//  Copyright (c) 2012 noradaiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZenPlayerButton.h"

@interface ViewController : UIViewController {
    
}

@property (nonatomic, retain) ZenPlayerButton* zenPlayerButton;

@property (nonatomic, retain) MPMusicPlayerController *player;
@property (nonatomic) NSTimer *timerProgress;

- (void) updateTime:(NSTimer *)timer;
- (void) queryMusic;

- (IBAction) rewind:(id)sender;
- (IBAction) forward:(id)sender;
- (IBAction) changeState:(id)sender;
- (void) zenPlayerButtonDidTouchUpInside:(id)sender;


@end
