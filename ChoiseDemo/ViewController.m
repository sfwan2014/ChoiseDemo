//
//  ViewController.m
//  ChoiseDemo
//
//  Created by DBC on 16/7/11.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "ViewController.h"
#import "MasterChoiseViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gotoaction:(id)sender {
    MasterChoiseViewController *masterChiose = [[MasterChoiseViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:masterChiose];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
