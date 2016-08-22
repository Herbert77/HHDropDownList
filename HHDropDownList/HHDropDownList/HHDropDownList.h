//
//  HHDropDownList.h
//  HHDropDownList
//
//  Created by Herbert Hu on 16/8/4.
//  Copyright © 2016年 Herbert Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HHDropDownList;

@protocol HHDropDownListDataSource <NSObject>

@required
- (NSArray *)listDataForDropDownList:(HHDropDownList *)dropDownList;

@optional

@end


@protocol HHDropDownListDelegate <NSObject>

@optional
- (void)dropDownList:(HHDropDownList *)dropDownList didSelectItemName:(NSString *)itemName atIndex:(NSInteger)index;

@end


@interface HHDropDownList : UIView <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) BOOL haveBorderLine;      /**< 边线 */

@property (strong, nonatomic) UIColor *highlightColor;  /**< 指示三角 和 高亮文本 的颜色 */

@property (assign, nonatomic) BOOL isExclusive;         /**< 是否对其他相同对象排斥(多个DropDownList对象的列表能否同时展开) */

@property (weak, nonatomic) id<HHDropDownListDelegate> delegate;

@property (weak, nonatomic) id<HHDropDownListDataSource> dataSource;

- (void)reloadListData;

- (void)dropDown;   

- (void)pullBack;

@end

@interface CALayer (HHAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath;

@end
