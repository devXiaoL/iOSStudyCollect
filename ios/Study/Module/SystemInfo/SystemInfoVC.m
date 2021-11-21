//
//  SystemInfoVC.m
//  StudyDemo
//
//  Created by Lang on 12/31/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import "SystemInfoVC.h"
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

static NSString *cellIdentifier = @"systemInfo";

@interface SystemInfoVC ()<UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *rowData;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign)long long int lastBytes;
@property (nonatomic, assign)BOOL isFirstRate;

@end

@implementation SystemInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRowData];
    
    self.tableView.rowHeight = 40;
    [self.view addSubview:self.tableView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    // 设置代理
    self.locationManager.delegate = self;
    // 设置定位精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [self.locationManager startUpdatingLocation];
    
    self.lastBytes = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self settingTableViewDataSource:tableView cell:cell indexPath:indexPath];
}

#pragma mark - Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)settingTableViewDataSource:(UITableView *)tableView cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    //    cell.textLabel.font = [UIFont systemFontOfSize:12];
    //    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    NSDictionary *rowData = self.rowData[indexPath.row];
    cell.textLabel.text = rowData[@"title"];
    cell.detailTextLabel.text = rowData[@"value"];
    
}

#pragma mark - location delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    // 纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSString *locationStr = [NSString stringWithFormat:@"经纬度:%f,%f",longitude,latitude];
    [self.rowData removeLastObject];
    [self.rowData addObject:@{@"title": @"Location", @"value": locationStr}];
    [self.tableView reloadData];
}

- (void)createRowData {
    NSString *systemName = [NSString stringWithFormat:@"%@,%@", [[UIDevice currentDevice] systemName],
                            [[UIDevice currentDevice] localizedModel]];
    [self.rowData addObject:@{@"title": @"系统", @"value": systemName}];
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    [self.rowData addObject:@{@"title": @"版本", @"value": systemVersion}];
    
    NSString *iphoneType = [self iphoneType];
    [self.rowData addObject:@{@"title": @"型号", @"value": iphoneType}];
    
    NSString *isProxy = [self fetchHttpProxy] ? @"已使用" : @"未使用";
    [self.rowData addObject:@{@"title": @"是否使用代理", @"value": isProxy}];
    
    NSDictionary *ssidInfo = [self fetchSSIDInfo];
    if (ssidInfo) {
        [self.rowData addObject:@{@"title": @"SSID", @"value": ssidInfo[@"SSID"]}];
        [self.rowData addObject:@{@"title": @"BSSID", @"value": ssidInfo[@"BSSID"]}];
    }
    //    BSSID = "60:da:83:87:4b:80";
    //    SSID = GZQ;
    [self.rowData addObject:@{@"title": @"Location", @"value": @"定位中"}];
}

- (NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
    
}


- (id)fetchHttpProxy {
    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
    const CFStringRef proxyCFstr = (const CFStringRef)CFDictionaryGetValue(dicRef,
                                                                           (const void*)kCFNetworkProxiesHTTPProxy);
    NSString* proxy = (__bridge NSString *)proxyCFstr;
    return  proxy;
}


- (id)fetchSSIDInfo {
    // 参考链接：(iOS中获取WiFi的SSID)[https://www.jianshu.com/p/1e10b927c2ca]
    
    // (__bridge_transfer id)  ==  CFBridgingRelease
    //    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

- (long long) getInterfaceBytes {
    
    struct ifaddrs *ifa_list = 0, *ifa;
    
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    
    uint32_t iBytes = 0;//下行
    
    uint32_t oBytes = 0;//上行
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        
        if (AF_LINK != ifa->ifa_addr->sa_family){
            continue;
        }
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) {
            continue;
        }
        if (ifa->ifa_data == 0) {
                continue;
        }
        
        /* Not a loopback device. */
        
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            
            oBytes += if_data->ifi_obytes;
        }
    }
    
    freeifaddrs(ifa_list);
    
    NSLog(@"\n[getInterfaceBytes-Total]%d,%d",iBytes,oBytes);
    
    return iBytes;
}

- (void)getInternetface {
    
    long long int rate;
    
    long long int currentBytes = [self getInterfaceBytes];
    
    rate = currentBytes -self.lastBytes;
    
    //保存上一秒的下行总流量
    self.lastBytes= [self getInterfaceBytes];
    
    //格式化一下
    NSString*rateStr = [self formatNetWork:rate];
    
    NSLog(@"当前网速%@",rateStr);
    
    //    NSLog(@"hehe:%lld",hehe/1024/1024);
    
}

- (NSString*)formatNetWork:(long long int)rate {
    
    if(rate <1024) {
        
        return[NSString stringWithFormat:@"%lldB/秒", rate];
        
    }else if(rate >=1024&& rate <1024*1024) {
        
        return[NSString stringWithFormat:@"%.1fKB/秒", (double)rate /1024];
        
    }else if(rate >=1024*1024 && rate <1024*1024*1024){
        
        return[NSString stringWithFormat:@"%.2fMB/秒", (double)rate / (1024*1024)];
        
    }else{
        return@"10Kb/秒";
    };
}


- (NSMutableArray *)rowData {
    if (!_rowData) {
        _rowData = [[NSMutableArray alloc] init];
    }
    return _rowData;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

@end
