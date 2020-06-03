//
//  WaterFallVC.m
//  StudyDemo
//
//  Created by Lang on 8/29/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import "PicListVC.h"
#import "XLNetRequest.h"
#import "ImageInfo.h"

#import "PicBrowseVC.h"
#import "UIImage+Until.h"


#define kCellIdentifier @"cell"

@interface PicListVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PicBrowseVCDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, copy)NSMutableArray *imageInfos;

@property (nonatomic, assign)NSInteger requestPage;
@property (nonatomic, assign)NSInteger requestPageCapacity;

@property (nonatomic, assign)NSInteger refreshLoadNum;
@property (nonatomic, assign)NSInteger refreshStartNum;
@property (nonatomic, assign)NSInteger refreshCurrentNum;

@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)PicBrowseVC *vc;

@end

@implementation PicListVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.requestPage = 1;
    self.requestPageCapacity = 40;
    
    self.refreshStartNum = 0;
    self.refreshLoadNum = 40;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"壁纸";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
    [self setupRefresh];
    
    [self layoutPageSubViews];
    
    [self requestPicWithRequestPage:self.requestPage];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - collectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageInfos.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageInfo *info = self.imageInfos[indexPath.item];
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor blackColor];
    
    NSUInteger tag = 10;
    UIImageView *imageView = [cell viewWithTag:tag];
    if (!imageView) {
        imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor randomColor];
        imageView.tag = tag;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(cell.contentView);
            make.top.left.equalTo(cell.contentView);
        }];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //从网络获取图片，添加到imageView上
    NSString *imageStr = info.thumb;
    NSString *cacheImageStr = [imageStr stringByAppendingString:@"cacheImage"];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheImageStr];
    
    if (image) {
        imageView.image = image;
    }else{
        __weak typeof(imageView)weakImageView = imageView;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
//            //重新绘制image
            CGSize size = weakImageView.frame.size;
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
            CGPathRef pathRef = [UIBezierPath bezierPathWithRect:weakImageView.bounds].CGPath;
            // 将创建好的路径对象添加到图形上下文中的当前路径
            CGContextAddPath(UIGraphicsGetCurrentContext(), pathRef);
            // 裁剪
            CGContextClip(UIGraphicsGetCurrentContext());
            [weakImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
//            UIImage *newImage = [image resizedImageWithSize:size];
            
            weakImageView.image = newImage;
            [[SDImageCache sharedImageCache] storeImage:newImage forKey:cacheImageStr completion:nil];
            [[SDImageCache sharedImageCache] removeImageForKey:imageStr withCompletion:nil];
        }];
    }
    
    //    __weak __typeof(imageView)weakImageView = imageView;
    
    /*
     __block UIImage *newImage;
     
     [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
     newImage = image;
     
     //生成圆形imageView
     //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //            CGRect imageFrame = imageView.frame;
     //            CGFloat radius = MIN(imageFrame.size.width, imageFrame.size.height) / 2;
     //            CGFloat scale = [UIScreen mainScreen].scale;
     //            UIGraphicsBeginImageContextWithOptions(imageFrame.size, NO, scale);
     //            //            CGContextRef currnetContext = UIGraphicsGetCurrentContext();
     //            CGPathRef cornerRef = [UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:radius].CGPath;
     
     //            CGContextAddPath(UIGraphicsGetCurrentContext(), cornerRef);
     //            CGContextClip(UIGraphicsGetCurrentContext());
     //            [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
     //            newImage = UIGraphicsGetImageFromCurrentImageContext();
     //            UIGraphicsEndImageContext();
     //            dispatch_async(dispatch_get_main_queue(), ^{
     //                imageView.image = newImage;
     //            });
     //            //            NSLog(@"newImage p= %p",newImage);
     //        });
     }];
     */
    return cell;
}

#pragma mark - CollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/2.0 - 1, kScreenWidth/2.0 - 1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PicBrowseVC *vc = [PicBrowseVC showBrowseWithImageInfo:self.imageInfos withCurrentIndex:indexPath.item];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - custom Delegate
//从 大图浏览 返回时，滚动到用户当前查看的图片
- (void)scrollToItemAtIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - request

- (void)requestPicWithRequestPage:(NSInteger)page{
    
    XLNetRequest *request = [[XLNetRequest alloc]init];
    
//    NSString *url = [NSString stringWithFormat:@"http://service.store.dandanjiang.tv/v1/wallpaper/resource?height=2208&limit=%zd&order=%@&skip=%zd&sys_language=zh-Hans-CN&width=1242",self.requestPageCapacity,self.type,self.requestPageCapacity*page];
    
    NSString *url = @"http://service.store.dandanjiang.tv/v1/wallpaper/resource";
    
    NSNumber *width  = @(1242);
    NSNumber *height = @(2208);
    NSNumber *limit  = @(self.requestPageCapacity);
    NSNumber *skip   = @(self.requestPageCapacity*page);
    NSString *language = @"zh-Hans-CN";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:width       forKey:@"width"];
    [param setValue:height      forKey:@"height"];
    [param setValue:limit       forKey:@""];
    [param setValue:skip        forKey:@"skip"];
    [param setValue:self.type   forKey:@"order"];
    [param setValue:language    forKey:@"sys_language"];
    
    [request getWithUrl:url withParams:param success:^(id json) {
        
        self.requestPage++;
        if (self.requestPage == 1) {
            [self.imageInfos removeAllObjects];
        }
        //请求成功
        NSDictionary *data = json[@"res"];
        
        NSArray *arr = data[@"data"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            ImageInfo *info = [ImageInfo imageInfoWithDict:dict];
            [tempArr addObject:info];
        }
        [self.imageInfos addObjectsFromArray:tempArr];
        
        [self.collectionView reloadData];
        
        [self cancelRefresh];
        
    } failure:^(NSError *error) {
       [self cancelRefresh];
    }];
}

- (void)cancelRefresh{
    if([self.collectionView.mj_header isRefreshing]){
        [self.collectionView.mj_header endRefreshing];
    }
    if([self.collectionView.mj_footer isRefreshing]){
        [self.collectionView.mj_footer endRefreshing];
    }
}


- (void)setupRefresh{
    @weakify(self)
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.requestPage = 1;
        [self requestPicWithRequestPage:self.requestPage];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self requestPicWithRequestPage:self.requestPage + 1];
    }];
}


#pragma mark - getter && setter

- (void)setType:(NSString *)type{
    _type = type;
    
}

- (void)setContentOffset:(CGPoint)contentOffset{
    self.collectionView.contentOffset = contentOffset;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    }
    return _collectionView;
}


#pragma mark - layoutPageSubViews

- (NSMutableArray *)imageInfos{
    if (!_imageInfos) {
        _imageInfos = [NSMutableArray array];
    }
    return _imageInfos;
}


- (void)layoutPageSubViews{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

@end
