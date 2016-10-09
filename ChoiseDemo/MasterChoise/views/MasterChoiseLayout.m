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
    CGFloat _lastFooterHeight;
    CGFloat _lastHeaderHeight;
    LayoutSectionType _type; // 单元格类型
}

- (void)prepareLayout{
    [super prepareLayout];
    
    _offsetRow = 0;
    _offsetX = self.contentInset.left;
    _offsetY = 0;
    _lastItemHeight = 0;
    _lastHeaderHeight = 0;
    _lastFooterHeight = 0;
    
    NSMutableArray *layoutInfoArr = [NSMutableArray array];
    NSInteger maxNumberOfItems = 0;
    //获取布局信息
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < numberOfSections; section++){
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *subArr = [NSMutableArray arrayWithCapacity:numberOfItems];
        for (NSInteger item = 0; item < numberOfItems; item++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            if (item == 0) {// 头视图
                CGSize size = [self headerViewSizeAtIndexPath:indexPath];
                if (size.height > 0) {
                    UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                    if (headerAttributes != nil) {
                        [subArr addObject:headerAttributes];
                    }
                }
            }
            
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [subArr addObject:attributes];
            
            if (item == numberOfItems - 1) { // 尾部视图
                CGSize size = [self footerViewSizeAtIndexPath:indexPath];
                if (size.height > 0) {
                    UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
                    if (footerAttributes != nil) {
                        [subArr addObject:footerAttributes];
                    }
                }
                
            }
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
    CGSize size = CGSizeMake(self.collectionView.frame.size.width, _offsetY+_lastItemHeight + _lastFooterHeight + _lastHeaderHeight+self.contentInset.bottom+self.lineSpacing);
    self.contentSize = size;
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

    CGSize size = [self itemSizeAtIndexPath:indexPath];
    CGFloat lineSpacing = [self lineSpacing:indexPath.section];
    CGFloat interitemSpacing = [self interitemSpacing:indexPath.section];
    UIEdgeInsets contentInset = [self contentInset:indexPath.section];
    if (_offsetY == 0) {
        _offsetY = contentInset.top;
    }
    CGFloat offsetX = _offsetX;// 上次偏移量
    CGFloat offsetY = _offsetY;
    if (_lastHeaderHeight > 0) {
//        offsetY += _lastHeaderHeight;
        offsetX = contentInset.left;
    }
    if (_lastFooterHeight > 0) {
//        offsetY += _lastFooterHeight;
        offsetX = contentInset.left;
    }
    
    _lastFooterHeight = 0;
    _lastHeaderHeight = 0;
    
    // 内容溢出
    CGFloat tmpX = offsetX + size.width + interitemSpacing + self.contentInset.right;
    if (tmpX > self.collectionView.frame.size.width + 10) {
        _offsetRow += 1;
        offsetY = offsetY + _lastItemHeight + lineSpacing;
        offsetX = contentInset.left;
    }
    
    attributes.frame = CGRectMake(offsetX, offsetY, size.width, size.height);
    offsetX = offsetX + size.width + interitemSpacing;
    
    _lastItemHeight = size.height;
    _offsetX = offsetX;
    _offsetY = offsetY;
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if (!([elementKind isEqualToString:UICollectionElementKindSectionHeader] || [elementKind isEqualToString:UICollectionElementKindSectionFooter])) {
        return nil;
    }
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];

    UIEdgeInsets contentInset = [self contentInset:indexPath.section];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGSize size = [self headerViewSizeAtIndexPath:indexPath];
        _lastHeaderHeight = size.height;
        if (size.height == 0) {
            return attributes;
        }
        CGFloat offsetY = _offsetY;// 上次偏移量
        if (_lastItemHeight > 0) {
            BOOL hadFooter = [self lastSectionHadFooter:indexPath];
            if (hadFooter) {
                offsetY = _offsetY;// 上次偏移量
            } else {
                offsetY = _offsetY + _lastItemHeight + contentInset.top;// 上次偏移量
            }
        }
        
        attributes.frame = CGRectMake(0, offsetY, size.width, size.height);
        offsetY += size.height+contentInset.top;
        _offsetY = offsetY;
        _offsetX = contentInset.left;
        return attributes;
    } else {
        CGSize size = [self footerViewSizeAtIndexPath:indexPath];
        _lastFooterHeight = size.height;
        if (size.height == 0) {
            return attributes;
        }
        CGFloat offsetY = _offsetY+contentInset.bottom + _lastItemHeight;// 上次偏移量
        attributes.frame = CGRectMake(0, offsetY, size.width, size.height);
        offsetY += size.height+contentInset.bottom;
        _offsetY = offsetY;
        _offsetX = contentInset.left;
        return attributes;
    }
    
}

