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
#import <UIImage+MultiFormat.h>


#define kCellIdentifier @"cell"

@interface PicListVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PicBrowseVCDelegate, SDWebImageManagerDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, copy)NSMutableArray *imageInfos;

@property (nonatomic, assign)NSInteger requestPage;
@property (nonatomic, assign)NSInteger requestPageCapacity;

@property (nonatomic, assign)NSInteger refreshLoadNum;
@property (nonatomic, assign)NSInteger refreshStartNum;
@property (nonatomic, assign)NSInteger refreshCurrentNum;

@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)PicBrowseVC *vc;
@property (nonatomic, assign) BOOL isHidden;

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
    
//    [SDWebImageManager sharedManager].delegate = self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isHidden = YES;
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
    cell.contentView.opaque = YES;
    cell.contentView.backgroundColor = [UIColor blackColor];
    cell.contentView.contentMode = UIViewContentModeScaleAspectFill;
    cell.contentView.clipsToBounds = YES;
    cell.contentView.layer.shouldRasterize = YES;
    NSUInteger tag = 108888;
    UIImageView *imageView = [cell viewWithTag:tag];
    if (!imageView) {
        imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.opaque = YES;
        imageView.clipsToBounds = YES;
        //imageView.backgroundColor = [UIColor randomColor];
        imageView.backgroundColor = cell.contentView.backgroundColor;
        imageView.tag = tag;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(cell.contentView);
            make.top.left.equalTo(cell.contentView);
        }];
    }
    
    NSURL *imageURL = [NSURL URLWithString:info.thumb];
    NSString *cacheImageKey = [[SDWebImageManager.sharedManager cacheKeyForURL:[NSURL URLWithString:info.thumb]] stringByAppendingString:@"thumb"];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheImageKey];
    if (image) {
        imageView.image = image;
    } else {
        [SDWebImageManager.sharedManager loadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {

            UIImage *newImage = [self imageScaleByImageIO:data size:cell.contentView.bounds.size];

            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = newImage;
            });

            [[SDImageCache sharedImageCache] storeImage:newImage forKey:cacheImageKey completion:nil];
            [[SDImageCache sharedImageCache] removeImageForKey:info.thumb withCompletion:nil];
        }];
    }
    /*
     [imageView sd_setImageWithURL:[NSURL URLWithString:info.thumb] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
         NSLog(@"image = %@, cacheType=%zd, imageURL = %@", image, cacheType, imageURL);
     }];
     
    //从网络获取图片，添加到imageView上
    NSString *imageStr = info.thumb;
    NSString *cacheImageStr = [imageStr stringByAppendingString:@"cacheImage"];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheImageStr];
    
    if (image) {
        //imageView.image = image;
        cell.contentView.layer.contents = (id)image.CGImage;
    }else{
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:imageStr] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {

            UIImage *newImage = [self imageScaleByImageIO:data size:cell.contentView.bounds.size];

            dispatch_async(dispatch_get_main_queue(), ^{
                //weakImageView.image = newImage;
                cell.contentView.layer.contents = (id)newImage.CGImage;
            });

            [[SDImageCache sharedImageCache] storeImage:newImage forKey:cacheImageStr completion:nil];
            [[SDImageCache sharedImageCache] removeImageForKey:imageStr withCompletion:nil];
        }];
    }
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

#pragma mark - SDWebImageManager

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL {
    if (self.isHidden) {
        return image;
    }
    NSData *data = [image sd_imageDataAsFormat:SDImageFormatUndefined];
    CGSize size = CGSizeMake(kScreenWidth/2.0 - 1, kScreenWidth/2.0 - 1);
    UIImage *newImage = [self imageScaleByImageIO:data size:size];
    return newImage;
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


- (UIImage *)imageScaleByCoreGraphic:(UIImage *)image size:(CGSize)size {
    //重新绘制image
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    CGPathRef pathRef = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)].CGPath;
//    // 将创建好的路径对象添加到图形上下文中的当前路径
//    CGContextAddPath(UIGraphicsGetCurrentContext(), pathRef);
//    // 裁剪
//    CGContextClip(UIGraphicsGetCurrentContext());
//    // [weakImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    CFRelease(pathRef);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, size.width, size.height), image.CGImage);
    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return imageOut;
}

- (UIImage *)imageScaleByImageIO:(NSData *)imageData size:(CGSize)size {
    NSDictionary *imageSourceOptions = @{
        (__bridge NSString *)kCGImageSourceShouldCache: @NO // 原始图像不要解码
    };
    CGImageSourceRef imageSource =
//            CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, (__bridge CFDictionaryRef)imageSourceOptions);
    CGImageSourceCreateWithData((__bridge  CFDataRef)imageData, (__bridge CFDictionaryRef)imageSourceOptions);
    // 下采样
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat maxDimensionInPixels = MAX(size.width, size.height) * scale;
    
    /* CGImageSource的键值说明
        kCGImageSourceCreateThumbnailWithTransform - 设置缩略图是否进行Transfrom变换
        kCGImageSourceCreateThumbnailFromImageAlways - 设置是否创建缩略图，无论原图像有没有包含缩略图，默认kCFBooleanFalse，影响 CGImageSourceCreateThumbnailAtIndex 方法
        kCGImageSourceCreateThumbnailFromImageIfAbsent - 设置是否创建缩略图，如果原图像有没有包含缩略图，则创建缩略图，默认kCFBooleanFalse，影响 CGImageSourceCreateThumbnailAtIndex 方法
        kCGImageSourceThumbnailMaxPixelSize - 设置缩略图的最大宽/高尺寸 需要设置为CFNumber值，设置后图片会根据最大宽/高 来等比例缩放图片
        kCGImageSourceShouldCache - 设置是否以解码的方式读取图片数据 默认为kCFBooleanTrue，如果设置为true，在读取数据时就进行解码 如果为false 则在渲染时才进行解码 */
    NSDictionary *downsampleOptions =
    @{
      (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways: @YES,
      (__bridge NSString *)kCGImageSourceShouldCacheImmediately: @YES,  // 缩小图像的同时进行解码
      (__bridge NSString *)kCGImageSourceCreateThumbnailWithTransform: @YES,
      (__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize: @(maxDimensionInPixels)
       };
    CGImageRef downsampledImage =
    CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (__bridge CFDictionaryRef)downsampleOptions);
    UIImage *newImage = [[UIImage alloc] initWithCGImage:downsampledImage scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(downsampledImage);
    CFRelease(imageSource);
    return newImage;
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
