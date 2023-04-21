//
//  CHKeychain.h
//  KayChainTest1
//
//  Created by 2255 on 16/7/26.
//  Copyright © 2016年 2255. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface CHKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;


@end