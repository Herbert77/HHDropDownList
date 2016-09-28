//
//  HHDropDownList.m
//  HHDropDownList
//
//  Created by Herbert Hu on 16/8/4.
//  Copyright © 2016年 Herbert Hu. All rights reserved.
//

#import "HHDropDownList.h"
#import <QuartzCore/QuartzCore.h>
#import "ListCell.h"



@implementation HHDropDownList {
    
    NSMutableArray *_indicatorsArray;
    CAShapeLayer *_indicatorLayer;
    CATextLayer *_textLayer;
    BOOL _isShow;
    
    UITableView *_tableView;
    
    NSArray *_data;
}

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        /**< 默认属性 */
        _indicatorsArray = [[NSMutableArray alloc] init];
        _isShow = NO;
        _isExclusive = NO;
        _haveBorderLine = YES;
        _highlightColor = [UIColor colorWithRed:252/255.0 green:141/255.0 blue:137/255.0 alpha:1.0];
        
        [self setUpUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ADropDownListHasDroppedDown:) name:@"thisDropDownListHasDroppedDown"
                                                   object:nil];
    }
    return self;
}

- (void)setUpUI {
    
    [[self layer] setBorderWidth:0.7];
    [[self layer] setBorderColor:[[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0] CGColor]];
    
    _indicatorLayer = [self createIndicatorWithColor:_highlightColor
                                         andPosition:CGPointMake(self.frame.size.width*6.0/7.0, self.frame.size.height/2.0)];
    
    [self.layer addSublayer:_indicatorLayer];
    
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGesture];
    
    CGPoint position = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    _textLayer = [self createTextLayerWithText:@"iMac" color:[UIColor blackColor] withPosition:position];
    [self.layer addSublayer:_textLayer];
    
    
    _tableView = [self createTableViewAtPosition:CGPointMake(0, self.frame.origin.y+self.frame.size.height)];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView.layer setBorderWidth:0.7];
    [_tableView.layer setBorderColor:[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _indicatorLayer.fillColor = _highlightColor.CGColor;
    
    if (!_haveBorderLine) {
        
        [self.layer setBorderWidth:0.0];
        [_tableView.layer setBorderWidth:0.0];
    }
}

#pragma mark - Layer Drawing
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

- (UITableView *)createTableViewAtPosition:(CGPoint)point {
    
    UITableView *tableView = [[UITableView alloc] init];
    
    [tableView setFrame:CGRectMake(point.x, point.y, self.frame.size.width, 0)];
    [tableView setRowHeight:36.0];
    
    return tableView;
}

- (CATextLayer *)createTextLayerWithText:(NSString *)text color:(UIColor *)color withPosition:(CGPoint)point {

    CGSize size = [self p_calculateTitleSizeWithText:text];
    
    CATextLayer *layer = [[CATextLayer alloc] init];
    
    CGFloat sizeWidth = (size.width < (self.frame.size.width - 10)) ? size.width : self.frame.size.width - 10;
    
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    layer.string = text;
    
    layer.fontSize = 12.0;
    
    layer.alignmentMode = kCAAlignmentCenter;
    
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

#pragma mark - Animation
- (void)animateIndicator:(CAShapeLayer *)ind isforward:(BOOL)isForward withCompletion:(void(^)())completion {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = isForward ? @[@0, @(M_PI)] : @[@(M_PI), @0];
    
    if (!animation.removedOnCompletion) {
        
        [ind addAnimation:animation forKey:animation.keyPath];
    }
    else {
        
        [ind addAnimation:animation andValue:animation.values.lastObject forKeyPath:animation.keyPath];
    }
    
    [CATransaction commit];
    
    completion();
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)isShow completion:(void(^)())completion {
    
    if (isShow) {
        
        [tableView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height, self.frame.size.width, 0)];
        [self.superview addSubview:tableView];
        
        CGFloat tableView_Height = tableView.rowHeight * [tableView numberOfRowsInSection:0];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [tableView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height, self.frame.size.width, tableView_Height)];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [tableView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height, self.frame.size.width, 0)];
            
        } completion:^(BOOL finished) {
            
            [tableView removeFromSuperview];
        }];
        
    }
    
    completion();
}

