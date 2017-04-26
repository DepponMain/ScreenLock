//
//  NextViewController.m
//  ScreenLock
//
//  Created by 马海江 on 2017/4/26.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define SlAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

#import "NextViewController.h"
#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>

@interface NextViewController ()
{
    BOOL canRotate;//标志位：判断现在能不能旋转屏幕
    BOOL isFirstload;//刚刚进入此页面
}

@property (nonatomic, strong) CMMotionManager* motionManager;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
    canRotate = NO;//这个参数是整个问题解决的核心，注意它的变化
    isFirstload = YES;
    [self startMotionManager];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

//这个是系统横竖屏通知过来，自己需要操作的方法
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation{
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeLeft:
//            NSLog(@"屏幕向左横置");
            [_motionManager stopDeviceMotionUpdates];
            canRotate = YES;//只有当用户把手机旋转到横屏的时候来去触发判断是否支持横屏，如果不支持就提醒用户
            break;
        case UIDeviceOrientationLandscapeRight:
//            NSLog(@"屏幕向右橫置");
            [_motionManager stopDeviceMotionUpdates];
            canRotate = YES;
            break;
        default:
            break;
    }
}
//初始化
- (void)startMotionManager{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 0.1;//多长时间刷新一次
    if (_motionManager.deviceMotionAvailable) {
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                
                                            }];
    } else {
        [self setMotionManager:nil];
    }
}
//这里是重力感应的处理方法
- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    double z = deviceMotion.gravity.z;
//    NSLog(@"X = %f------------Y = %f------------Z = %f",x,y,z);
    if (fabs(x) - fabs(y) > 0.5){
        if (isFirstload) {
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(canRotate == NO){
                [_motionManager stopDeviceMotionUpdates];
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您打开屏幕锁定,请在控制中心关闭" preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
            }
        });
    }else if(fabs(y) - fabs(x) > 0.5){// 手机已经竖屏(横屏方向旋转可触发手机屏幕的旋转)
        isFirstload = NO;
    }else if (fabs(z) > 0.8){// 手机平放状态进入此页面
        isFirstload = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SlAppDelegate.allowRotation = 4;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    SlAppDelegate.allowRotation = 2;
    [_motionManager stopDeviceMotionUpdates];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)setupUI{
    
}

@end
