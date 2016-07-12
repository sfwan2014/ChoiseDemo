//
//  MasterChoiseThirdCollectionView.m
//  DaBaiCai
//
//  Created by DBC on 16/7/12.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import "MasterChoiseThirdCollectionView.h"
#import "MasterChoiseCollectionViewCell.h"
#import "MasterChoiseLayout.h"
#import "MasterChoiseItem.h"


static const NSInteger kRowCount = 4;

@interface MasterChoiseThirdCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, MasterChoiseLayoutDelegate>

@end
@implementation MasterChoiseThirdCollectionView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    self.pagingEnabled = NO;
    self.directionalLockEnabled = YES;
    
    UINib *nib = [UINib nibWithNibName:@"MasterChoiseCollectionViewCell" bundle:nil];
    [self registerNib:nib forCellWithReuseIdentifier:@"MasterChoiseCollectionViewCell"];
    
    CGFloat spacing = 10;
    CGFloat mainScrreenWidth = [UIScreen mainScreen].bounds.size.width;
    MasterChoiseLayout *layout = [[MasterChoiseLayout alloc] init];
    layout.itemSize = CGSizeMake((mainScrreenWidth-(kRowCount+1)*spacing)/kRowCount, 150);
    layout.interitemSpacing = spacing;
    layout.lineSpacing = spacing;
    layout.delegate = self;
    layout.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.collectionViewLayout = layout;
}


#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = self.dataArray;
    return array.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = self.dataArray;
    MasterChoiseItem *item = array[indexPath.item];
    
    MasterChoiseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MasterChoiseCollectionViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

#pragma mark - - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.dataArray;
    MasterChoiseItem *item = array[indexPath.item];
    
    NSLog(@"%@", item.name);
}

-(CGSize)masterChoiseLayout:(MasterChoiseLayout *)layout itemSizeForIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = self.dataArray;
    MasterChoiseItem *item = array[indexPath.item];
    NSString *text = item.name;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGFloat space = 12;// 左右间距
    CGFloat lineSpace = 10; // 上下间距
    size = CGSizeMake(size.width+space*2, size.height+lineSpace*2);
    return size;
}

@end
