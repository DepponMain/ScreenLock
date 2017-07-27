# ScreenLock
苹果官方并没有提供可以直接监测屏幕锁定是否打开的接口，最近做的项目中有这个需求，所以就试着写了一个，这个监测的原理是通过重力感应来实现的。
## 关键代码
	
	//这里是重力感应的处理方法
	- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
	    double x = deviceMotion.gravity.x;
	    double y = deviceMotion.gravity.y;
	    double z = deviceMotion.gravity.z;
	    
	    //    NSLog(@"X = %f------------Y = %f------------Z = %f",x,y,z);
	    
	    double d_value = fabs(x) - fabs(y);
	    if (_D_valueArray.count < 6) {
        [self.D_valueArray addObject:[NSNumber numberWithDouble:d_value]];
        return;
	    }else if(_D_valueArray.count == 6){
		[self.D_valueArray removeObjectAtIndex:0];
		[self.D_valueArray addObject:[NSNumber numberWithDouble:d_value]];
	    }
	    if ([_D_valueArray[0] doubleValue] > 0.5 && [_D_valueArray[1] doubleValue] > 0.5 && [_D_valueArray[2] doubleValue] > 0.5 && [_D_valueArray[3] doubleValue] > 0.5 && [_D_valueArray[4] doubleValue] > 0.5 && [_D_valueArray[5] doubleValue] > 0.5) {
	        
	        //        NSLog(@"0 === %@ 1 === %@ 2 === %@ 3 === %@",_D_valueArray[0],_D_valueArray[1],_D_valueArray[2],_D_valueArray[3]);
	        
	        if (isFirstload) {
	            return;
	        }
	        if(canRotate == NO){
	            [_motionManager stopDeviceMotionUpdates];
	            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您打开屏幕锁定,请在控制中心关闭" preferredStyle:UIAlertControllerStyleAlert];
	            [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
	                
	            }]];
	            [self presentViewController:ac animated:YES completion:nil];
	        }
	    }
	    if (fabs(y) - fabs(x) > 0.5){// 手机已经竖屏(横屏方向旋转可触发手机屏幕的旋转)
	        isFirstload = NO;
	    }
	    if (fabs(z) > 0.8){// 手机平放状态进入此页面
	        isFirstload = NO;
	    }
	}
    	
## 感谢
实现思路来源于简书的一篇文章[iOS当用户横屏锁定开启时，怎样提醒用户][id].

[id]: http://www.jianshu.com/p/4acdf1d25319

---
##### ☆*可下载Demo查看完整代码，如有纰漏，欢迎指正* ☆
## 联系方式
* QQ：2779713120
* 邮箱：mahaijiang0117@126.com

<div class="footer">
	&copy; 2017/4/26 HJ.M
</div>
