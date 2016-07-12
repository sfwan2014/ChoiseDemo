//
//  MasterChoiseSecondViewController.m
//  ChoiseDemo
//
//  Created by DBC on 16/7/12.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "MasterChoiseSecondViewController.h"
#import "MasterChoiseSecondCollectionView.h"
#import "MasterChoiseItem.h"

@interface MasterChoiseSecondViewController ()
@property (weak, nonatomic) IBOutlet MasterChoiseSecondCollectionView *collectionView;

@end

@implementation MasterChoiseSecondViewController{
    NSMutableArray *_group;
}


#pragma mark - - getter

-(NSMutableArray *)group{
    
    
    NSArray *hots = @[@"苹果", @"桃子", @"西红柿", @"新疆雪梨", @"红枣", @"西域哈密瓜", @"山东富士苹果", @"青芒"];
    NSArray *categerys = @[@"蔬菜",@"水果",@"食用菌",@"茶",@"坚果干果",@"中药材",@"水产",@"禽畜牧蛋肉",@"特殊养殖",@"其他"];
    if (_group == nil) {
        _group = [NSMutableArray array];
        // 热门推荐
        NSMutableArray *hotArray = [NSMutableArray array];
        for (int i = 0; i < hots.count; i++) {
            MasterChoiseItem *item = [[MasterChoiseItem alloc] init];
            item.name = hots[i];
            item.type = 2;
            item.categery = @"热门";
            item.id = [NSString stringWithFormat:@"%100d", i];
            [hotArray addObject:item];
        }
        
        [_group addObject:hotArray];
        // 按类型选择
        NSMutableArray *categoryArray = [NSMutableArray array];
        for (int i = 0; i < categerys.count; i++) {
            MasterChoiseItem *item = [[MasterChoiseItem alloc] init];
            item.name = categerys[i];
            item.type = 2;
            item.categery = @"其他水果";
            item.id = [NSString stringWithFormat:@"%200d", i];
            [categoryArray addObject:item];
        }
        
        [_group addObject:categoryArray];
        
    }
    
    return _group;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.collectionView.dataArray = self.group;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
