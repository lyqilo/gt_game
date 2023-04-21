//
//  DGBridge.m
//  DGSDKDemo
//
//  Created by doublek on 2019/11/27.
//  Copyright © 2019 DG. All rights reserved.
//



#import "TaiJiDun.h"
//#include "ClinkAPI.h"//包含api头文件

#define MakeStringCopy( _x_ ) ( _x_ != NULL && [_x_ isKindOfClass:[NSString class]] ) ? strdup( [_x_ UTF8String] ) : NULL
@interface TaiJiDun ()
@end

@implementation TaiJiDun

#if defined (__cplusplus)
extern "C" {
#endif
    //
    int _InitSDKDun(char *key){
		[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
		//ClinkAPI api;//定义api对象
            //启动客户端安全接入组件(只需要调用一次，最好不要重复调用)，返回150表示成功，其它的为失败，返回0有可能是网络不通或密钥错误，返回170有可能是实例到期或不存在。如果重复调用start()有可能会返回150也可能返回1000，这取决于当时连接的状态，所以最好不要重复调用
        //int ret= api.start(key);
		return 0;
    }
#if defined (__cplusplus)
}
#endif

@end
