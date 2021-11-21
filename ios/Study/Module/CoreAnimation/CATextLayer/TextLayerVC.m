//
//  TextLayerVC.m
//  Study
//
//  Created by Lang on 2019/6/9.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import "TextLayerVC.h"
#import "YYFPSLabel.h"
#import <UIImage+YYAdd.h>

@interface TextLayerVC ()<UITableViewDataSource,UITableViewDelegate, CAAnimationDelegate>

@property (nonatomic, assign)BOOL labelEnable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TextLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"CATextLayer";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[TextLayerCell class] forCellReuseIdentifier:@"textLayerCell"];
    
    YYFPSLabel *fps = [[YYFPSLabel alloc] init];
    fps.frame = CGRectMake(self.view.mj_w - 15 - 60, 50, 60, 25);
    [self.view addSubview:fps];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"UILabel" style:UIBarButtonItemStylePlain target:self action:@selector(switchLabelAction:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = @"Core Animation提供了一个CALayer的子类CATextLayer，它以图层的形式包含了UILabel几乎所有的绘制特性，并且额外提供了一些新的特性。同样，CATextLayer也要比UILabel渲染得快得多。很少有人知道在iOS 6及之前的版本，UILabel其实是通过WebKit来实现绘制的，这样就造成了当有很多文字的时候就会有极大的性能压力。而CATextLayer使用了Core text，并且渲染得非常快。CATextLayer渲染文本时禁用子像素抗锯齿。只有在光栅化的同时将文本合成到现有的不透明背景中时，才能使用子像素抗锯齿来绘制文本。在将背景像素编织成文本像素之前，无法在子像素抗锯齿中自己绘制文本，无论是图像还是图层。将opacity图层的属性设置为YES不会更改渲染模式。";
    
    NSString *result = [NSString stringWithFormat:@"index===>%zd===>%@", indexPath.section, text];
    
    if (self.labelEnable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = result;
        
        return cell;
    }
    
    TextLayerCell *textLayerCell = [tableView dequeueReusableCellWithIdentifier:@"textLayerCell"];
    
    [textLayerCell setupText:result];
    
    return textLayerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (void)switchLabelAction:(UIBarButtonItem *)item {
    self.labelEnable = !self.labelEnable;
    
    item.title = self.labelEnable ? @"TextLayer" :@"UILabel";
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *newVC = [UIViewController new];
    newVC.navigationItem.title = @"push";
    newVC.view.backgroundColor = [UIColor whiteColor];
    
    //1.初始化
    CATransition  *transition = [CATransition animation];
//    2.设置动画时长,设置代理人
    transition.duration = 1.0f;
    transition.delegate = self;
//    3.设置切换速度效果
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    枚举值:
//    kCAMediaTimingFunctionLinear
//    kCAMediaTimingFunctionEaseIn
//    kCAMediaTimingFunctionEaseOut
//    kCAMediaTimingFunctionEaseInEaseOut
//    kCAMediaTimingFunctionDefault
    
//    4.动画切换风格
    transition.type = kCATransitionPush;
//    枚举值:
//    kCATransitionFade = 1,     // 淡入淡出
//    kCATransitionPush,         // 推进效果
//    kCATransitionReveal,       // 揭开效果
//    kCATransitionMoveIn,       // 慢慢进入并覆盖效果
//    5.动画切换方向
    transition.subtype = kCATransitionFromTop;//顶部
//    枚举值:
//    kCATransitionFromRight//右侧
//    kCATransitionFromLeft//左侧
//    kCATransitionFromTop//顶部
//    kCATransitionFromBottom//底部
//    6.进行跳转
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:newVC animated:NO];
}

@end


@interface TextLayerCell ()

@property (strong, nonatomic) UIView *labelView;
@property (nonatomic, strong)CATextLayer *textLayer;

@end


@implementation TextLayerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.opaque = YES;
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    [self setupTextLayer];
    [self setupShapeLayer];
    [self setupCorner];
}

- (void)setupTextLayer {
    
    UIView *labelView = [[UIView alloc] init];
    labelView.frame = CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width - 30, 100);
    self.labelView = labelView;
    [self.contentView addSubview:self.labelView];
    
    // create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = labelView.bounds;
    [self.labelView.layer addSublayer:textLayer];
    
    // set text attributes
    textLayer.foregroundColor = [UIColor orangeColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    // set font
    UIFont *font = [UIFont systemFontOfSize:14];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    // set scale
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    self.textLayer = textLayer;
}

- (void)setupShapeLayer {
    #pragma mark - 圆形
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 200)];
    [path addArcWithCenter:CGPointMake(100, 200) radius:50 startAngle:0 endAngle:M_PI clockwise:NO];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    // 画笔颜色
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    // 填充的颜色
    shapeLayer.fillColor = [UIColor greenColor].CGColor;
    // 线条宽度
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    [self.contentView.layer addSublayer:shapeLayer];
    
    #pragma mark - 圆角矩形
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    // 画笔颜色
    shapeLayer1.strokeColor = [UIColor redColor].CGColor;
    // 填充的颜色
    shapeLayer1.fillColor = [UIColor orangeColor].CGColor;
    CGRect rect = CGRectMake(200, 150, 150, 100);
    // 圆角（上下左右可以单独设置）
    UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight;
    // 绘制路径
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(10, 10)];
    shapeLayer1.path = path1.CGPath;
    [self.contentView.layer addSublayer:shapeLayer1];
}

- (void)setupCorner {
    [self setupCorner2];
}

- (void)setupCorner1 {
    self.contentView.backgroundColor = [UIColor grayColor];
    self.contentView.layer.cornerRadius = 8;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setupCorner2 {
    // 单独使用不会引发离屏渲染
    self.contentView.layer.masksToBounds = YES;
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
    //    UIImage *cornerImage = [self cornerImageWithSize:size corners:UIRectCornerAllCorners radius:10 backgroundColor:[UIColor lightGrayColor]];
    UIImage *cornerImage = [UIImage imageWithColor:[UIColor grayColor] size:size];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cornerImage];
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    [self.contentView insertSubview:imageView atIndex:0];

//    self.contentView.layer.contents = (__bridge id)cornerImage.CGImage;
    
    // 设置阴影不透明度
//    self.contentView.layer.shadowOpacity = 0.5;
//    CGMutablePathRef squarePath = CGPathCreateMutable();
//    CGPathAddRect(squarePath, NULL, CGRectMake(0, 0, size.width, size.height));
//    self.contentView.layer.shadowPath = squarePath;
//    CGPathRelease(squarePath);
}

- (void)setupText:(NSString *)text {
    self.textLayer.string = text;
}

- (UIImage *)cornerImageWithSize:(CGSize)size corners:(UIRectCorner)corners radius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(contextRef,path.CGPath);
    CGContextClip(contextRef);
    CGContextSetFillColorWithColor(contextRef, backgroundColor.CGColor);
    CGContextFillRect(contextRef, rect);
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    UIImage *cornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cornerImage;
}

@end

