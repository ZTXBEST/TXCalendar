//
//  TXCanlendarScrollView.h
//  TXCanlendar
//
//  Created by 赵天旭 on 16/10/26.
//  Copyright © 2016年 ZTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXCanlendarScrollView : UIView

@property (nonatomic , strong) NSDate *date;
@property (nonatomic , strong) NSDate *today;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

@end
