//
//  MJViewController.m
//  03-录音
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MJViewController ()
- (IBAction)startRecord;
- (IBAction)stopRecord;
- (IBAction)startPlay;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) double slientDuration;
@end

@implementation MJViewController
- (CADisplayLink *)link
{
    if (!_link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    }
    return _link;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)update
{
    // 1.更新录音器的测量值
    [self.recorder updateMeters];
    
    // 2.获得平均分贝
    float power = [self.recorder averagePowerForChannel:0];
    
    NSLog(@"%f",power);
    
//    // 3.如果小于-30, 开始静音
//    if (power < - 30) {
////        [self.recorder pause];
//        
//        self.slientDuration += self.link.duration;
//        
//        if (self.slientDuration >= 2) { // 沉默至少2秒钟
//            [self.recorder stop];
//            
////            // 停止定时器
////            [self.link invalidate];
////            self.link = nil;
//             NSLog(@"--------停止录音");
//        }
//    } else {
////        [self.recorder record];
//        self.slientDuration = 0;
//        NSLog(@"**********持续说话");
//    }
}

- (IBAction)startRecord
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.caf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 1.创建录音器
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    // 音频格式
    setting[AVFormatIDKey] = @(kAudioFormatAppleIMA4);
    // 音频采样率
    setting[AVSampleRateKey] = @(8000.0);
    // 音频通道数
    setting[AVNumberOfChannelsKey] = @(1);
    // 线性音频的位深度
    setting[AVLinearPCMBitDepthKey] = @(8);
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
   
    
    // 允许测量分贝
    recorder.meteringEnabled = YES;
    
    // 2.缓冲
    [recorder prepareToRecord];
    
    // 3.录音
    [recorder record];
    
    self.recorder = recorder;
    
    // 4.开启定时器
    self.slientDuration = 0;
   
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (IBAction)stopRecord {
    [self.recorder stop];
}

- (IBAction)startPlay {
    
}
@end
