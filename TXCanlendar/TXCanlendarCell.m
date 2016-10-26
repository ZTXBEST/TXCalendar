//
//  TXCanlendarCell.m
//  TXCanlendar
//
//  Created by 赵天旭 on 16/10/26.
//  Copyright © 2016年 ZTX. All rights reserved.
//

#import "TXCanlendarCell.h"

@implementation TXCanlendarCell
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

@end
