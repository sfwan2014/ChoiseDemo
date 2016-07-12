//
//  MasterChoiseLayout.m
//  ChoiseDemo
//
//  Created by DBC on 16/7/12.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "MasterChoiseLayout.h"

@interface MasterChoiseLayout ()
//@property (nonatomic, assign) CGSize contentSize;
//@property (nonatomic, assign) CGSize itemSize;
//@property (nonatomic, assign) CGFloat lineSpacing;
//@property (nonatomic, assign) CGFloat interitemSpacing;

@end

@implementation MasterChoiseLayout
{
    NSInteger _offsetRow; // 当前第几行
    CGFloat _offsetX;// 当前偏移量
    CGFloat _offsetY;// 当前偏移量
    CGFloat _lastItemHeight;
    LayoutSectionType _type; // 单元格类型
}

- (void)prepareLayout{
    [super prepareLayout];
    
    _offsetRow = 0;
    _offsetX = self.contentInset.left;
    _offsetY = self.contentInset.top;
    
    NSMutableArray *layoutInfoArr = [NSMutableArray array];
    NSInteger maxNumberOfItems = 0;
    //获取布局信息
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    
    CGFloat headerViewHeight = 0;
    
    for (NSInteger section = 0; section < numberOfSections; section++){
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *subArr = [NSMutableArray arrayWithCapacity:numberOfItems];
        for (NSInteger item = 0; item < numberOfItems; item++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            if (item == 0) {
                UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                if (headerAttributes != nil) {
                    [subArr addObject:headerAttributes];
                    headerViewHeight += headerAttributes.frame.size.height;
                }
         
//                _type = [self sectionTypeAtIndexPath:indexPath];
            }
            
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [subArr addObject:attributes];
            
            _lastItemHeight = attributes.frame.size.height;
            
        }
        
        
        if(maxNumberOfItems < numberOfItems){
            maxNumberOfItems = numberOfItems;
        }
        //添加到二维数组
        [layoutInfoArr addObject:[subArr copy]];
    }
    //存储布局信息
    self.layoutInfoArr = [layoutInfoArr copy];
    //保存内容尺寸
    self.contentSize = CGSizeMake(self.collectionView.frame.size.width, _offsetY+_lastItemHeight+self.contentInset.bottom+self.lineSpacing);
}

- (CGSize)collectionViewContentSize{
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *layoutAttributesArr = [NSMutableArray array];
    [self.layoutInfoArr enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger i, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(CGRectIntersectsRect(obj.frame, rect)) {
                [layoutAttributesArr addObject:obj];
            }
        }];
    }];
    return layoutAttributesArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
//    if (_type == LayoutSectionTextType) {
        CGSize size = [self itemSizeAtIndexPath:indexPath];
        CGFloat offsetX = _offsetX;// 上次偏移量
        
        if (offsetX +size.width + self.contentInset.right > self.collectionView.frame.size.width) {
            _offsetRow += 1;
            _offsetY = _offsetY + size.height + self.lineSpacing;
            offsetX = self.contentInset.left;
        }
        
        attributes.frame = CGRectMake(offsetX, _offsetY, size.width, size.height);
        offsetX = offsetX + size.width + self.interitemSpacing;
        _offsetX = offsetX;
//    } else if (_type == LayoutSectionIconType){
//        CGSize size = [self itemSizeAtIndexPath:indexPath];
//        CGFloat offsetX = _offsetX;// 上次偏移量
//        
//        if (offsetX +size.width + self.contentInset.right > self.collectionView.frame.size.width) {
//            _offsetRow += 1;
//            _offsetY = _offsetY + size.height + self.lineSpacing;
//            offsetX = self.contentInset.left;
//        }
//        
//        attributes.frame = CGRectMake(offsetX, _offsetY, size.width, size.height);
//        offsetX = offsetX + size.width + self.interitemSpacing;
//        _offsetX = offsetX;
//    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if (![elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return nil;
    }
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];

    CGSize size = [self headerViewSizeAtIndexPath:indexPath];
    
    CGFloat offsetY = _offsetY+_lastItemHeight+self.lineSpacing;// 上次偏移量
    if (_lastItemHeight == 0) {
        offsetY = _offsetY+_lastItemHeight;// 上次偏移量
    }
    
    
    attributes.frame = CGRectMake(0, offsetY, size.width, size.height);
    offsetY += size.height+self.lineSpacing;
    _offsetY = offsetY;
    _offsetX = self.contentInset.left;
    return attributes;
}

-(CGSize)itemSizeAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(masterChoiseLayout:itemSizeForIndexPath:)]) {
        return [self.delegate masterChoiseLayout:self itemSizeForIndexPath:indexPath];
    }
    return self.itemSize;
}

-(CGSize)headerViewSizeAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(masterChoiseLayout:headerViewSizeForSection:)]) {
        return [self.delegate masterChoiseLayout:self headerViewSizeForSection:indexPath.section];
    }
    return CGSizeZero;
}

//-(LayoutSectionType)sectionTypeAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(masterChoiseLayout:sectionTypeForSection:)]) {
//        return [self.delegate masterChoiseLayout:self sectionTypeForSection:indexPath.section];
//    }
//    return LayoutSectionTextType;
//}

#pragma mark - set method
- (void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    [self invalidateLayout];
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing{
    _interitemSpacing = interitemSpacing;
    [self invalidateLayout];
}

- (void)setLineSpacing:(CGFloat)lineSpacing{
    _lineSpacing = lineSpacing;
    [self invalidateLayout];
}

@end
