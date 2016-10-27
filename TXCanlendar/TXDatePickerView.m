//
//  TXDatePickerView.m
//  TXCanlendar
//
//  Created by 赵天旭 on 16/10/26.
//  Copyright © 2016年 ZTX. All rights reserved.
//

#import "TXDatePickerView.h"

@interface TXDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic, strong)UIPickerView *pickerView;
@property(nonatomic, assign)NSInteger currentYear;
@property(nonatomic,assign) NSInteger yearRange;
@end

@implementation TXDatePickerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildPickerView];
    }
    return self;
}

- (void)buildPickerView {
    _yearRange=20;
    _pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
    [self addSubview:_pickerView];
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.delegate=self;
    _pickerView.dataSource = self;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* com=[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
    self.currentYear = com.year;
    [_pickerView selectRow:_yearRange inComponent:0 animated:NO];
    [_pickerView selectRow:com.month-1 inComponent:1 animated:NO];
}

-(NSString*)selectdDateStr{
    NSInteger year=2015-_yearRange+[_pickerView selectedRowInComponent:0];
    NSInteger month=[_pickerView selectedRowInComponent:1]+1;
    return [NSString stringWithFormat:@"%ld年%ld月",(long)year,(long)month];
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 41;
    }
    
    return 12;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if(component==0){
        return pickerView.frame.size.width/2.0f;
    }
    else{
        return pickerView.frame.size.width/3.0f;
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        row=2015-_yearRange+row;
        return  [NSString stringWithFormat:@"%ld年",(long)row];
    } else {
        return  [NSString stringWithFormat:@"%ld月",(long)row+1];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
