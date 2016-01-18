//
//  NZZListenerOfNetwork.h
//  SuperGina
//
//  Created by ai966669 on 15/6/23.
//  Copyright (c) 2015年 Anve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZZListenerOfNetwork : NSObject

/**
 *  开始监听网络
 */
+ (void)startListenStatusOfNetwork;

/**
 *  停止监听网络
 */
+ (void)stopListenStatusOfNetwork;

@end
