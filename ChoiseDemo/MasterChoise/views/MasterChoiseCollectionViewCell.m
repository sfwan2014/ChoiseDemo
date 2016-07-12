//
//  MasterChoiseCollectionViewCell.m
//  ChoiseDemo
//
//  Created by DBC on 16/7/12.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "MasterChoiseCollectionViewCell.h"

@implementation MasterChoiseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithString:@"#dddddd"].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5.0;
}

@end

