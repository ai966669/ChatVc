//
//  recordAndPlay.m
//
//
//  Created by ai966669 on 15/9/12.
//
//

#import "RecordAndPlay.h"
#import "ChatVc-swift.h"
@implementation RecordAndPlay
@synthesize avPlay;
@synthesize recorder;
NSTimeInterval timeOfStart;
NSTimeInterval timeOfEnd;

//nzz需要做成单例

-(void)playAudio:(NSData*)dataOfRecord{
    if (NSUserDefaultsDidChangeNotification){
        if (recorder==nil){
            [self initAudio];
        }
    }

    if (avPlay.playing) {
        [avPlay stop];
        return;
    }
    //urlPlay保存着recorder的录音存放地址
//    if (avPlay==nil){
        avPlay = [[AVAudioPlayer alloc]initWithData:dataOfRecord error:nil];
//    }
    NSLog(@"播放成功%d",[avPlay play]);
}

-(void)recordAudio{
    if (recorder==nil){
        [self initAudio];
    }
    NSLog(@"JIRURecordAudio");
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    //[session setCategory:AVAudioSessionCategoryPlayAndRecord  error:&sessionError];方法默认播放器为听筒，另外一个方法如下，将设置听筒为播放方式
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&sessionError];
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        //阻断后台音乐播放
        [session setActive:YES error:nil];
    
    
    //创建录音文件，准备录音
    if ([recorder prepareToRecord]) {
        //开始
        NSLog(@"qidong %d",[recorder record]);
    }
    NSLog(@"刚启动时是不是正在录音………………%d",  recorder.recording);
    //在使用前需要进行租借
    
    timeOfStart=[[[NSDate alloc] init] timeIntervalSince1970];
}
-(NSArray *)stopAudio{
    //    double cTime = recorder.currentTime;
    //    if (cTime > 0.1) {//如果录制时间<2 不发送
    //        NSLog(@"发出去");
    //    }else {
    //        //删除记录的文件
    //        // [recorder stop];
    //        [recorder deleteRecording];
    //        //删除存储的
    //    }
    if (recorder==nil){
        [self initAudio];
    }
    NSLog(@"JIRNU");
    
    timeOfEnd=[[[NSDate alloc] init] timeIntervalSince1970];
    NSTimeInterval timeOfRec=timeOfEnd-timeOfStart;
    int timeOfRecInt=timeOfRec*10;
    double temp=timeOfRecInt;
    double dataOfRecDouble=temp/10;
    NSLog(@"finishSpeech :%f |%f  shijiancha %@",timeOfStart,timeOfEnd,[NSNumber numberWithDouble:dataOfRecDouble]);
    [recorder stop];
    //结束使用后需要将后台音乐阻断恢复，延续播放
    [[AVAudioSession sharedInstance] setActive:NO error: nil];
    
    NSData *dataVoice=[NSData dataWithContentsOfURL:url];
    
    return [[NSArray alloc] initWithObjects:dataVoice,[NSNumber numberWithDouble:dataOfRecDouble],nil];
}
- (void)initAudio
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    NSString *pathMain = NSHomeDirectory();
    
    url =[NSURL fileURLWithPath:[pathMain stringByAppendingString:@"/Documents/pinyin.aac"]];//[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.aac", strUrl]];
    //    urlPlay = url;
    
    NSError *error;
    //初始化
    //url为录音存放地址
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    
    NSLog(@"URL=%@",url);
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate=self;
    //    recorder.delegate = self;
}
@end