-(BOOL)lastSectionHadFooter:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 0) {
        return NO;
    }
    
    NSIndexPath *lastSectionIndex = [NSIndexPath indexPathForItem:indexPath.item inSection:section-1];
    CGSize size = [self footerViewSizeAtIndexPath:lastSectionIndex];
    if (size.height <= 0) {
        return NO;
    }
    return YES;
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

-(CGSize)footerViewSizeAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(masterChoiseLayout:footerViewSizeForSection:)]) {
        return [self.delegate masterChoiseLayout:self footerViewSizeForSection:indexPath.section];
    }
    return CGSizeZero;
}

-(CGFloat)lineSpacing:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(masterChoiseLayout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate masterChoiseLayout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return self.lineSpacing;
}

-(CGFloat)interitemSpacing:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(masterChoiseLayout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate masterChoiseLayout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return self.interitemSpacing;
}

-(UIEdgeInsets)contentInset:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(masterChoiseLayout:insetForSectionAtIndex:)]) {
        return [self.delegate masterChoiseLayout:self insetForSectionAtIndex:section];
    }
    return self.contentInset;
}

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

- (CGSize)caculateContentSize{
    _offsetRow = 0;
    _offsetX = self.contentInset.left;
    _offsetY = 0;
    _lastItemHeight = 0;
    _lastHeaderHeight = 0;
    _lastFooterHeight = 0;
    
    //获取布局信息
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < numberOfSections; section++){
        NSInteger numberOfItems = [self numberOfItemsInSection:section];
        NSMutableArray *subArr = [NSMutableArray arrayWithCapacity:numberOfItems];
        for (NSInteger item = 0; item < numberOfItems; item++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            if (item == 0) {// 头视图
                CGSize size = [self headerViewSizeAtIndexPath:indexPath];
                if (size.height > 0) {
                    UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                    if (headerAttributes != nil) {
                        [subArr addObject:headerAttributes];
                    }
                }
            }
            
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [subArr addObject:attributes];
            
            if (item == numberOfItems - 1) { // 尾部视图
                CGSize size = [self footerViewSizeAtIndexPath:indexPath];
                if (size.height > 0) {
                    UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
                    if (footerAttributes != nil) {
                        [subArr addObject:footerAttributes];
                    }
                }
                
            }
        }
    }
    
    //保存内容尺寸
    CGSize size = CGSizeMake(self.collectionView.frame.size.width, _offsetY+_lastItemHeight + _lastFooterHeight + _lastHeaderHeight+self.contentInset.bottom+self.lineSpacing);
    
    _offsetRow = 0;
    _offsetX = self.contentInset.left;
    _offsetY = 0;
    _lastItemHeight = 0;
    _lastHeaderHeight = 0;
    _lastFooterHeight = 0;
    
    return size;
}

-(NSUInteger)numberOfItemsInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(masterChoiseLayout:numberOfItemsInSection:)]) {
        return [self.delegate masterChoiseLayout:self numberOfItemsInSection:section];
    }
    return 0;
}

@end
