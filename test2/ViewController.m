//
//  ViewController.m
//  test2
//
//  Created by APPLE on 2017/6/30.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
@property (strong, nonatomic) MPMusicPlayerController *musicPlayerController; //音乐播放器
@property (assign, nonatomic) MPMusicPlaybackState musicPlaybackState; //播放状态
@property (strong, nonatomic) MPMediaQuery *query; //媒体队列
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) MPMediaItem *myTrack;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupApplicationAudio];
    
    self.musicPlayerController = [MPMusicPlayerController systemMusicPlayer];
//    [self initButton0];
    [self initButton1Pause];
    [self initButton2Continue];
    [self initButton3IncreaseVolume];
    [self initButton4DecreaseVolume];
    [self initButton5NextSong];
    [self initButton6PreSong];
    
}

- (void)setupApplicationAudio {
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    UInt32 mix = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(mix), &mix);
    
//    NSError *activationError = nil;
//    [session setActive: YES error: &activationError];
}

- (void)initButton0 {
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake(20.0, 100, 100.0, 60.0)];
    [btn setTitle:@"切换控制器" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(buttonAct0:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
}

- (void)initButton1Pause {
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake((375-100.0)/2, 60, 100.0, 60.0)];
    [btn setTitle:@"点击暂停" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(buttonAct1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
}

- (void)initButton2Continue {
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake((375-100.0)/2, 160, 100.0, 60.0)];
    [btn setTitle:@"点击播放" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(buttonAct2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
}

- (void)initButton3IncreaseVolume {
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake((375-100.0)/2, 260, 100.0, 60.0)];
    [btn setTitle:@"提升音量" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(buttonAct3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
}

- (void)initButton4DecreaseVolume {
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake((375-100.0)/2, 360, 100.0, 60.0)];
    [btn setTitle:@"减小音量" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(buttonAct4:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
}

- (void)initButton5NextSong {
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake((375-100.0)/2, 460, 100.0, 60.0)];
    [btn setTitle:@"下一首" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(buttonAct5:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
}

- (void)initButton6PreSong {
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake((375-100.0)/2, 560, 100.0, 60.0)];
    [btn setTitle:@"上一首" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(buttonAct6:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
}

- (void)buttonAct0:(UIButton *)btn {
    BOOL isSystemPlayerController = self.musicPlayerController == [MPMusicPlayerController systemMusicPlayer];
    if (isSystemPlayerController) {
        self.musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
    } else {
        self.musicPlayerController = [MPMusicPlayerController systemMusicPlayer];
    }
}

- (void)buttonAct1:(UIButton *)btn { // 暂停音乐
    AVAudioSession *avAudioSession = [AVAudioSession sharedInstance];
//    [avAudioSession setCategory: AVAudioSessionCategoryPlayback error:nil];
    [avAudioSession setActive:YES error:nil];
}

- (void)buttonAct2:(UIButton *)btn {
    AVAudioSession *avAudioSession = [AVAudioSession sharedInstance];
    [avAudioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (void)buttonAct3:(UIButton *)btn { // 下一首
    float interval = 0.0625;
    float preVolume = [[MPMusicPlayerController systemMusicPlayer] volume];
    [[MPMusicPlayerController systemMusicPlayer] setVolume: preVolume + interval];
}

- (void)buttonAct4:(UIButton *)btn { // 下一首
    float interval = 0.0625;
    float preVolume = [[MPMusicPlayerController systemMusicPlayer] volume];
    [[MPMusicPlayerController systemMusicPlayer] setVolume: preVolume - interval];
}

- (void)buttonAct5:(UIButton *)btn { // 下一首
    NSLog(@"before:%ld", _musicPlayerController.indexOfNowPlayingItem);
    if ( ([_musicPlayerController playbackState]== MPMusicPlaybackStatePlaying ) ||
         ([_musicPlayerController playbackState]== MPMusicPlaybackStateStopped ) ||
         ([_musicPlayerController playbackState]== MPMusicPlaybackStatePaused ) )
    {
        [_musicPlayerController skipToNextItem];
        [_musicPlayerController play];
        NSLog(@"after:%ld", _musicPlayerController.indexOfNowPlayingItem);
    }
}

- (void)buttonAct6:(UIButton *)btn { // 下一首
    NSLog(@"before:%ld", _musicPlayerController.indexOfNowPlayingItem);
    if ( ([_musicPlayerController playbackState]== MPMusicPlaybackStatePlaying ) ||
        ([_musicPlayerController playbackState]== MPMusicPlaybackStateStopped ) ||
        ([_musicPlayerController playbackState]== MPMusicPlaybackStatePaused ) )
    {
        [_musicPlayerController skipToPreviousItem];
        NSLog(@"after:%ld", _musicPlayerController.indexOfNowPlayingItem);
    }
}

@end
