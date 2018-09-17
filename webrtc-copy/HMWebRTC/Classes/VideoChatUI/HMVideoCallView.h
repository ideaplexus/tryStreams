//
//  HMVideoCallView.h
//  HMWebRTC_Example
//
//  Created by TRAN DIEP Hue Man on 5/22/18.
//  Copyright © 2018 TRAN DIEP Hue Man. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebRTC/RTCCameraPreviewView.h>
#import <WebRTC/RTCVideoRenderer.h>
#import <WebRTC/RTCEAGLVideoView.h>

@class HMVideoCallView;
@protocol HMVideoCallViewDelegate <NSObject>

// Called when the camera switch button is pressed.
- (void)videoCallViewDidSwitchCamera:(HMVideoCallView *)view;

// Called when the route change button is pressed.
- (void)videoCallViewDidChangeRoute:(HMVideoCallView *)view;

// Called when the audio switch button is pressed.
- (void)videoCallViewDidSwitchAudio:(HMVideoCallView *)view;

// Called when the hangup button is pressed.
- (void)videoCallViewDidHangup:(HMVideoCallView *)view;

// Called when stats are enabled by triple tapping.
- (void)videoCallViewDidEnableStats:(HMVideoCallView *)view;

@end

// Video call view that shows local and remote video, provides a label to
// display status, and also a hangup button.
@interface HMVideoCallView : UIView
@property(nonatomic, weak) id<HMVideoCallViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet RTCEAGLVideoView *remoteVideoView;
@property (weak, nonatomic) IBOutlet RTCCameraPreviewView *localVideoView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@end
