//
//  ScanAppViewController.m
//  StudyDemo
//
//  Created by lanbao on 2017/9/4.
//  Copyright © 2017年 Lang. All rights reserved.
//

#import "ScanAppViewController.h"
#import <objc/runtime.h>

@interface ScanAppViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *imagePathArr;
@property (nonatomic, copy) NSArray *appNameArr;
@property (nonatomic, copy) NSArray *bundleidArr;

@end

@implementation ScanAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"已安装应用列表";
    self.tableView.tableFooterView = [UIView new];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    self.imagePathArr =  [userDefaults objectForKey:@"APP_ICON_PATH_ARR"];
//    self.appNameArr =  [userDefaults objectForKey:@"APP_NAME_ARR"];
    
//    if (!self.imagePathArr && self.imagePathArr.count == 0) {
        [self scanApp];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imagePathArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:self.imagePathArr[indexPath.row]];
    
    cell.imageView.image = image;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    NSString *name = self.appNameArr[indexPath.row];
    cell.textLabel.text = name;
    cell.detailTextLabel.text = self.bundleidArr[indexPath.row];
    
    
    return cell;
}


-(void)scanApp{
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = @"扫描中......";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
        Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
        
        NSObject *workspace = [LSApplicationWorkspace_class performSelector:NSSelectorFromString(@"defaultWorkspace")];
        
        NSArray *apps = [workspace performSelector:NSSelectorFromString(@"allApplications")];
        
        NSMutableArray *bundles = [NSMutableArray arrayWithCapacity:apps.count];
        NSMutableArray *imagePaths = [NSMutableArray arrayWithCapacity:apps.count];
        NSMutableArray *appNames = [NSMutableArray arrayWithCapacity:apps.count];
        [apps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
//            NSDictionary *dict = [obj properties_aps];
//            NSLog(@"dict = %@",dict);
            NSDictionary *boundIconsDictionary = [obj performSelector:@selector(boundIconsDictionary)];
            
            NSString *iconPath = [NSString stringWithFormat:@"%@/%@.png", [[obj performSelector:NSSelectorFromString(@"resourcesDirectoryURL")] path], [[[boundIconsDictionary objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]lastObject]];
            [imagePaths addObject:iconPath];
            
            if (iconPath)
            {
                [appNames addObject:[obj performSelector:NSSelectorFromString(@"localizedName")]];
            }
            [bundles addObject:[obj performSelector:@selector(applicationIdentifier)]];
        }];
        self.imagePathArr = imagePaths;
        self.appNameArr = appNames;
        self.bundleidArr = bundles;
        NSLog(@"bundles = %@",bundles);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.imagePathArr forKey:@"APP_ICON_PATH_ARR"];
            [userDefaults setObject:self.appNameArr forKey:@"APP_NAME_ARR"];
            [userDefaults synchronize];
            
            [self.tableView reloadData];
        });
    });
    
    
    
    
}

@end
