//
//  MJViewController.m
//  01-音频播放
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"
#import "MJAudioTool.h"

@interface MJViewController ()
//@property (nonatomic, assign) SystemSoundID soundID;
@end

@implementation MJViewController
//
//- (SystemSoundID)soundID
//{
//    if (!_soundID) {
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"m_03.wav" withExtension:nil];
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_soundID);
//    }
//    return _soundID;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // 1.加载音效文件(短音频)
    // 1个音效文件  对应 1个 SoundID
//    SystemSoundID soundID;
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"m_03.wav" withExtension:nil];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    
    // 拿到音效ID播放
//    AudioServicesPlaySystemSound(self.soundID);
//    NSString *filename = [NSString stringWithFormat:@"m_%02d.wav", arc4random_uniform(14) + 3];
    
//    [MJAudioTool playSound:filename];
    
    [MJAudioTool playSound:@"buyao.wav"];
    [MJAudioTool playSound:@"m_03.wav"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
//    AudioServicesDisposeSystemSoundID(self.soundID);
//    self.soundID = 0;
    
    [MJAudioTool disposeSound:@"m_03.wav"];
    [MJAudioTool disposeSound:@"buyao.wav"];
}

@end
