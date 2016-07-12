//
//  MasterChoiseViewController.m
//  ChoiseDemo
//
//  Created by DBC on 16/7/11.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "MasterChoiseViewController.h"
#import "MasterChoiseSearchTableView.h"
#import "MasterChoiseCollectionView.h"
#import "MasterChoiseItem.h"

@interface MasterChoiseViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchBar;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightCons;
@property (weak, nonatomic) IBOutlet MasterChoiseCollectionView *collectionView;
@property (strong, nonatomic) MasterChoiseSearchTableView *searchTableView;

@end

@implementation MasterChoiseViewController{
    NSString *_keywords;
    NSMutableArray *_group;
}

#pragma mark -- getter
-(MasterChoiseSearchTableView *)searchTableView{
    if (_searchTableView == nil) {
        CGFloat searchHeight = 55;
        CGFloat navTop = 64;
        
        _searchTableView = [[MasterChoiseSearchTableView alloc] initWithFrame:CGRectMake(0, searchHeight+navTop, kScreenWidth, kScreenHeight - searchHeight-navTop) style:UITableViewStylePlain];
        [self.view addSubview:_searchTableView];
        _searchTableView.hidden = YES;
    }
    
    return _searchTableView;
}

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
            item.categery = @"热门推荐";
            item.id = [NSString stringWithFormat:@"%100d", i];
            [hotArray addObject:item];
        }
        
        [_group addObject:hotArray];
        // 按类型选择
        NSMutableArray *categoryArray = [NSMutableArray array];
        for (int i = 0; i < categerys.count; i++) {
            MasterChoiseItem *item = [[MasterChoiseItem alloc] init];
            item.name = categerys[i];
            item.type = 0;
            item.categery = @"按类型选择";
            item.id = [NSString stringWithFormat:@"%200d", i];
            [categoryArray addObject:item];
        }
        
        [_group addObject:categoryArray];
        
    }
    
    return _group;
}

-(void)addHistory{
    // 历史搜索记录
    NSArray *history = @[@"苹果", @"桃子", @"西红柿", @"新疆雪梨", @"红枣", @"西域哈密瓜", @"山东富士苹果", @"青芒"];
    NSMutableArray *historyArray = [NSMutableArray array];
    for (int i = 0; i < history.count; i++) {
        MasterChoiseItem *item = [[MasterChoiseItem alloc] init];
        item.name = history[i];
        item.type = 3;
        item.categery = @"搜索历史";
        item.id = [NSString stringWithFormat:@"%100d", i];
        [historyArray addObject:item];
    }
    
    [self.group insertObject:historyArray atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"选择品种";
    
    [self _initViews];
    
    self.collectionView.dataArray = self.group;
    [self.collectionView reloadData];
    
    [self addHistory];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self _addNotification];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private method
-(void)_initViews{
    _searchBar.layer.masksToBounds = YES;
    _searchBar.layer.cornerRadius = 6.0;
    _searchBar.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
    _searchBar.layer.borderWidth = 0.5;
    
    _lineHeightCons.constant = 0.5;
}

-(void)_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - notification
-(void)textFieldDidChange:(NSNotification *)notification{
    if ([_keywords isEqualToString:_searchTextField.text]) {
        return;
    }
    if (_searchTextField.text.length == 0) {
        self.searchTableView.hidden = YES;
    } else {
        self.searchTableView.hidden = NO;
    }
    
    NSLog(@"%@", _searchTextField.text);
}

#pragma mark - delegate 




#pragma mark-  override

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
