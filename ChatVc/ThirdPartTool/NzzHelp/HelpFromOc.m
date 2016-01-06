 //
//  helpFromOc.m
//  SuperGina
//
//  Created by ai966669 on 15/7/30.
//  Copyright (c) 2015年 Anve. All rights reserved.
//

#import "HelpFromOc.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>
#import "sys/sysctl.h"
//ALAuthorizationStatus author = [ALAssetsLibraryauthorizationStatus];
//if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied)        {           //无权限
//}
//typedef enum {
//    kCLAuthorizationStatusNotDetermined = 0,  // 用户尚未做出选择这个应用程序的问候
//    kCLAuthorizationStatusRestricted,        // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
//    kCLAuthorizationStatusDenied,            // 用户已经明确否认了这一照片数据的应用程序访问
//    kCLAuthorizationStatusAuthorized         // 用户已经授权应用访问照片数据} CLAuthorizationStatus;
//}
@implementation HelpFromOc
static NSString *pathOfDoc;
+(NSString*)stringFromData:(NSData *)deviceToken{
    NSString *token = [[deviceToken description]
                       stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *deviceTokenInString = [token stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    return  deviceTokenInString;
}
+(BOOL)isCameraAvalible{
    //判断相机是否能够使用
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
        return true;
    } else if(status == AVAuthorizationStatusDenied){
        // denied
        return  false;
    } else if(status == AVAuthorizationStatusRestricted){
        // restricted
        return  false;
    } else if(status == AVAuthorizationStatusNotDetermined){
        // not determined
//        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//            if(granted){
//                [self presentViewController:self.imagePickerController animated:YES completion:nil];
//            } else {
//                return;
//            }
//        }];
        return true;
    }else{
        return false;
    }
}
+(BOOL)isPhotoLibraryAvailble{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
        return true;
    } else if(status == AVAuthorizationStatusDenied){
        // denied
        return  false;
    } else if(status == AVAuthorizationStatusRestricted){
        // restricted
        return  false;
    } else if(status == AVAuthorizationStatusNotDetermined){

        return true;
    }else{
        return false;
    }
}

+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)objectToJsonString:(NSDictionary *)dictionary

{
    
    if ([NSJSONSerialization isValidJSONObject:dictionary])
        
    {
        
        NSError *error;
        
        //创超一个json从Data,NSJSONWritingPrettyPrinted指定的JSON数据产的空白，使输出更具可读性
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                            
                                                        options:NSJSONWritingPrettyPrinted
                            
                                                          error:&error];
        
        NSString *jsonString = [[NSString alloc]initWithData:jsonData
                                
                                                    encoding:NSUTF8StringEncoding];
        
        return jsonString;
        
    }
    
    
    
    return nil;
    
}
//
+(NSString *)getMsgPath:(NSString *)nameOfFile :(BOOL)isVoice{
    if(pathOfDoc==nil){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        pathOfDoc = [paths objectAtIndex:0];
    }
    NSString *dir;
    if(isVoice){
        dir = [NSString stringWithFormat:@"%@/msg/voice",pathOfDoc];
    }else {
        dir = [NSString stringWithFormat:@"%@/msg/image",pathOfDoc];
    }
            BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        NSError *temp=[[NSError alloc] init];
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&temp];
    }
    NSString *fullPath;
    if(isVoice){
        fullPath=[pathOfDoc stringByAppendingString:[NSString stringWithFormat:@"/msg/voice/%@",nameOfFile]];
    }else{
        fullPath=[pathOfDoc stringByAppendingString:[NSString stringWithFormat:@"/msg/image/%@",nameOfFile]];
    }
    return fullPath;
}
//+ (NSDictionary*)analysisNotificationInGetui:(NSString*)payloadId{
//    // [4]: 收到个推消息
//    
//    NSData* payload = [GeTuiSdk retrivePayloadById:payloadId];
//    
//    NSString *payloadMsg = nil;
//    if (payload) {
//        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
//                                              length:payload.length
//                                            encoding:NSUTF8StringEncoding];
//    }
//    NSData *jsonData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
//    return dic;
//}
//根据string（2011-11-11 11:11:11）返回两个时间之间相差的秒数
+ (int)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=[timeArray1 objectAtIndex:0];
    
    
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=[timeArray2 objectAtIndex:0];
    
    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late2-late1;
    
