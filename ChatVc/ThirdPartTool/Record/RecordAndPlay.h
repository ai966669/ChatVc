//
//  recordAndPlay.h
//  
//
//  Created by ai966669 on 15/9/12.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@protocol RecordAndPlayManagerDelegate <AVAudioRecorderDelegate>

- (void)finishRecord:(BOOL)code :(NSString *)pathOfAudio;


@end
@interface RecordAndPlay : NSObject<AVAudioRecorderDelegate>{
    AVAudioRecorder *recorder;
    NSURL *url ;
    AVAudioPlayer *avPlay;
}
@property (retain, nonatomic) AVAudioPlayer *avPlay;
@property (retain, nonatomic) AVAudioRecorder *recorder;
-(void)playAudio:(NSData*)dataOfRecord;
-(void)recordAudio;
-(NSArray*)stopAudio;
- (void)initAudio;
@end
