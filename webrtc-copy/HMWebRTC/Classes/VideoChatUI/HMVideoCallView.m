//
//  HMVideoCallView.m
//  HMWebRTC_Example
//
//  Created by TRAN DIEP Hue Man on 5/22/18.
//  Copyright © 2018 TRAN DIEP Hue Man. All rights reserved.
//

#import "HMVideoCallView.h"

#import <AVFoundation/AVFoundation.h>

#import <WebRTC/RTCEAGLVideoView.h>
#import <WebRTC/RTCMTLVideoView.h>

@interface HMVideoCallView () <RTCEAGLVideoViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end

@implementation HMVideoCallView {
    CGSize _remoteVideoSize;
}

@synthesize statusLabel = _statusLabel;
@synthesize localVideoView = _localVideoView;
@synthesize remoteVideoView = _remoteVideoView;
@synthesize delegate = _delegate;

@synthesize audioBtn = _audioBtn;
@synthesize cameraBtn = _cameraBtn;
@synthesize callBtn = _callBtn;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customInit];
        
        _remoteVideoView.delegate = self;
        
        UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(didTripleTap:)];
        tapRecognizer.numberOfTapsRequired = 3;
        [self addGestureRecognizer:tapRecognizer];
    }
    
    return self;
}

#pragma mark - RTCEAGLVideoViewDelegate

- (void)videoView:(RTCEAGLVideoView*)videoView didChangeVideoSize:(CGSize)size {
    if (videoView == _remoteVideoView) {
        _remoteVideoSize = size;
    }
    [self setNeedsLayout];
}

#pragma mark - Private

- (void)customInit {
    [[NSBundle bundleForClass:self.classForCoder] loadNibNamed:@"VideoCallXib" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}

- (void)didTripleTap:(UITapGestureRecognizer *)recognizer {
    [_delegate videoCallViewDidEnableStats:self];
}

- (IBAction)onAudioSwitch:(UIButton *)sender {
    [_delegate videoCallViewDidSwitchAudio:self];
}

- (IBAction)onCameraSwitch:(UIButton *)sender {
    [_delegate videoCallViewDidSwitchCamera:self];
}

- (IBAction)onHangup:(UIButton *)sender {
    [_delegate videoCallViewDidHangup:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