//    NSString *timeString=@"";
//    NSString *house=@"";
//    NSString *min=@"";
//    NSString *sen=@"";
//    
//    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
//    //        min = [min substringToIndex:min.length-7];
//    //    秒
//    sen=[NSString stringWithFormat:@"%@", sen];
//    
//    
//    
//    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
//    //        min = [min substringToIndex:min.length-7];
//    //    分
//    min=[NSString stringWithFormat:@"%@", min];
//    
//    
//    //    小时
//    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
//    //        house = [house substringToIndex:house.length-7];
//    house=[NSString stringWithFormat:@"%@", house];
//    
//    
//    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    
    return (int)cha;
}
+ (void)redirectNSlogToDocumentFolder
{
    
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"log"];
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSAssert(bo,@"创建目录失败");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [[paths objectAtIndex:0] stringByAppendingString:@"/log/"];
    NSDate *now=[[NSDate alloc] init];
    NSDateFormatter *formtter1=[[NSDateFormatter alloc] init];
    [formtter1 setDateFormat:@"yyyy-MM-ddHH:mm:ss"];  //HH时24小时进制的   hh是12小时制度的
    NSString *nsdatenow=[formtter1 stringFromDate:now];
    NSString *fileName = [NSString stringWithFormat:@"%@.log",nsdatenow];// 注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}









+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];

        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (void)print:(id)obj
{
    NSLog(@"%@", [self getObjectData:obj]);
}


+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error
{
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}
//通过颜色来生成一个纯色图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color :(CGSize)imgSize{

CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
UIGraphicsBeginImageContext(rect.size);
CGContextRef context = UIGraphicsGetCurrentContext();
CGContextSetFillColorWithColor(context, [color CGColor]);
CGContextFillRect(context, rect);
UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext(); return img;
}
+(NSString*)getDeveicePlatform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    return platform;
    
//    
//    if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]||[platform isEqualToString:@"iPhone4,1"]){
//        a=112.0/640;
//        b=648.0/960;
//        c=430.0/640;
//        d=119.0/960;
//        nameOfImageOfGuiding=[[NSArray alloc] initWithObjects:@"4-1.jpg",@"4-2.jpg",@"4-3.jpg",@"4-4.jpg",@"4-0.png", nil];
//    }else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]||[platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]||[platform isEqualToString:@"iPhone6,1"]||[platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone7,2"]){
//        a=106.0/640;
//        b=775.0/1136;
//        c=430.0/640;
//        d=119.0/1136;
//        nameOfImageOfGuiding=[[NSArray alloc] initWithObjects:@"5-1.jpg",@"5-2.jpg",@"5-3.jpg",@"5-4.jpg",@"5-0.png", nil];
//    }else if([platform isEqualToString:@"iPhone7,1"]){
//        //6p
//        a=208.0/1242;
//        b=1546.0/2208;
//        c=827.0/1242;
//        d=197.0/2208;
//        nameOfImageOfGuiding=[[NSArray alloc] initWithObjects:@"6P-1.jpg",@"6P-2.jpg",@"6P-3.jpg",@"6P-4.jpg",@"6P-0.png", nil];
//    }
//    else{
//        a=177.0/768;
//        b=718.0/1024;
//        c=414.0/768;
//        d=99.0/1024;
//#warning 引导页图片png改成jpg
//        nameOfImageOfGuiding=[[NSArray alloc] initWithObjects:@"ipad-1.png",@"ipad-2.png",@"ipad-3.png",@"ipad-4.png",@"ipad-0.png", nil];
//    }
}
@end
