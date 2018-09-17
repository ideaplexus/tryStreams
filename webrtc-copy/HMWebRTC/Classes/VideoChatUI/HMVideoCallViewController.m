//
//  HMVideoCallViewController.m
//  HMWebRTC_Example
//
//  Created by TRAN DIEP Hue Man on 5/22/18.
//  Copyright © 2018 TRAN DIEP Hue Man. All rights reserved.
//

#import "HMVideoCallViewController.h"

#import "WebRTC/RTCAudioSession.h"
#import "WebRTC/RTCCameraVideoCapturer.h"
#import "WebRTC/RTCDispatcher.h"
#import "WebRTC/RTCLogging.h"
#import "WebRTC/RTCMediaConstraints.h"

#import "HMWebRTC/ARDAppClient.h"
#import "HMWebRTC/ARDCaptureController.h"
#import "HMWebRTC/ARDSettingsModel.h"

#import "HMVideoCallView.h"

@interface HMVideoCallViewController () <ARDAppClientDelegate, HMVideoCallViewDelegate, RTCAudioSessionDelegate>
@property(nonatomic, strong) RTCVideoTrack *remoteVideoTrack;
@property(nonatomic, strong) IBOutlet HMVideoCallView *videoCallView;
@end

@implementation HMVideoCallViewController {
    ARDAppClient *_client;
    RTCVideoTrack *_remoteVideoTrack;
    ARDCaptureController *_captureController;
    AVAudioSessionPortOverride _portOverride;
}

@synthesize videoCallView = _videoCallView;
@synthesize remoteVideoTrack = _remoteVideoTrack;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (instancetype)initForRoom:(NSString *)room
                 isLoopback:(BOOL)isLoopback
                   delegate:(id<HMVideoCallViewControllerDelegate>)delegate {
    ARDSettingsModel *settingsModel = [[ARDSettingsModel alloc] init];
    _delegate = delegate;
    
    _client = [[ARDAppClient alloc] initWithDelegate:self];
    [_client connectToRoomWithId:room settings:settingsModel isLoopback:isLoopback];
    return self;
}

- (void)loadView {
    _videoCallView = [[HMVideoCallView alloc] initWithFrame:CGRectZero];
    _videoCallView.delegate = self;
    _videoCallView.statusLabel.text =
    [self statusTextForState:RTCIceConnectionStateNew];
    self.view = _videoCallView;
    
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    [session addDelegate:self];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - ARDAppClientDelegate

- (void)appClient:(ARDAppClient *)client
   didChangeState:(ARDAppClientState)state {
    switch (state) {
        case kARDAppClientStateConnected:
            NSLog(@"Client connected.");
            break;
        case kARDAppClientStateConnecting:
            NSLog(@"Client connecting.");
            break;
        case kARDAppClientStateDisconnected:
            NSLog(@"Client disconnected.");
            [self hangup];
            break;
    }
}

- (void)appClient:(ARDAppClient *)client
didChangeConnectionState:(RTCIceConnectionState)state {
    NSLog(@"ICE state changed: %ld", (long)state);
    __weak HMVideoCallViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        HMVideoCallViewController *strongSelf = weakSelf;
        strongSelf.videoCallView.statusLabel.text =
        [strongSelf statusTextForState:state];
    });
}

- (void)appClient:(ARDAppClient *)client
didCreateLocalCapturer:(RTCCameraVideoCapturer *)localCapturer {
    _videoCallView.localVideoView.captureSession = localCapturer.captureSession;
    ARDSettingsModel *settingsModel = [[ARDSettingsModel alloc] init];
    _captureController =
    [[ARDCaptureController alloc] initWithCapturer:localCapturer settings:settingsModel];
    [_captureController startCapture];
}

- (void)appClient:(ARDAppClient *)client
didCreateLocalFileCapturer:(RTCFileVideoCapturer *)fileCapturer {
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
//    if (@available(iOS 10, *)) {
//        _fileCaptureController = [[ARDFileCaptureController alloc] initWithCapturer:fileCapturer];
//        [_fileCaptureController startCapture];
//    }
#endif
}

