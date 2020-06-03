//
//  PicBrowseVC.m
//  StudyDemo
//
//  Created by Lang on 10/13/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import "PicBrowseVC.h"
#import <Photos/Photos.h>
#import "ImageInfo.h"

typedef void(^SavePhotoCompletionBlock)(UIImage *image, NSError *error);

static NSInteger const kScrollViewTag = 1080;
static NSInteger const kImageViewTag = 1081;

@interface PicBrowseVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)UIImageView *imageV;

@property (nonatomic, assign)BOOL navHidden;
@property (nonatomic, assign)BOOL firstDisplay;
@property (nonatomic, assign)BOOL isLeft;

@property (nonatomic, assign)NSInteger pictureIndex;

@property (nonatomic, copy)NSArray *imageInfo;


@property (nonatomic, strong)UIImage *currentImage;

@property (nonatomic, assign)NSInteger currentDisplayIndex;

@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UILabel *tagLabel;

@property (nonatomic, assign)CGFloat contentOffset;

@end

@implementation PicBrowseVC

+ (instancetype)showBrowseWithImageInfo:(NSArray *)info withCurrentIndex:(NSInteger)index{
    if (!info) {
        return nil;
    }
    PicBrowseVC *vc = [[PicBrowseVC alloc]initWithImageInfo:info withCurrentIndex:index];
    return vc;
}


- (instancetype)initWithImageInfo:(NSArray *)info withCurrentIndex:(NSInteger)index{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.imageInfo = info;
    _pictureIndex = index;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    
    //    [self.view addSubview:self.backBtn];
    //    [self.view addSubview:self.tagLabel];
    //
    //    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(10);
    //        make.top.mas_equalTo(30);
    //        make.width.height.mas_equalTo(30);
    //    }];
    //    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.collectionView);
    //        make.centerY.equalTo(self.backBtn);
    //        make.height.mas_equalTo(30);
    //    }];
    
    self.collectionView.minimumZoomScale = 1;
    self.collectionView.maximumZoomScale = 3.0;
    [self addGesture];
    [self settingNavBarItem];
    
    self.navHidden = YES;
    
}

- (void)settingNavBarItem{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction:)];
    
    
    self.navigationItem.titleView = self.tagLabel;
    self.navigationItem.leftBarButtonItem = backItem;
    
    
}

- (void)backBtnAction:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    self.navHidden = NO;
    self.firstDisplay = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.pictureIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}


- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    /*
     self.pictureIndex = self.currentDisplayIndex
     是为了在当前界面即将消失，但未消失又再次返回时浏览的还是上次浏览的图片
     （防止跳到上次进入时的图片，因为滚动事件是在viewWillAppear
     */
    self.pictureIndex = self.currentDisplayIndex;
    if ([self.delegate respondsToSelector:@selector(scrollToItemAtIndex:)]) {
        [self.delegate scrollToItemAtIndex:self.currentDisplayIndex];
    }
}

#pragma mark - 缩放大小获取方法
-(CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    //大小
    zoomRect.size.height = self.collectionView.frame.size.height/scale;
    zoomRect.size.width = self.collectionView.frame.size.width/scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageInfo.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [cell.contentView viewWithTag:1080];
    if (!scrollView) {
        scrollView = [[UIScrollView alloc]initWithFrame:cell.contentView.bounds];
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        scrollView.tag = 1080;
        scrollView.delegate = self;
        scrollView.contentSize = cell.contentView.bounds.size;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.minimumZoomScale = 1;
        scrollView.maximumZoomScale = 3;
        [cell.contentView addSubview:scrollView];
    }
    UIImageView *imageView = [scrollView viewWithTag:1081];
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithFrame:scrollView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 1081;
        [scrollView addSubview:imageView];
    }
//    [imageView sd_setShowActivityIndicatorView:YES];
    
    UIButton *downloadBtn = [cell.contentView viewWithTag:(1082+indexPath.item)];
    if (!downloadBtn) {
        downloadBtn = [[UIButton alloc]init];
        [downloadBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        [downloadBtn addTarget:self action:@selector(downloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:downloadBtn];
        [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.bottom.equalTo(cell.contentView).offset(-30);
            make.right.equalTo(cell.contentView).offset(-30);
        }];
    }
    
    ImageInfo *info = self.imageInfo[indexPath.item];
    NSURL *url  = [NSURL URLWithString:info.url];

    [imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        scrollView.contentSize = image.size;
    }];
    
    return cell;
}

