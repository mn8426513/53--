//
//  MJMusicCell.m
//  02-音乐播放器
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJMusicCell.h"
#import "MJMusic.h"
#import "Colours.h"
#import "UIImage+MJ.h"

@interface MJMusicCell()
@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation MJMusicCell

- (CADisplayLink *)link
{
    if (!_link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    }
    return _link;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"music";
    MJMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MJMusicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setMusic:(MJMusic *)music
{
    _music = music;
    
    self.textLabel.text = music.name;
    self.detailTextLabel.text = music.singer;
    self.imageView.image = [UIImage circleImageWithName:music.singerIcon borderWidth:2 borderColor:[UIColor skyBlueColor]];
    
    if (music.isPlaying) {
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    } else { // 停止动画
        [self.link invalidate];
        self.link = nil;
        self.imageView.transform = CGAffineTransformIdentity;
    }
}

/**
 *  8秒转一圈, 45°/s
 */
- (void)update
{
    // 1/60秒 * 45
    // 规定时间内转动的角度 == 时间 * 速度
    CGFloat angle = self.link.duration * M_PI_4;
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, angle);
}

@end
