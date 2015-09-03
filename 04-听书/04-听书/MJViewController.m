//
//  MJViewController.m
//  04-听书
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"
#import "MJWord.h"
#import "MJExtension.h"
#import "MJAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@interface MJViewController ()
@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) AVAudioPlayer *wordPlayer;
@end

@implementation MJViewController

- (CADisplayLink *)link
{
    if (!_link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    }
    return _link;
}

- (NSArray *)words
{
    if (!_words) {
        self.words = [MJWord objectArrayWithFilename:@"一东.plist"];
    }
    return _words;
}

- (void)update
{
    // 当前播放的位置
    double currentTime = self.wordPlayer.currentTime;
    
    int count = self.words.count;
    for (int i = 0; i<count; i++) {
        // 1.当前词句
        MJWord *word = self.words[i];
        
        // 2.获得下一条词句
        int nextI = i + 1;
        MJWord *nextWord = nil;
        if (nextI < count) {
            nextWord = self.words[nextI];
        }
        
        if (currentTime < nextWord.time && currentTime >= word.time) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
            break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.wordPlayer = [MJAudioTool playMusic:@"一东.mp3"];
    
    [MJAudioTool playMusic:@"Background.caf"];
    
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    static NSString *ID = @"word";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 2.设置cell的数据
    MJWord *word = self.words[indexPath.row];
    cell.textLabel.text = word.text;
    
    return cell;
}


@end
