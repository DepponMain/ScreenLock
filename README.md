# ScreenLock
苹果官方并没有提供可以直接监测屏幕锁定是否打开的接口，最近做的项目中有这个功能，所以就试着写了一个，这个监测的原理是通过重力感应来实现的。

关键判断处的代码：
	
	//这里是重力感应的处理方法
	- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
	    double x = deviceMotion.gravity.x;
	    double y = deviceMotion.gravity.y;
	    double z = deviceMotion.gravity.z;
	    //    NSLog(@"X = %f------------Y = %f------------Z = %f",x,y,z);
	    if (fabs(x) - fabs(y) > 0.5){// 手机可触发屏幕旋转
	        if (isFirstload) {
	            return;
	        }
	        //延迟0.4秒是为了等待屏幕旋转完成
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
    
* 可下载Demo查看完整代码，如有纰漏，欢迎指正QQ：2779713120


实现思路来源于简书的一篇文章[iOS当用户横屏锁定开启时，怎样提醒用户][id].

[id]: http://www.jianshu.com/p/4acdf1d25319


<div class="footer">
	&copy; 2017/4/26 HJ.M
</div>
