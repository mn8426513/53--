//
//  MJMusicsViewController.m
//  02-音乐播放器
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJMusicsViewController.h"
#import "MJMusic.h"
#import "MJMusicCell.h"
#import "MJExtension.h"
#import "MJAudioTool.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MJMusicsViewController () <AVAudioPlayerDelegate>
- (IBAction)jump:(id)sender;
@property (strong, nonatomic) NSArray *musics;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) AVAudioPlayer *currentPlayingAudioPlayer;
@end

@implementation MJMusicsViewController

- (IBAction)jump:(id)sender {
    self.currentPlayingAudioPlayer.currentTime = self.currentPlayingAudioPlayer.duration - 3;
}

- (NSArray *)musics
{
    if (!_musics) {
        self.musics = [MJMusic objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
}

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

/**
 *  实时更新(1秒中调用60次)
 */
- (void)update
{
//    NSLog(@"%f %f", self.currentPlayingAudioPlayer.duration, self.currentPlayingAudioPlayer.currentTime);

#warning 调整歌词
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    MJMusicCell *cell = [MJMusicCell cellWithTableView:tableView];
    
    // 2.设置cell的数据
    cell.music = self.musics[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 停止音乐
    MJMusic *music = self.musics[indexPath.row];
    [MJAudioTool stopMusic:music.filename];
    
    // 再次传递模型
    MJMusicCell *cell = (MJMusicCell *)[tableView cellForRowAtIndexPath:indexPath];
    music.playing = NO;
    cell.music = music;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 播放音乐
    MJMusic *music = self.musics[indexPath.row];
    AVAudioPlayer *audioPlayer = [MJAudioTool playMusic:music.filename];
    audioPlayer.delegate = self;
    self.currentPlayingAudioPlayer = audioPlayer;
    
    // 在锁屏界面显示歌曲信息
    [self showInfoInLockedScreen:music];
    
    // 开启定时器监听播放进度
    [self.link invalidate];
    self.link = nil;
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    // 再次传递模型
    MJMusicCell *cell = (MJMusicCell *)[tableView cellForRowAtIndexPath:indexPath];
    music.playing = YES;
    cell.music = music;
}

/**
 *  在锁屏界面显示歌曲信息
 */
- (void)showInfoInLockedScreen:(MJMusic *)music
{
    //    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 标题(音乐名称)
    info[MPMediaItemPropertyTitle] = music.name;
    
    // 作者
    info[MPMediaItemPropertyArtist] = music.singer;
    
    // 专辑
    info[MPMediaItemPropertyAlbumTitle] = music.singer;
    
    // 图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:music.icon]];
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
    //    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 计算下一行
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    int nextRow = selectedPath.row + 1;
    if (nextRow == self.musics.count) {
        nextRow = 0;
    }
    
#warning 停止上一首歌的转圈
    // 再次传递模型
    MJMusicCell *cell = (MJMusicCell *)[self.tableView cellForRowAtIndexPath:selectedPath];
    MJMusic *music = self.musics[selectedPath.row];
    music.playing = NO;
    cell.music = music;
    
    // 播放下一首歌
    NSIndexPath *currentPath = [NSIndexPath indexPathForRow:nextRow inSection:selectedPath.section];
    [self.tableView selectRowAtIndexPath:currentPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//    [self tableView:self.tableView didSelectRowAtIndexPath:currentPath];
}

/**
 *  音乐播放器被打断(打\接电话)
 */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"audioPlayerBeginInterruption---被打断");
}

/**
 *  音乐播放器停止打断(打\接电话)
 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    NSLog(@"audioPlayerEndInterruption---停止打断");
    [player play];
}
@end