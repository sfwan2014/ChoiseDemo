//
//  MasterChoiseLayout.h
//  ChoiseDemo
//
//  Created by DBC on 16/7/12.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LayoutSectionTextType = 0,
    LayoutSectionIconType,
    LayoutSectionOtherType,
} LayoutSectionType;

@class MasterChoiseLayout;
@protocol MasterChoiseLayoutDelegate <NSObject>

-(CGSize)masterChoiseLayout:(MasterChoiseLayout *)layout itemSizeForIndexPath:(NSIndexPath *)indexPath;

@optional
-(CGSize)masterChoiseLayout:(MasterChoiseLayout *)layout headerViewSizeForSection:(NSInteger)section;
-(CGSize)masterChoiseLayout:(MasterChoiseLayout *)layout footerViewSizeForSection:(NSInteger)section;

//-(LayoutSectionType)masterChoiseLayout:(MasterChoiseLayout *)layout sectionTypeForSection:(NSInteger)section;
- (NSInteger)masterChoiseLayout:(MasterChoiseLayout *)layout numberOfItemsInSection:(NSInteger)section;// 用于计算高度
// 垂直距离
- (CGFloat)masterChoiseLayout:(MasterChoiseLayout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
// 左右间距
- (CGFloat)masterChoiseLayout:(MasterChoiseLayout*)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

- (UIEdgeInsets)masterChoiseLayout:(MasterChoiseLayout*)layout insetForSectionAtIndex:(NSInteger)section;

@end

@interface MasterChoiseLayout : UICollectionViewLayout
@property (nonatomic, strong) NSMutableArray *layoutInfoArr;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat lineSpacing; // 上下间距
@property (nonatomic, assign) CGFloat interitemSpacing; // 左右间距
@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, assign) id<MasterChoiseLayoutDelegate>delegate;
- (CGSize)caculateContentSize;
@end
