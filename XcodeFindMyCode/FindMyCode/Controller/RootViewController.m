//
//  RootViewController.m
//  FindMyCodeDemo
//
//  Created by 张小刚 on 16/3/5.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Root";
}

- (IBAction)detailButtonPressed:(id)sender {
    DetailViewController * detaiVC = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detaiVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
