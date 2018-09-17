//
//  HMRoomViewController.m
//  HMWebRTC_Example
//
//  Created by TRAN DIEP Hue Man on 5/21/18.
//  Copyright © 2018 TRAN DIEP Hue Man. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import "WebRTC/RTCAudioSession.h"
#import "WebRTC/RTCAudioSessionConfiguration.h"
#import "WebRTC/RTCDispatcher.h"
#import "WebRTC/RTCLogging.h"

#import "HMWebRTC/ARDSettingsModel.h"

#import "HMRoomViewController.h"
#import "HMWebRTC/HMVideoCallViewController.h"

@interface HMRoomViewController ()<UITextFieldDelegate, HMVideoCallViewControllerDelegate, RTCAudioSessionDelegate>

@end

@implementation HMRoomViewController {
    AVAudioPlayer *_audioPlayer;
    BOOL _useManualAudio;
}

@synthesize roomText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.roomText.delegate = self;
    
    // Setup audio session
    RTCAudioSessionConfiguration *webRTCConfig =
    [RTCAudioSessionConfiguration webRTCConfiguration];
    webRTCConfig.categoryOptions = webRTCConfig.categoryOptions |
    AVAudioSessionCategoryOptionDefaultToSpeaker;
    [RTCAudioSessionConfiguration setWebRTCConfiguration:webRTCConfig];
    
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    [session addDelegate:self];
    
    [self configureAudioSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doCallRoom:(UIButton *)sender {
    // Trim whitespaces.
    NSString *room = roomText.text;
    NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedRoom = [room stringByTrimmingCharactersInSet:whitespaceSet];
    
    // Check that room name is valid.
    NSError *error = nil;
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"\\w+"
                                              options:options
                                                error:&error];
    if (error) {
        [self showAlertWithMessage:error.localizedDescription];
        return;
    }
    NSRange matchRange =
    [regex rangeOfFirstMatchInString:trimmedRoom
                             options:0
                               range:NSMakeRange(0, trimmedRoom.length)];
    if (matchRange.location == NSNotFound ||
        matchRange.length != trimmedRoom.length) {
        [self showAlertWithMessage:@"Invalid room name."];
        return;
    }
    
    ARDSettingsModel *settingsModel = [[ARDSettingsModel alloc] init];
    
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    session.useManualAudio = [settingsModel currentUseManualAudioConfigSettingFromStore];
    session.isAudioEnabled = NO;
    
    // Start a room call
    NSLog(@"Starting calling room %@", roomText.text);
    
    HMVideoCallViewController *videoCallViewController =
    [[HMVideoCallViewController alloc] initForRoom:trimmedRoom
                                         isLoopback:NO
                                           delegate:self];
    videoCallViewController.modalTransitionStyle =
    UIModalTransitionStyleCrossDissolve;
    [self presentViewController:videoCallViewController
                       animated:YES
                     completion:nil];
}

#pragma mark - Private

- (void)configureAudioSession {
    RTCAudioSessionConfiguration *configuration =
    [[RTCAudioSessionConfiguration alloc] init];
    configuration.category = AVAudioSessionCategoryAmbient;
    configuration.categoryOptions = AVAudioSessionCategoryOptionDuckOthers;
    configuration.mode = AVAudioSessionModeDefault;
    
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    [session lockForConfiguration];
    BOOL hasSucceeded = NO;
    NSError *error = nil;
    if (session.isActive) {
        hasSucceeded = [session setConfiguration:configuration error:&error];
    } else {
        hasSucceeded = [session setConfiguration:configuration
                                          active:YES
                                           error:&error];
    }
    if (!hasSucceeded) {
        NSLog(@"Error setting configuration: %@", error.localizedDescription);
    }
    [session unlockForConfiguration];
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

#pragma mark - HMVideoCallViewControllerDelegate

- (void)viewControllerDidFinish:(HMVideoCallViewController *)viewController {
    if (![viewController isBeingDismissed]) {
        NSLog(@"Dismissing VC");
        [self dismissViewControllerAnimated:YES completion:^{
//            [self restartAudioPlayerIfNeeded];
        }];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    session.isAudioEnabled = NO;
}

#pragma mark - RTCAudioSessionDelegate

- (void)audioSessionDidStartPlayOrRecord:(RTCAudioSession *)session {
    // Stop playback on main queue and then configure WebRTC.
    [RTCDispatcher dispatchAsyncOnType:RTCDispatcherTypeMain
                                 block:^{
//                                     if (_mainView.isAudioLoopPlaying) {
//                                         NSLog(@"Stopping audio loop due to WebRTC start.");
//                                         [_audioPlayer stop];
//                                     }
                                     NSLog(@"Setting isAudioEnabled to YES.");
                                     session.isAudioEnabled = YES;
                                 }];
}

- (void)audioSessionDidStopPlayOrRecord:(RTCAudioSession *)session {
    // WebRTC is done with the audio session. Restart playback.
    [RTCDispatcher dispatchAsyncOnType:RTCDispatcherTypeMain
                                 block:^{
                                     NSLog(@"audioSessionDidStopPlayOrRecord");
//                                     [self restartAudioPlayerIfNeeded];
                                 }];
}

#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"Text field did begin editing");
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Text field ended editing");
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSString*)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"startRTC"]) {
//        HMVideoCallViewController *viewController = (HMVideoCallViewController *)[segue destinationViewController];
//        [viewController initForRoom:sender isLoopback:NO delegate:self];
//    }
//}

@end
