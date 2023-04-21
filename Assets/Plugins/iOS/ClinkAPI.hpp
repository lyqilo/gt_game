//
//  clinkAPI.hpp
//  clinkAPI_IOS
//
//  Created by Macbook on 2017/11/4.
//  Copyright © 2017年 HuRuan. All rights reserved.
//

#ifndef ClinkAPI_hpp
#define ClinkAPI_hpp

#include <stdio.h>


class ClinkAPI
{
public:
    /**
     启动客户端安全接入组件(只需要调用一次，最好不要重复调用)
     key：sdk配置密钥
     返回150表示成功，其它的为失败。返回0有可能是网络不通或密钥错误，返回170有可能是实例到期或不存在。如果重复掉用start()有可能会返回150也可能返回1000，这取决于当时连接的状态，所以最好不要重复调用
     */
    int start(const char * key);
    
    /**
     停止客户端安全接入组件(一般不需要调用) 注意：停止后只有进程重启后才可以再重新调用start函数，否则就算重新调用了start应用也无法连接，如果未调用start就直接调用本函数将会出错
     返回0表示成功，其它的为失败
     */
    int stop();
};

#endif /* ClinkAPI_hpp */