//当滑动collectionView时，保持其他的view的缩放比是正常大小
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    UIScrollView *scrollView = [cell.contentView viewWithTag:kScrollViewTag];
    if (scrollView) {
        [scrollView setZoomScale:1];
    }
    if ((indexPath.item >= 0 && (indexPath.item <= self.imageInfo.count - 1))
        && self.firstDisplay) {
        [self setupTagLabel:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //这层判读是为了防止数组越界
    //    if (indexPath.item >= 0 && (indexPath.item <= self.imageInfo.count - 1)) {
    //这么做是为了使 当前页面没有完全滑出界面又返回到当前页面时，taglabel不会消失
    //因为没有完全滑出时再次返回是不会调用willDisplay方法的
    
    //这里判断滑动的方向是因为在当前图片没有完全滑出时，松开手后还是当前图片，但该方法返回的IndexPath时旁边图片的index（因为是didEndDisplayingCell）
    NSInteger index = self.isLeft ? indexPath.item - 1 : indexPath.item + 1;
    
    [self setupTagLabel:index];
    //    }
}


#pragma mark - scrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return [scrollView viewWithTag:kImageViewTag];
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.firstDisplay = NO;
    //拖拽的时候不显示tagLabel
    self.tagLabel.hidden = YES;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x - self.contentOffset > 0) {
        //向右
        self.isLeft = NO;
    }else if(scrollView.contentOffset.x - self.contentOffset < 0){
        //向左
        self.isLeft = YES;
    }
    self.contentOffset = scrollView.contentOffset.x;
}

#pragma mark - method


- (void)downloadButtonAction:(UIButton *)sender {
    [self savePicToPhotoLibray:self.currentImage];
    
}

- (void)setupTagLabel:(NSInteger)index{
    NSString *tagStr = [self tagStrWithIndex:index];
    if (tagStr) {
        self.tagLabel.hidden = NO;
        self.tagLabel.text = tagStr;
        NSLog(@"index = %zd ,tag = %@",index,tagStr);
        
    }else{
        self.tagLabel.hidden = YES;
    }
}

- (void)addGesture{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [longPress setNumberOfTouchesRequired:1];
    [longPress setMinimumPressDuration:1.0];
    
    [self.view addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickGestureAction:)];
    click.numberOfTapsRequired = 1;
    [click requireGestureRecognizerToFail:doubleTap];
    
    [self.view addGestureRecognizer:click];
}

- (void)didClickGestureAction:(UITapGestureRecognizer *)click{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressAction{
    
    if (longPressAction.state == UIGestureRecognizerStateBegan) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self savePicToPhotoLibray:self.currentImage];
        }];
        
        UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享到..." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            /*
            UMSocialMessageObject *object = [UMSocialMessageObject messageObject];
            
            UMShareImageObject *imageObject = [[UMShareImageObject alloc]init];
            imageObject.shareImage = self.currentImage;
            object.shareObject = imageObject;
            object.title = @"壁纸";
            //设置分享面板
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_EverNote)]];
            //显示分享面板
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:object currentViewController:self completion:^(id result, NSError *error) {
                    
                }];
            }];
             */
        }];
        
        [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        [saveAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        
        [alert addAction:cancelAction];
        [alert addAction:saveAction];
        [alert addAction:shareAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tapGestureRecongnizer{
    if ([self screenCurrentScrollView].zoomScale == 1) {
        [[self screenCurrentScrollView] setZoomScale:2 animated:YES];
    }else if ([self screenCurrentScrollView].zoomScale == 2) {
        [[self screenCurrentScrollView] setZoomScale:3 animated:YES];
    } else{
        [[self screenCurrentScrollView] setZoomScale:1 animated:YES];
    }
}

- (void)didClickBackBtn:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
    sender.userInteractionEnabled = YES;
}
#pragma mark - 保存图片到相册

- (void)savePicToPhotoLibray:(UIImage *)image{
    //保存到自定义相册
    // 0.判断状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied ||
        status == PHAuthorizationStatusNotDetermined) {
        NSLog(@"用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关");
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            ////            NSLog(@"status = %@",status);
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"打开照片访问权限，以便保存图片到相册中" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            UIAlertAction *setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
                    [[UIApplication sharedApplication] openURL:settingUrl];
                }
            }];
            [alertCon addAction:setting];
            [alertCon addAction:ok];
            //
            [self presentViewController:alertCon animated:YES completion:nil];
        }];
    }else if (status == PHAuthorizationStatusRestricted){
        NSLog(@"家长控制,不允许访问");
    }else if (status == PHAuthorizationStatusNotDetermined){
        NSLog(@"用户还没有做出选择");
    }else if (status == PHAuthorizationStatusAuthorized){
        NSLog(@"用户允许当前应用访问相册");
        [self saveImage:image];
    }
}

