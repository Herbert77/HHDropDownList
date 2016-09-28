//
//  ViewController.m
//  HHDropDownList
//
//  Created by Herbert Hu on 16/8/4.
//  Copyright © 2016年 Herbert Hu. All rights reserved.
//

#import "ViewController.h"
#import "HHDropDownList.h"

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define List_Width      (SCREEN_WIDTH+1.4)/3.0


@interface ViewController () <HHDropDownListDelegate, HHDropDownListDataSource>

@property (strong, nonatomic) HHDropDownList *dropDownList_1;

@property (strong, nonatomic) HHDropDownList *dropDownList_2;

@property (strong, nonatomic) HHDropDownList *dropDownList_3;

@property (strong, nonatomic) UIView *shadowView;

@property (strong, nonatomic) UIButton *button_1;

@property (strong, nonatomic) UIButton *button_2;

@property (strong, nonatomic) UIButton *button_3;

@property (strong, nonatomic) NSArray *dataArray;

@property (assign, nonatomic) BOOL swayBool;

@end

@implementation ViewController

#pragma mark - View's Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.dropDownList_1];
    [self.view addSubview:self.dropDownList_2];
    [self.view addSubview:self.dropDownList_3];
    
//    [self.view insertSubview:self.shadowView belowSubview:self.dropDownList_1];
    
    [self.view addSubview:self.button_1];
    [self.view addSubview:self.button_2];
    [self.view addSubview:self.button_3];
    
    [self action_3:nil];
}

#pragma mark - Getter
- (HHDropDownList *)dropDownList_1 {
    
    if (!_dropDownList_1) {
        
        _dropDownList_1 = [[HHDropDownList alloc] initWithFrame:CGRectMake(0, 100, List_Width, 50)];
        [_dropDownList_1 setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
        [_dropDownList_1 setHighlightColor:[UIColor colorWithRed:125/255.0 green:238/255.0 blue:161/255.0 alpha:1.0]];
        [_dropDownList_1 setDelegate:self];
        [_dropDownList_1 setDataSource:self];
        
        [_dropDownList_1 setIsExclusive:YES];
        [_dropDownList_1 setHaveBorderLine:YES];
    }
    return _dropDownList_1;
}

- (HHDropDownList *)dropDownList_2 {
    
    if (!_dropDownList_2) {
        
        _dropDownList_2 = [[HHDropDownList alloc] initWithFrame:CGRectMake(List_Width-0.7, 100, List_Width, 50)];
        [_dropDownList_2 setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
        [_dropDownList_2 setDelegate:self];
        [_dropDownList_2 setDataSource:self];
        
        [_dropDownList_2 setIsExclusive:YES];
        [_dropDownList_2 setHaveBorderLine:YES];
    }
    return _dropDownList_2;
}

- (HHDropDownList *)dropDownList_3 {
    
    if (!_dropDownList_3) {
        
        _dropDownList_3 = [[HHDropDownList alloc] initWithFrame:CGRectMake(List_Width*2-1.4, 100, List_Width, 50)];
        [_dropDownList_3 setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
        [_dropDownList_3 setDelegate:self];
        [_dropDownList_3 setDataSource:self];
        
        [_dropDownList_3 setIsExclusive:YES];
        [_dropDownList_3 setHaveBorderLine:YES];
    }
    return _dropDownList_3;
}

- (UIView *)shadowView {
    
    if (!_shadowView) {
        
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 50)];
        _shadowView.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1.0];
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 1);
        _shadowView.layer.shadowOpacity = 0.2;
        _shadowView.layer.shadowRadius = 1;
    }
    return _shadowView;
}

- (UIButton *)button_1 {
    
    if (!_button_1) {
        
        _button_1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-80-100, 400, 100, 40)];
        [_button_1 setBackgroundColor:[UIColor purpleColor]];
        [_button_1 setTitle:@"dropDown" forState:UIControlStateNormal];
        [_button_1 addTarget:self action:@selector(action_1:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button_1;
}

- (UIButton *)button_2 {
    
    if (!_button_2) {
        
        _button_2 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0+80, 400, 100, 40)];
        [_button_2 setBackgroundColor:[UIColor lightGrayColor]];
        [_button_2 setTitle:@"pullBack" forState:UIControlStateNormal];
        [_button_2 addTarget:self action:@selector(action_2:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button_2;
}

- (UIButton *)button_3 {
    
    if (!_button_3) {
        
        _button_3 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-50, 400, 100, 40)];
        [_button_3 setBackgroundColor:[UIColor orangeColor]];
        [_button_3 setTitle:@"reloadList" forState:UIControlStateNormal];
        [_button_3 addTarget:self action:@selector(action_3:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button_3;
}


#pragma mark - Action
- (void)action_1:(UIButton *)btn {
    
    [self.dropDownList_1 dropDown];
}

- (void)action_2:(UIButton *)btn {
    
    [self.dropDownList_1 pullBack];
}

- (void)action_3:(UIButton *)btn {
    
    [self.dropDownList_1 pullBack];
    
    NSArray *array_1 = @[@"MacBook Air", @"MacBook Pro", @"newMacBook", @"Mac Pro"];
    NSArray *array_2 = @[@"iPhone SE", @"iPhone 6", @"iPhone 6S", @"iPhone 7"];
    
    _swayBool = !_swayBool;
    
    _dataArray = _swayBool ? array_1 : array_2;
    
    [self.dropDownList_1 reloadListData];
    [self.dropDownList_2 reloadListData];
    [self.dropDownList_3 reloadListData];
}

#pragma mark - HHDropDownListDataSource
- (NSArray *)listDataForDropDownList:(HHDropDownList *)dropDownList {
    
    return _dataArray;
}

#pragma mark - HHDropDownListDelegate 
- (void)dropDownList:(HHDropDownList *)dropDownList didSelectItemName:(NSString *)itemName atIndex:(NSInteger)index {
    
    
}

@end