- (void)animateTextLayer:(CATextLayer *)textLayer isShow:(BOOL)isShow completion:(void(^)())completion {
    
    CGSize size = [self p_calculateTitleSizeWithText:textLayer.string];
    
    CGFloat sizeWidth = (size.width < (self.frame.size.width-10)) ? size.width : self.frame.size.width-10;
    
    [textLayer setBounds:CGRectMake(0, 0, sizeWidth, size.height)];
    
    completion();
}

#pragma mark - Action
- (void)tapped:(UIGestureRecognizer *)gr {
    
    if (_isShow == NO) {
        
        [self animateIndicator:_indicatorLayer isforward:YES withCompletion:^{
            
            _isShow = YES;
        }];
        
        [self animateTableView:_tableView show:YES completion:^{
            
            [self PostNoti_thisDropDownListHasDroppedDown];
        }];
    }
    else {
        
        [self animateIndicator:_indicatorLayer isforward:NO withCompletion:^{
            
            _isShow = NO;
        }];
        
        [self animateTableView:_tableView show:NO completion:^{
            
        }];
    }
}

- (void)reloadListData {
        
    if ([self.delegate respondsToSelector:@selector(listDataForDropDownList:)]) {
        
        _data = [self.dataSource listDataForDropDownList:self];
    }
    
    [_textLayer setString:[_data objectAtIndex:0]];
    
    [self animateTextLayer:_textLayer isShow:YES completion:^{
        
    }];
    
    [_tableView reloadData];
}

- (void)dropDown {
    
    [self animateIndicator:_indicatorLayer isforward:YES withCompletion:^{
        
        _isShow = YES;
    }];
    
    [self animateTableView:_tableView show:YES completion:^{
        
        [self PostNoti_thisDropDownListHasDroppedDown];
    }];
}

- (void)pullBack {
    
    [self animateIndicator:_indicatorLayer isforward:NO withCompletion:^{
        
        _isShow = NO;
    }];
    
    [self animateTableView:_tableView show:NO completion:^{
        
    }];
}

#pragma mark Noti-Action
- (void)ADropDownListHasDroppedDown:(NSNotification *)noti {
    
    id theDropDownList = [noti.userInfo objectForKey:@"dropDownList"];
    
    if (![theDropDownList isEqual:self]) {
        
        [self pullBack];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_data count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"cell";

    ListCell *listCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    listCell.selectedBackgroundView = [[UIView alloc] initWithFrame:listCell.frame];
    
    listCell.selectedBackgroundView.backgroundColor = _highlightColor;
    
    listCell.centerLabel.text = _data[indexPath.row];
    
    return listCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *itemName = [_data objectAtIndex:indexPath.row];
    
    [_textLayer setString:itemName];
    
    [self animateTableView:_tableView show:NO completion:^{
        
        _isShow = NO;
    }];
    
    [self animateIndicator:_indicatorLayer isforward:NO withCompletion:^{
    
    }];
    
    [self animateTextLayer:_textLayer isShow:YES completion:^{
    
    }];
    
    if ([self.delegate respondsToSelector:@selector(dropDownList:didSelectItemName:atIndex:)]) {
        
        [self.delegate dropDownList:self didSelectItemName:itemName atIndex:indexPath.row];
    }
}

#pragma mark - Notification
- (void)PostNoti_thisDropDownListHasDroppedDown {
    
    if (_isExclusive) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"thisDropDownListHasDroppedDown"
                                                            object:nil
                                                          userInfo:@{@"dropDownList":self}];
    }
}


#pragma mark - Private
- (CGSize)p_calculateTitleSizeWithText:(NSString *)text {
    
    CGFloat fontSize = 13.0;
    
    NSDictionary *dic = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:fontSize]};

    CGSize size = [text boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    return size;
}

@end

#pragma mark - CALayer Category
@implementation CALayer (HHAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)animation andValue:(NSValue *)value forKeyPath:(NSString *)keyPath {
    
    [self addAnimation:animation forKey:keyPath];
    [self setValue:value forKeyPath:keyPath];
}

@end
