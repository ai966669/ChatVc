//
//  helpFromOc.h
//  SuperGina
//
//  Created by ai966669 on 15/7/30.
//  Copyright (c) 2015年 Anve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HelpFromOc : NSObject
+(NSString*)stringFromData:(NSData *)deviceToken;
+(BOOL)isPhotoLibraryAvailble;
+(BOOL)isCameraAvalible;
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;
+ (NSString *)objectToJsonString:(NSDictionary *)dictionary;
+(NSString *)getMsgPath:(NSString *)nameOfFile :(BOOL)isVoice;
+ (int)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;
+ (NSDictionary*)analysisNotificationInGetui:(NSString*)payloadId;
+ (void)redirectNSlogToDocumentFolder;
+ (UIViewController *)getCurrentVC;
+ (UIViewController *)getPresentedViewController;
@end
