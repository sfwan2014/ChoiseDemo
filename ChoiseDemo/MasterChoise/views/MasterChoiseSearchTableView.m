//
//  MasterChoiseSearchTableView.m
//  ChoiseDemo
//
//  Created by DBC on 16/7/11.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "MasterChoiseSearchTableView.h"

@interface MasterChoiseSearchTableView ()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation MasterChoiseSearchTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchTableViewCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

@end
