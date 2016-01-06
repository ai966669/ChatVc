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

//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
+ (NSDictionary*)getObjectData:(id)obj;

//将getObjectData方法返回的NSDictionary转化成JSON
+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;

//直接通过NSLog输出getObjectData方法返回的NSDictionary
+ (void)print:(id)obj;

//通过颜色来生成一个纯色图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color :(CGSize)imgSize;

+(NSString*)getDeveicePlatform;

@end
