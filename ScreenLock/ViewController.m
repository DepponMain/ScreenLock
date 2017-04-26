//
//  ViewController.m
//  ScreenLock
//
//  Created by 马海江 on 2017/4/22.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define SlAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

#import "ViewController.h"
#import "AppDelegate.h"
#import "NextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *next = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 100, ScreenHeight / 2 - 25, 200, 50)];
    [next setBackgroundColor:[UIColor darkGrayColor]];
    [next setTitle:@"进入可旋转页面->" forState:UIControlStateNormal];
    [next addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    next.layer.cornerRadius = 5;
    next.layer.masksToBounds = YES;
    [self.view addSubview:next];
}

- (void)next{
    NextViewController *next = [[NextViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SlAppDelegate.allowRotation = 2;
}

@end
