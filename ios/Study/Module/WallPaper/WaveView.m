//
//  WaveView.m
//  KYJ_RentCircle
//
//  Created by lilang on 16/7/7.
//  Copyright © 2016年 KuaiYouJia. All rights reserved.
//

#import "WaveView.h"

@interface WaveView ()

@property (nonatomic,strong)NSTimer * myTimer;

@property (nonatomic,assign) CGRect MYframe;

@property (nonatomic,assign) CGFloat fa;

@property (nonatomic,assign) CGFloat bigNumber;

@property (nonatomic,strong) CADisplayLink *waveDisplayLink;

@end

@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _MYframe = frame;
        self.backgroundColor = [UIColor lightGrayColor];
        UILabel * presentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        presentLabel.textAlignment = 1;
        [self addSubview:presentLabel];
        self.presentlabel = presentLabel;
        self.presentlabel.font = [UIFont systemFontOfSize:15];
        
        
    }
    return self;
}

- (void)createTimer{
    //    if (!_waveDisplayLink) {
    //        _waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(action)];
    //        [_waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    //    }
    
    if (!self.myTimer) {
        
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(action) userInfo:nil repeats:YES];
        NSRunLoop *main=[NSRunLoop currentRunLoop];
        [main addTimer:self.myTimer forMode:NSRunLoopCommonModes];
    }
//    [self.myTimer setFireDate:[NSDate distantPast]];
}

- (void)openTimer{
    [self.myTimer setFireDate:[NSDate distantPast]];
}

- (void)closeTimer{
    [self.myTimer setFireDate:[NSDate distantFuture]];
}

- (void)action{
    //让波浪移动效果
    _fa = _fa+10;
    if (_fa >= _MYframe.size.width * 2.0) {
        _fa = 0;
    }
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    UIColor * blue = [UIColor colorWithRed:228/255.0 green:251/255.0 blue:245/255.0 alpha:0.8];
    CGContextSetFillColorWithColor(context, [blue CGColor]);
    
    float y= (1 - self.present) * rect.size.height;
    float y1= (1 - self.present) * rect.size.height;
    
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=0;x<=rect.size.width * 3.0;x++){
        //正弦函数
        y=  sin( x/rect.size.width * M_PI*1.5 - _fa/rect.size.width * M_PI) *_bigNumber + (1 - self.present) * rect.size.height ;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, rect.size.width , rect.size.height );
    CGPathAddLineToPoint(path, nil, 0, rect.size.height );
    // CGPathAddLineToPoint(path, nil, 0, 200);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    //  float y1=200;
    //画水
    CGContextSetLineWidth(context, 1);
    UIColor * blue1 = [UIColor colorWithRed:185/255.0 green:245/255.0 blue:237/255.0 alpha:0.7];
    
    CGContextSetFillColorWithColor(context, [blue1 CGColor]);
    
    
    //  float y1= 200;
//    CGPathMoveToPoint(path1, NULL, 0, y1);
//    for(float x=0;x<=rect.size.width * 3.0;x++){
//        
//        y1= sin(x/rect.size.width * M_PI*3 - _fa/rect.size.width * M_PI + M_PI ) *_bigNumber + (1 - self.present) * rect.size.height ;
//        CGPathAddLineToPoint(path1, nil, x, y1);
//    }
//    
//    CGPathAddLineToPoint(path1, nil, rect.size.height, rect.size.width );
//    CGPathAddLineToPoint(path1, nil, 0, rect.size.height );
//    //CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
//    
//    CGContextAddPath(context, path1);
//    CGContextFillPath(context);
//    CGContextDrawPath(context, kCGPathStroke);
//    CGPathRelease(path1);
    
    
    //添加文字
    NSString *str = [NSString stringWithFormat:@"%.2f%%",self.present * 100.0];
    self.presentlabel.text = str;
    
}

- (void)setPresent:(CGFloat)present{
    _present = present;
    //启动定时器
    [self createTimer];
    //修改波浪的幅度
    if (present <= 0.5) {
        _bigNumber = _MYframe.size.height * 0.15 * present * 2;
    }else{
        _bigNumber = _MYframe.size.height * 0.15 * (1 - present) * 2;
    }
}

@end