- (void)appClient:(ARDAppClient *)client
didReceiveLocalVideoTrack:(RTCVideoTrack *)localVideoTrack {
}

- (void)appClient:(ARDAppClient *)client
didReceiveRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack {
    self.remoteVideoTrack = remoteVideoTrack;
    __weak HMVideoCallViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        HMVideoCallViewController *strongSelf = weakSelf;
        strongSelf.videoCallView.statusLabel.hidden = YES;
    });
}

- (void)appClient:(ARDAppClient *)client
      didGetStats:(NSArray *)stats {
//    _videoCallView.statsView.stats = stats;
    [_videoCallView setNeedsLayout];
}

- (void)appClient:(ARDAppClient *)client
         didError:(NSError *)error {
    NSString *message =
    [NSString stringWithFormat:@"%@", error.localizedDescription];
    [self hangup];
    [self showAlertWithMessage:message];
}

#pragma mark - HMVideoCallViewDelegate

- (void)videoCallViewDidHangup:(HMVideoCallView *)view {
    [self hangup];
}

- (void)videoCallViewDidSwitchAudio:(HMVideoCallView *)view {
    
}

- (void)videoCallViewDidSwitchCamera:(HMVideoCallView *)view {
    // TODO(tkchin): Rate limit this so you can't tap continously on it.
    // Probably through an animation.
    [_captureController switchCamera];
}

- (void)videoCallViewDidChangeRoute:(HMVideoCallView *)view {
    AVAudioSessionPortOverride override = AVAudioSessionPortOverrideNone;
    if (_portOverride == AVAudioSessionPortOverrideNone) {
        override = AVAudioSessionPortOverrideSpeaker;
    }
    [RTCDispatcher dispatchAsyncOnType:RTCDispatcherTypeAudioSession
                                 block:^{
                                     RTCAudioSession *session = [RTCAudioSession sharedInstance];
                                     [session lockForConfiguration];
                                     NSError *error = nil;
                                     if ([session overrideOutputAudioPort:override error:&error]) {
                                         self->_portOverride = override;
                                     } else {
                                         NSLog(@"Error overriding output port: %@",
                                                     error.localizedDescription);
                                     }
                                     [session unlockForConfiguration];
                                 }];
}

- (void)videoCallViewDidEnableStats:(HMVideoCallView *)view {
    _client.shouldGetStats = YES;
//    _videoCallView.statsView.hidden = NO;
}

#pragma mark - RTCAudioSessionDelegate

- (void)audioSession:(RTCAudioSession *)audioSession
didDetectPlayoutGlitch:(int64_t)totalNumberOfGlitches {
    NSLog(@"Audio session detected glitch, total: %lld", totalNumberOfGlitches);
}

#pragma mark - Private

- (void)setRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack {
    if (_remoteVideoTrack == remoteVideoTrack) {
        return;
    }
    [_remoteVideoTrack removeRenderer:_videoCallView.remoteVideoView];
    _remoteVideoTrack = nil;
    [_videoCallView.remoteVideoView renderFrame:nil];
    _remoteVideoTrack = remoteVideoTrack;
    [_remoteVideoTrack addRenderer:_videoCallView.remoteVideoView];
}

- (void)hangup {
    self.remoteVideoTrack = nil;
    _videoCallView.localVideoView.captureSession = nil;
    [_captureController stopCapture];
    _captureController = nil;
    [_client disconnect];
    [_delegate viewControllerDidFinish:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)statusTextForState:(RTCIceConnectionState)state {
    switch (state) {
        case RTCIceConnectionStateNew:
        case RTCIceConnectionStateChecking:
            return @"Connecting...";
        case RTCIceConnectionStateConnected:
        case RTCIceConnectionStateCompleted:
        case RTCIceConnectionStateFailed:
        case RTCIceConnectionStateDisconnected:
        case RTCIceConnectionStateClosed:
        case RTCIceConnectionStateCount:
            return nil;
    }
}

- (void)showAlertWithMessage:(NSString*)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:nil
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action){
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
