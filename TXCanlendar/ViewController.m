//
//  ViewController.m
//  TXCanlendar
//
//  Created by 赵天旭 on 16/10/25.
//  Copyright © 2016年 ZTX. All rights reserved.
//

#import "ViewController.h"
#import "TXCanlendarScrollView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TXCanlendarScrollView *view = [[TXCanlendarScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 350)];
    view.today = [NSDate date];
    view.date = view.today;
    [self.view addSubview:view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
