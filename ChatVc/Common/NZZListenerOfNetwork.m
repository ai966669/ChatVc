//
//  NZZListenerOfNetwork.m
//  SuperGina
//
//  Created by ai966669 on 15/6/23.
//  Copyright (c) 2015年 Anve. All rights reserved.
//

#import "NZZListenerOfNetwork.h"
#import "AFNetworking.h"
#import "ChatVc-Swift.h"
@implementation NZZListenerOfNetwork
static UILabel *labelOfStatus;
static bool justOpen=1;
+ (void)initListener{

    NSString *text=@"当前为蜂窝数据";
    labelOfStatus=[[UILabel alloc] init];
    //CGRectZero表示(0,0,0,0),即留待后面再设置
    labelOfStatus = [[UILabel alloc] initWithFrame:CGRectZero];
    labelOfStatus.backgroundColor=[UIColor lightGrayColor];
    labelOfStatus.alpha=0;
    //label默认只显示一行,把numberofline设为0,即表示不限制行数,根据实际显示
    [labelOfStatus setNumberOfLines:0];
    labelOfStatus.text = text;
    labelOfStatus.textAlignment=NSTextAlignmentCenter;
    //设置字体,包括字体及其大小
    UIFont *font = [UIFont fontWithName:@"Arial" size:15.0f];
    labelOfStatus.font = font;
    labelOfStatus.textColor = [UIColor whiteColor];
    
    
    //设置layer
    CALayer *layer=[labelOfStatus layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:10.0/2];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    
    UIViewController *vc = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    //label可设置的最大高度和宽度
    CGRect rect = CGRectMake(0.5*(vc.view.frame.size.width-110), 0.1*vc.view.frame.size.height,123, 38);
    labelOfStatus.frame = rect;
    
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:{
                [self showToast:@"当前无网络可用"];
                break;
                
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                if(!justOpen){
                [self showToast:@"当前为WiFi网络"];
                }
                break;
                
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                if(!justOpen){
                [self showToast:@"当前为蜂窝数据"];
                }
                break;
                
            }
                
            default:
                break;
        }
        justOpen=0;
        
    }];
}
+ (void)startListenStatusOfNetwork{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initListener];
    });
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopListenStatusOfNetwork{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (void)showToast:(NSString *)text{

    //把label加入到view里,这样才能显示
    [[[UIApplication sharedApplication] keyWindow] addSubview:labelOfStatus];
    labelOfStatus.text=text;
    UIViewController *controllerNow=[self getCurrentRootViewController];
    [controllerNow.view addSubview:labelOfStatus];
    
    
    [UIView beginAnimations:@"ToggleViews1" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    labelOfStatus.alpha=0;
    labelOfStatus.alpha=0.5;
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(hideLabelOfStateOfNetwork) userInfo:nil repeats:NO];
}
+ (void)hideLabelOfStateOfNetwork{
    [UIView beginAnimations:@"ToggleViews" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    labelOfStatus.alpha=0.5;
    labelOfStatus.alpha=0;
    [UIView commitAnimations];
}
+(UIViewController *)getCurrentRootViewController {
    
    
    UIViewController *result;
    
    
    // Try to find the root view controller programmically
    
    
    // Find the top window (that is not an alert view or other window)
    
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    
    if (topWindow.windowLevel != UIWindowLevelNormal)
        
        
    {
        
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        
        for(topWindow in windows)
            
            
        {
            
            
            if (topWindow.windowLevel == UIWindowLevelNormal)
                
                
                break;
            
            
        }
        
        
    }
    
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    
    id nextResponder = [rootView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
        
        result = nextResponder;
    
    
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        
        
        result = topWindow.rootViewController;
    
    
    else
        
        
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    
    
    return result;    
    
    
}
@end
