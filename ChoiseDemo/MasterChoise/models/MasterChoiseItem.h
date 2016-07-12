//
//  MasterChoiseItem.h
//  DaBaiCai
//
//  Created by DBC on 16/7/12.
//  Copyright © 2016年 大白菜. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface MasterChoiseItem : NSObject

@property (nonatomic, strong) NSString *name; // 名称
@property (nonatomic, strong) NSString *icon; // 图标
@property (nonatomic, assign) NSInteger type; // 类型 0 为大品种, 1 为二级, 2为三级, 3为四级
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) id specifications; // 规格
@property (nonatomic, strong) NSString *categery; // 类别

@end
