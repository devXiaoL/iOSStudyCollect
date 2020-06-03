//
//  PicMainVC.m
//  StudyDemo
//
//  Created by Lang on 10/21/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import "PicMainVC.h"
#import "PicListVC.h"
#import "PicCategoryListVC.h"

static NSInteger const kMARGIN = 2;

#define xViewSize self.view.frame.size
#define xViewWidth xViewSize.width
#define xViewHeight xViewSize.height

#define kMenuLineHeight 2
#define kMenuLineWidthScale 0.3

@interface PicMainVC ()<UIScrollViewDelegate>

@property (nonatomic, strong)UISegmentedControl *segment;
@property (nonatomic, copy)NSArray *items;
@property (nonatomic, strong)PicListVC *latestPicVC;
@property (nonatomic, strong)PicListVC *hotPicVC;
@property (nonatomic, strong)PicCategoryListVC *categoryVC;

@property (nonatomic, strong)UIViewController *currentVC;

@property (nonatomic, strong)UIView *titlesView;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, copy) NSArray *names;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentBtnTag;

@end

@implementation PicMainVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"壁纸";
    
    self.currentBtnTag = 1000;
    
    self.names = nil;
    
    [self.names objectAtIndex:1];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.items = @[@"分类",@"最新",@"最热"];
    
    self.categoryVC = [[PicCategoryListVC alloc]init];
    
    self.latestPicVC = [[PicListVC alloc]init];

    self.latestPicVC.type = @"new";
    
    self.hotPicVC = [[PicListVC alloc]init];
    
    self.hotPicVC.type = @"hot";
    
    self.currentVC = self.latestPicVC;
    
    [self.view addSubview:self.contentScrollView];
    [self.view addSubview:self.titlesView];
    
    
    [self addChildViewController:self.categoryVC];
    [self addChildViewController:self.latestPicVC];
    [self addChildViewController:self.hotPicVC];
    
    [self.contentScrollView addSubview:self.categoryVC.view];
    [self.contentScrollView addSubview:self.latestPicVC.view];
    [self.contentScrollView addSubview:self.hotPicVC.view];
    
    [self setupTitlesView];
    
    [self pageViewLayoutSubviews];
    
    NSArray *arr = @[@"2",@"6"];
    NSArray *mArr = [[NSArray alloc]initWithArray:arr copyItems:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat widthScale = kMenuLineWidthScale;
    CGFloat x = xViewWidth/self.items.count * (1 - widthScale) / 2.0;
    //CGFloat x = (xViewWidth/self.items.count - xViewWidth/self.items.count*0.7)/2.0;
    CGFloat w = xViewWidth/self.items.count;
    CGFloat h = kMenuLineHeight;
    CGFloat y = self.titleScrollView.bounds.size.height-h;
    self.lineView.frame = CGRectMake(x + offsetX*(w/kScreenWidth),
                                     y, w*widthScale, h);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

#pragma mark - setupTitlesView

- (void)setupTitlesView{
    
    for (int i = 0; i < self.items.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.tag = 1000 + i;
        
        CGFloat w = self.titleScrollView.frame.size.width/self.items.count;
        CGFloat x = w*i;
        CGFloat y = 0;
        CGFloat h = self.titleScrollView.frame.size.height;
        
        button.frame = CGRectMake(x, y, w, h);
        
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:self.items[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleScrollView addSubview:button];
    }
    
    UIView *lineView = [[UIView alloc]init];
    CGFloat x = (xViewWidth/self.items.count - (xViewWidth/self.items.count)*kMenuLineWidthScale)/2.0;
    CGFloat y = self.titleScrollView.bounds.size.height-kMenuLineHeight;
    lineView.frame = CGRectMake(x, y, (xViewWidth/self.items.count)*kMenuLineWidthScale, kMenuLineHeight);
    lineView.backgroundColor = kMainColor;
    
    self.lineView = lineView;
    
    [self.titlesView addSubview:self.titleScrollView];
    [self.titlesView addSubview:lineView];
}

#pragma mark - action

- (void)titleBtnAction:(UIButton *)btn{
    
    UITabBarController *tabBarC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;

    
    NSInteger tag = btn.tag;
    if (self.currentPage == tag - 1000) {
        return;
    }
    self.currentPage = tag - 1000;
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = kScreenWidth * self.currentPage;
    [self.contentScrollView setContentOffset:offset animated:YES];
}

#pragma mark - getter && setter

- (UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
        _titleScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _titleScrollView.contentSize = frame.size;
    }
    return _titleScrollView;
}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]init];
        if (@available(iOS 11.0, *)) {
            _contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
        _contentScrollView.alwaysBounceVertical = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.backgroundColor = [UIColor blueColor];
//        _contentScrollView.contentSize = CGSizeMake(kScreenWidth*3, self.view.bounds.size.height-40);
    }
    return _contentScrollView;
}

- (UIView *)titlesView{
    if (!_titlesView) {
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
        _titlesView = [[UIView alloc]initWithFrame:frame];
    }
    return _titlesView;
}

- (void)pageViewLayoutSubviews{
    
    [self.titlesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.titlesView).insets(UIEdgeInsetsZero);
    }];
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titlesView.mas_bottom).offset(0);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.contentScrollView.contentSize = CGSizeMake(kScreenWidth*3, self.view.bounds.size.height-40);
    
    self.categoryVC.view.frame = CGRectMake(0, 0, kScreenWidth, self.view.mj_h-40);
    self.latestPicVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.view.mj_h-40);
    self.hotPicVC.view.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.view.mj_h-40);
}



@end
