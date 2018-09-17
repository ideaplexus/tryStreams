//
//  HMVideoCallViewController.h
//  HMWebRTC_Example
//
//  Created by TRAN DIEP Hue Man on 5/22/18.
//  Copyright © 2018 TRAN DIEP Hue Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMVideoCallViewController;
@protocol HMVideoCallViewControllerDelegate <NSObject>

- (void)viewControllerDidFinish:(HMVideoCallViewController *)viewController;

@end

@interface HMVideoCallViewController : UIViewController

@property(nonatomic, weak) id<HMVideoCallViewControllerDelegate> delegate;

- (instancetype)initForRoom:(NSString *)room
                 isLoopback:(BOOL)isLoopback
                   delegate:(id<HMVideoCallViewControllerDelegate>)delegate;

@end
