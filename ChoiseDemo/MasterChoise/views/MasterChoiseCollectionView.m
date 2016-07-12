//
//  MasterChoiseCollectionView.m
//  ChoiseDemo
//
//  Created by DBC on 16/7/12.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "MasterChoiseCollectionView.h"
#import "MasterChoiseCollectionViewCell.h"
#import "MasterChoiseLayout.h"
#import "MasterChoiseIconCollectionViewCell.h"
#import "MasterChoiseItem.h"
#import "MasterChoiseSecondViewController.h"
#import "MasterChoiseThirdViewController.h"


static const NSInteger kRowCount = 4;
@interface MasterChoiseCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, MasterChoiseLayoutDelegate>

@end

@implementation MasterChoiseCollectionView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    self.pagingEnabled = NO;
    self.directionalLockEnabled = YES;
    
    UINib *nib = [UINib nibWithNibName:@"MasterChoiseCollectionViewCell" bundle:nil];
    [self registerNib:nib forCellWithReuseIdentifier:@"MasterChoiseCollectionViewCell"];
    
    nib = [UINib nibWithNibName:@"MasterChoiseIconCollectionViewCell" bundle:nil];
    [self registerNib:nib forCellWithReuseIdentifier:@"MasterChoiseIconCollectionViewCell"];
    
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = self.dataArray[indexPath.section];
    MasterChoiseItem *item = array[indexPath.item];
    
    if (item.type != 0) {
        MasterChoiseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MasterChoiseCollectionViewCell" forIndexPath:indexPath];
        
        cell.textLabel.text = item.name;
        
        return cell;
    }
    
    
    MasterChoiseIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MasterChoiseIconCollectionViewCell" forIndexPath:indexPath];
    cell.iconView.image = [UIImage imageNamed:@"home_search"];
    cell.textLabel.text = item.name;
    
    return cell;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        NSArray *array = self.dataArray[indexPath.section];
        MasterChoiseItem *item = array[indexPath.item];
        
        UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        view.backgroundColor = [UIColor colorWithString:@"#F1F1F1"];
        
        UILabel *label = (UILabel *)[view viewWithTag:1000];
        if (label == nil) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, collectionView.frame.size.width-10, view.frame.size.height)];
            label.textColor = [UIColor colorWithString:@"#666666"];
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            [view addSubview:label];
            label.tag = 1000;
        }
        
        label.text = item.categery;
        
        return view;
    }
    return nil;
}

#pragma mark - - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.dataArray[indexPath.section];
    MasterChoiseItem *item = array[indexPath.item];
    if (item.type == 0) {
        MasterChoiseSecondViewController *secondVc = [[MasterChoiseSecondViewController alloc] init];
        [self.viewController.navigationController pushViewController:secondVc animated:YES];
        secondVc.title = item.name;
    } else if (item.type == 2) {
        MasterChoiseThirdViewController *thirdVc = [[MasterChoiseThirdViewController alloc] init];
        [self.viewController.navigationController pushViewController:thirdVc animated:YES];
        thirdVc.title = item.name;
    }
    NSLog(@"%@", item.name);
}

-(CGSize)masterChoiseLayout:(MasterChoiseLayout *)layout itemSizeForIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = self.dataArray[indexPath.section];
    MasterChoiseItem *item = array[indexPath.item];
    if (item.type != 0) {
        NSString *text = item.name;
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        CGFloat space = 12;// 左右间距
        CGFloat lineSpace = 10; // 上下间距
        size = CGSizeMake(size.width+space*2, size.height+lineSpace*2);
        return size;
    }
    CGFloat space = 10;
    return CGSizeMake((self.frame.size.width -4*space)/3.0-1, 80);
}

-(CGSize)masterChoiseLayout:(MasterChoiseLayout *)layout headerViewSizeForSection:(NSInteger)section{
    return CGSizeMake(layout.collectionView.frame.size.width, 35);
}


#pragma mark -- override
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
