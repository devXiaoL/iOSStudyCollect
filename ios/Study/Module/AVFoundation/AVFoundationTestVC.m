//
//  AVFoundationTestVC.m
//  StudyDemo
//
//  Created by lanbao on 2018/1/30.
//  Copyright © 2018年 Lang. All rights reserved.
//

#import "AVFoundationTestVC.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPVolumeView.h>
#import "AVAudioSessionSetup.h"


#define volumeChangeKey @"AVSystemController_SystemVolumeDidChangeNotification"
#define volumeValueKey @"AVSystemController_AudioVolumeNotificationParameter"

@interface AVFoundationTestVC ()<AVSpeechSynthesizerDelegate>

@property (nonatomic, strong)UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) AVSpeechSynthesizer *speech;

/** 滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;
@property (weak, nonatomic) IBOutlet UIStepper *volumeStepper;
@property (nonatomic, strong) MPVolumeView *volumeView;

@end

@implementation AVFoundationTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"AVFoundation";
    
    UILabel *volumeLabel = [[UILabel alloc]init];
    [self.view addSubview:volumeLabel];
    [volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.centerX.equalTo(self.view);
    }];
    self.volumeLabel = volumeLabel;
    // 设置步进按钮
    [self setupStepper];
    // 读取系统音量
    [self readSystemVolume];
    
    [self configureVolume];
    
    NSError *error;
    
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    //监听系统音量变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeChanged:) name:volumeChangeKey object:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
 
    [AVAudioSessionSetup SetupAudioSession];
}

- (void)viewWillDisappear:(BOOL)animated {
    [AVAudioSessionSetup EndAudioSession];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:volumeChangeKey object:nil];
}


- (void)setupStepper {
    // 系统音量一共有 16 格
    CGFloat stepValue = 1/16.0;
    self.volumeStepper.minimumValue = 0;
    self.volumeStepper.maximumValue = 1;
    self.volumeStepper.stepValue = stepValue;
}


- (IBAction)startReadButtonAction:(UIButton *)sender {
    
    if ([self.speech isPaused]) {
        [self.speech continueSpeaking];
    }else{
        //播报的文本
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.textView.text];
        utterance.pitchMultiplier=0.8;
        utterance.postUtteranceDelay = 1;
        utterance.rate = .5;
        //中式发音
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        utterance.voice = voice;
        //朗读
        [self.speech speakUtterance:utterance];
    }
}

- (IBAction)pauseButtonAction:(UIButton *)sender {
    if ([self.speech isSpeaking]) {
        // AVSpeechBoundaryWord 说完一个单词之后暂停
        // AVSpeechBoundaryImmediate 立刻暂停
        [self.speech pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
}

- (AVSpeechSynthesizer *)speech{
    if (!_speech) {
        _speech = [[AVSpeechSynthesizer alloc]init];
        _speech.delegate = self;
    }
    return _speech;
}

#pragma mark - 音量
/**
 读取系统音量
 */
- (void)readSystemVolume{
    
    AVAudioSession *audio = [AVAudioSession sharedInstance];
    CGFloat volume = audio.outputVolume;
    self.volumeLabel.text = [NSString stringWithFormat:@"系统音量：%.0f",volume/0.0625];
    self.volumeStepper.value = volume;
}

- (void)configureVolume {
    _volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [_volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
}

#pragma mark - 音量 action

- (IBAction)hideVolumeViewAction:(UISwitch *)sender {
    if (sender.on) {
        _volumeView.frame = CGRectMake(-100, -100, 100, 100);
        [self.view addSubview:_volumeView];
    }else {
        [self.volumeView removeFromSuperview];
    }
}

- (IBAction)changedVolumeStepper:(UIStepper *)sender {
    [self.volumeViewSlider setValue:sender.value animated:YES];
    [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - notification

- (void)systemVolumeChanged:(NSNotification *)notification{
    if ([notification.name isEqualToString:volumeChangeKey]) {
        //2.获取到当前音量
        float volume = [[[notification userInfo] valueForKey:volumeValueKey ] floatValue];
        self.volumeLabel.text = [NSString stringWithFormat:@"系统音量：%.0f",volume/0.0625];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    
}


/*
 文本转语音技术, 也叫TTS, 是Text To Speech的缩写. iOS如果想做有声书等功能的时候, 会用到这门技术.
 一，使用iOS自带TTS需要注意的几点：
 
 1.iOS7之后才有该功能
 
 2.需要 AVFoundation 库
 3.AVSpeechSynthesizer: 语音合成器, 可以假想成一个可以说话的人, 是最主要的接口
 4.AVSpeechSynthesisVoice: 可以假想成人的声音
 5.AVSpeechUtterance: 可以假想成要说的一段话
 二，代码示例, 播放语音
 //语音播报
 AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"床前明月光，疑是地上霜。"];
 utterance.pitchMultiplier=0.8;
 //中式发音
 AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
 //英式发音
 // AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
 utterance.voice = voice;
 NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
 AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc]init];
 [synth speakUtterance:utterance];
 三，AVSpeechSynthesizer介绍
 这个类就像一个会说话的人, 可以”说话”, 可以”暂停”说话, 可以”继续”说话, 可以判断他当前是否正在说话.有以下的方法或者属性:
 •说话: speakUtterance
 
 •控制: continueSpeaking(继续说), pauseSpeakingAtBoundary(暂停说话), paused(暂停状态的属性), speaking(说话的状态), stopSpeakingAtBoundary(停止说话)
 •委托: delegate
 四，AVSpeechBoundary介绍
 这是一个枚举. 在暂停, 或者停止说话的时候, 停下的方式用这个枚举标示. 包括两种:
 
 •AVSpeechBoundaryImmediate: 立即停
 •AVSpeechBoundaryWord : 说完一个整词再停
 五，AVSpeechSynthesizerDelegate介绍
 合成器的委托, 对于一些事件, 提供了响应的接口.
 
 •didCancelSpeechUtterance: 已经取消说话
 
 •didContinueSpeechUtterance: 已经继续说话
 •didFinishSpeechUtterance: 已经说完
 •didPauseSpeechUtterance: 已经暂停
 •didStartSpeechUtterance:已经开始
 •willSpeakRangeOfSpeechString:将要说某段话
 六，AVSpeechSynthesisVoice介绍
 
 AVSpeechSynthesisVoice定义了一系列的声音, 主要是不同的语言和地区.
 •voiceWithLanguage: 根据制定的语言, 获得一个声音.
 
 •speechVoices: 获得当前设备支持的声音
 
 •currentLanguageCode: 获得当前声音的语言字符串, 比如”ZH-cn”
 
 •language: 获得当前的语言
 七，AVSpeechUtterance介绍
 
 这个类就是一段要说的话. 主要的属性和方法有:
 •pitchMultiplier: 音高
 •postUtteranceDelay: 读完一段后的停顿时间
 •preUtteranceDelay: 读一段话之前的停顿
 •rate: 读地速度, 系统提供了三个速度: AVSpeechUtteranceMinimumSpeechRate, AVSpeechUtteranceMaximumSpeechRate,
 
 AVSpeechUtteranceDefaultSpeechRate
 •speechString: 要读的字符串
 •voice: 使用的声音, 是AVSpeechSynthesisVoice对象
 •volume: 音量
 */

@end
