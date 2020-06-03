//
//  XLSearchBarTestV.m
//  Study
//
//  Created by lanbao on 2018/5/25.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLSearchBarTestVC.h"

#import "BarBaseView.h"
#import "XLSearchBar.h"

#import "XLCreateRandom.h"

@interface XLSearchBarTestVC ()
    <UISearchBarDelegate,UITextFieldDelegate>

@property (nonatomic, strong) XLSearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITextView *randomTextView;
@property (weak, nonatomic) IBOutlet UITextView *sortTextView;

@property (nonatomic, copy) NSArray *randomArr;
@property (weak, nonatomic) IBOutlet UILabel *sortTimeLabel;

@property (weak, nonatomic) IBOutlet UITextField *randomNumTextField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation XLSearchBarTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 0, 250, 30);
    
    XLSearchBar *searchBar = [[XLSearchBar alloc]initWithFrame:frame];
    searchBar.placeholder = @"搜索";
    searchBar.displayCenter = YES;
    self.searchBar = searchBar;
    searchBar.delegate = self;
    
    searchBar.tintColor = kMainColor;
    BarBaseView *baseView = [[BarBaseView alloc]initWithFrame:frame];
    [baseView addSubview:searchBar];
    self.navigationItem.titleView = baseView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSInteger count = textField.text.integerValue;
    
    NSLog(@"create random before date = %@", [self msecStringWithDate:[NSDate date]]);
    __block double msec = [[NSDate date] timeIntervalSince1970] * 1000;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *arr = [XLCreateRandom  noRepeatRandomArrayWithMinNum:0 maxNum:count-1 count:count];
        self.randomArr = arr;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDate *date = [NSDate date];
            NSLog(@"create random after date = %@",[self msecStringWithDate:date]);
            double afterMsec = [date timeIntervalSince1970] * 1000;
            NSLog(@"create random msec = %.0f",afterMsec - msec);
            self.randomTextView.text = [arr componentsJoinedByString:@","];
        });
    });
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if (reason == UITextFieldDidEndEditingReasonCommitted) {
        NSInteger count = self.randomNumTextField.text.integerValue;
        
        NSLog(@"create random before date = %@", [self msecStringWithDate:[NSDate date]]);
        __block double msec = [[NSDate date] timeIntervalSince1970] * 1000;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *arr = [XLCreateRandom  noRepeatRandomArrayWithMinNum:0 maxNum:count-1 count:count];
            self.randomArr = arr;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDate *date = [NSDate date];
                NSLog(@"create random after date = %@",[self msecStringWithDate:date]);
                double afterMsec = [date timeIntervalSince1970] * 1000;
                NSLog(@"create random msec = %f",afterMsec - msec);
                self.randomTextView.text = [arr componentsJoinedByString:@","];
            });
        });
    }
}

#pragma mark - button action

- (IBAction)tapButton:(UIButton *)sender {
    
    NSInteger tag = sender.tag - 1000;
    
    [self sortArrayWithType:tag typeStr:sender.titleLabel.text];
}
- (IBAction)clearResultText:(UIButton *)sender {
    self.sortTextView.text = nil;
}

- (void)setupTimeLabelWithStr:(NSString *)str {
    self.sortTimeLabel.text = str;
}

- (void)setupSortTextViewWithArr:(NSArray *)arr {
    self.sortTextView.text = [arr componentsJoinedByString:@","];
}

#pragma mark - 排序算法

- (void)sortArrayWithType:(NSInteger)type typeStr:(NSString *)typeStr {
    
    [self.indicatorView startAnimating];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 开始排序的时间
        __block double msec = [[NSDate date] timeIntervalSince1970] * 10000;
        NSLog(@"sort before date = %@",[self msecStringWithDate:[NSDate date]]);
        
        NSArray *sortArr = nil;
        if (type == 1) {
            sortArr = [self bubbleSortArrWithArr:self.randomArr];
        }
        else if (type == 3) {
            sortArr = [self selectionSortArrWithArr:self.randomArr];
        }
        else if (type == 4) {
            sortArr = [self insertionSortWithArr:self.randomArr];
        }
        
        // 排序完成的时间
        NSDate *date = [NSDate date];
        double afterMsec = [date timeIntervalSince1970] * 10000;
        NSLog(@"sort after date = %@",[self msecStringWithDate:date]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            [self setupTimeLabelWithStr:[NSString stringWithFormat:@"%@用时：%.2f ms",typeStr,(afterMsec-msec)/10.0]];
            [self setupSortTextViewWithArr:sortArr];
        });
    });
}

#pragma mark - 冒泡排序

- (NSArray *)bubbleSortArrWithArr:(NSArray *)arr {
    NSMutableArray <NSNumber *>*mutArr = [NSMutableArray arrayWithArray:arr];
    for (int i = 0; i < arr.count - 1; i++) {
        for (int j = 0; j < arr.count - i - 1; j++) {
            if (mutArr[j].intValue > mutArr[j+1].intValue) {
                id temp = mutArr[j];
                mutArr[j] = mutArr[j+1];
                mutArr[j+1] = temp;
            }
        }
    }
    return [mutArr copy];
}

#pragma mark - 选择排序

- (NSArray *)selectionSortArrWithArr:(NSArray *)arr {
    NSMutableArray <NSNumber *>*mutArr = [NSMutableArray arrayWithArray:arr];
    
    for (int i = 0; i < arr.count - 1; i++) {
        //记录最小的数的位置，首次循环为第一个元素
        int min = i;
        for (int j = i + 1; j < arr.count; j++) {
            //找到最小的数的位置
            if (mutArr[j].intValue < mutArr[min].intValue) {
                min = j;
            }
        }
        //把最小的数换到前面 i 的位置
        id temp = mutArr[i];
        mutArr[i] = mutArr[min];
        mutArr[min] = temp;
    }
    return [mutArr copy];
}
#pragma mark - 插入排序
- (NSArray *)insertionSortWithArr:(NSArray *)arr {
    
    NSMutableArray <NSNumber *>*mutArr = [NSMutableArray arrayWithArray:arr];
    int j;
    NSNumber *temp;
    for (int i = 1; i < arr.count; i++) {
        temp = mutArr[i];
        /* for 循环实现
        for (j = i; j > 0 && mutArr[j-1].intValue > temp.intValue; j--) {
            mutArr[j] = mutArr[j-1];
        }
        mutArr[j] = temp;
         */
        j = i;
        while (j > 0 && mutArr[j-1].intValue > temp.intValue) {
            mutArr[j] = mutArr[j-1];
            j--;
        }
        mutArr[j] = temp;
    }
    return [mutArr copy];
}

- (NSArray *)fastSortWithArr:(NSArray *)arr {
    NSMutableArray <NSNumber *>*mutArr = [NSMutableArray arrayWithArray:arr];
    
    return [mutArr copy];
}

#pragma mark - searchBar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    self.searchBar.displayCenter = NO;
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - method

- (NSString *)msecStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSSS";
    return [formatter stringFromDate:date];
}

@end
