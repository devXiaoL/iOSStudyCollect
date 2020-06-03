//
//  VideoPlayerVC.m
//  StudyDemo
//
//  Created by Lang on 8/10/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import "VideoPlayerVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>


@interface VideoPlayerVC ()

@property (nonatomic, strong)AVPlayerViewController *playerVC;
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)AVPlayerItem *item;
@property (nonatomic, strong)NSString *urlString;


@end


@implementation VideoPlayerVC

- (void)viewDidLoad{
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.urlString = @"Alizee_La_Isla_Bonita.mp4";
    
//    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    layer.frame = CGRectMake(0, 50, self.view.bounds.size.width, 375);
//    layer.videoGravity =AVLayerVideoGravityResizeAspect;
//    [self.view.layer addSublayer:layer];
    
    //手机设置静音，设置播放仍有声音
    AVAudioSession *aSession = [AVAudioSession sharedInstance];
    [aSession setCategory:AVAudioSessionCategoryPlayback
              withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                    error:nil];
    
    [self addChildViewController:self.playerVC];
    [self.view addSubview:self.playerVC.view];
//    [self showViewController:self.playerVC sender:nil];
    
    [self avSession];
}


- (void)avSession {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (videoInput) {
        // If the input can be added, add it to the session.
        if ([captureSession canAddInput:videoInput]) {
            [captureSession addInput:videoInput];
        }
    } else {
        // Configuration failed. Handle error.
    }
}

- (void)dealloc{
    self.playerVC = nil;
    self.player = nil;
    self.item = nil;
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


#pragma mark - getter && setter

- (AVPlayerViewController *)playerVC{
    if (!_playerVC) {
        _playerVC = [[AVPlayerViewController alloc]init];
        _playerVC.view.frame = CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 375);
        _playerVC.view.translatesAutoresizingMaskIntoConstraints = YES;
        //重力
        _playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
//        画中画   ipad 可用
        _playerVC.allowsPictureInPicturePlayback = YES;
        _playerVC.showsPlaybackControls = YES;
        _playerVC.player = self.player;
    }
    return _playerVC;
}

- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.item];
    }
    return _player;
}

- (AVPlayerItem *)item{
    if (!_item) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:self.urlString withExtension:nil];
        NSURL *txUrl = [NSURL URLWithString:@"http://123.125.39.136/124/21/102/letv-uts/14/ver_00_22-301795796-avc-1797708-aac-96000-222033-52923802-5e29121017b001c4ee546f27af90def0-1420557863107_mp4/ver_00_22_5_7_3_4369684_5735880_0.ts?mltag=100&platid=1&splatid=101&playid=0&geo=CN-1-17-2&tag=-&ch=&p1=1&p2=10&p3=-&tss=ios&b=1906&bf=84&nlh=4096&path=&sign=&proxy=2091125576,1699055496,2007471087&uuid=82D821689804899E95CAEC9B6803C3B37EBA2867_1&ntm=1496503800&keyitem=GOw_33YJAAbXYE-cnQwpfLlv_b2zAkYctFVqe5bsXQpaGNn3T1-vhw..&its=0&nkey2=fcae365eac0b52d78163159e572ad644&uid=1928670891.rp&qos=4&enckit=&m3v=1&token=&vid=1810001&liveid=&station=&app_name=&app_ver=&fcheck=0&pantm=&panuid=&pantoken=&cips=114.245.46.171&vod_live_path=&ledituid=&leditcid=&leditcip=&leditfl=&leditafl=&ajax=&lsbv="];
        _item = [[AVPlayerItem alloc]initWithURL:txUrl];
    }
    return _item;
}

@end