/**
 *  返回相册,避免重复创建相册引起不必要的错误
 */
- (void)saveImage:(UIImage *)image{
    /*
     PHAsset : 一个PHAsset对象就代表一个资源文件,比如一张图片
     PHAssetCollection : 一个PHAssetCollection对象就代表一个相册
     */
    __block UIImage *blockImage = image;
    __block NSString *assetId;
    
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    // 1. 存储图片到"相机胶卷"
    [library performChanges:^{ // 这个block里保存一些"修改"性质的代码
        // 新建一个PHAssetCreationRequest对象, 保存图片到"相机胶卷"
        // 返回PHAsset(图片)的字符串标识
        assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:blockImage].placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error1%@", error);
            return;
        }
        NSLog(@"成功保存图片到相机胶卷中");
        [self saveImageToCustomAlbum:assetId];
    }];
}

- (void)saveImageToCustomAlbum:(NSString *)assetId {
    // 1. 获取自定义相册
    [self getPHAssetCollection:^(PHAssetCollection *customCollection) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 新建一个PHAssetCreationRequest对象, 保存图片到 自定义相册
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:customCollection];
            // 根据唯一标示获得相片对象
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
            // 添加图片到相册中
            [request addAssets:@[asset]];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                NSLog(@"保存图片到相机胶卷中失败");
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD setMinimumDismissTimeInterval:2];
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            });
            
        }];
    }];
}

/**
 *  获得【自定义相册】
 */
- (void)getPHAssetCollection:(void(^)(PHAssetCollection *))customCollection
{
    // 获取软件的名字作为相册的标题
    NSString *title = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            customCollection(collection);
            return;
        }
    }
    // 代码执行到这里，说明还没有自定义相册
    __block NSString *createdCollectionId = nil;
    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        PHAssetCollection *collection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
        customCollection(collection);
    } error:nil];
}

#pragma mark - getter && setter

- (NSString *)tagStrWithIndex:(NSInteger)index{
    ImageInfo *info = self.imageInfo[index];
    
    if (info.tag.count > 0) {
        NSMutableString *mutStr = [NSMutableString string];
        for (NSString *str in info.tag) {
            [mutStr appendFormat:@" %@",str];
        }
        self.tagLabel.text = mutStr;
        NSLog(@"index = %zd ,tag = %@",index,mutStr);
        return mutStr;
    }else{
        return nil;
    }
}

- (UICollectionViewCell *)currentDisplayCell{
    NSArray *arr = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = [arr lastObject];
    return [self.collectionView cellForItemAtIndexPath:indexPath];
}

- (UIScrollView *)screenCurrentScrollView{
    
    return [[self currentDisplayCell].contentView viewWithTag:kScrollViewTag];
}

- (UIImageView *)currentDisplayImageView{
    
    return [[self screenCurrentScrollView] viewWithTag:kImageViewTag];
}

- (UIImage *)currentImage{
    if ([self currentDisplayImageView]) {
        _currentImage = [self currentDisplayImageView].image;
    }
    return _currentImage;
}

- (NSInteger)currentDisplayIndex{
    NSArray *arr = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = [arr lastObject];
    _currentDisplayIndex = indexPath.item;
    return _currentDisplayIndex;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = self.view.bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.bounces = NO;
        
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
        _tagLabel.text = @"我显示标签的label";
        _tagLabel.backgroundColor = [UIColor grayColor];
        _tagLabel.alpha = 0.5;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.hidden = YES;
        _tagLabel.font = [UIFont systemFontOfSize:12];
        [_tagLabel sizeToFit];
    }
    return _tagLabel;
}

@end
