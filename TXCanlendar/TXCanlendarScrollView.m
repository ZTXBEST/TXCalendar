//
//  TXCanlendarScrollView.m
//  TXCanlendar
//
//  Created by 赵天旭 on 16/10/26.
//  Copyright © 2016年 ZTX. All rights reserved.
//

#import "TXCanlendarScrollView.h"
#import "TXCanlendarCell.h"
#import "TXDatePickerView.h"

#define RGBA(r,g,b,a)   [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define TotalNumber 2000
NSString *const TXCalendarCellIdentifier = @"TXCalendarCellIdentifier";


@interface TXCanlendarScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UIView *titleView;
@property(nonatomic, strong)UILabel *dateLabel;
@property(nonatomic, strong)UIButton *dateButton;
@property(nonatomic, strong)UIButton *lastMonthButton;
@property(nonatomic, strong)UIButton *nextMonthButton;
@property(nonatomic, strong)UIButton *lastYearButton;
@property(nonatomic, strong)UIButton *nextYearButton;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, strong)NSArray *weekDayArray;
@property(nonatomic, strong)TXDatePickerView *pickerView;
@end

@implementation TXCanlendarScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self buildTitleView];
        [self buildCanlerdarView];
        [self configGesture];
    }
    return self;
}

- (void)configGesture {
    [self addSwip];
}

- (void)buildTitleView {
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    _titleView.backgroundColor = RGBA(32, 196, 138, 1);
    [self addSubview:_titleView];
    
    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dateButton.center = _titleView.center;
    _dateButton.bounds = CGRectMake(0, 0, 100, 44);
    [_dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_dateButton addTarget:self action:@selector(dateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_dateButton];
    
    _lastYearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastYearButton.center = CGPointMake(18, _titleView.center.y);
    _lastYearButton.bounds = CGRectMake(0, 0, 25, 25);
//    [_lastYearButton setBackgroundImage:[UIImage imageNamed:@"bt_previous"] forState:UIControlStateNormal];
    [_lastYearButton setTitle:@"<<" forState:UIControlStateNormal];
    [_lastYearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_lastYearButton addTarget:self action:@selector(lastYearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_lastYearButton];
    
    _lastMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastMonthButton.center = CGPointMake(38, _titleView.center.y);
    _lastMonthButton.bounds = CGRectMake(0, 0, 16, 16);
    [_lastMonthButton setBackgroundImage:[UIImage imageNamed:@"bt_previous"] forState:UIControlStateNormal];
    [_lastMonthButton addTarget:self action:@selector(lastMonthAction:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_lastMonthButton];
    
    _nextYearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextYearButton.center = CGPointMake(_titleView.frame.size.width-18, _titleView.center.y);
    _nextYearButton.bounds = CGRectMake(0, 0, 25, 25);
//    [_nextYearButton setBackgroundImage:[UIImage imageNamed:@"bt_next@2x"] forState:UIControlStateNormal];
    [_nextYearButton setTitle:@">>" forState:UIControlStateNormal];
    [_nextYearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nextYearButton addTarget:self action:@selector(nextYearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_nextYearButton];
    
    _nextMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextMonthButton.center = CGPointMake(_titleView.frame.size.width-38, _titleView.center.y);
    _nextMonthButton.bounds = CGRectMake(0, 0, 16, 16);
    [_nextMonthButton setBackgroundImage:[UIImage imageNamed:@"bt_next@2x"] forState:UIControlStateNormal];
    [_nextMonthButton addTarget:self action:@selector(nextMonthAction:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_nextMonthButton];
}

- (void)buildCanlerdarView {
    CGFloat itemWidth = self.frame.size.width / 7;
    CGFloat itemHeight = (self.frame.size.height-44) / 7;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_collectionView];
    [self configData];
    
    _pickerView = [[TXDatePickerView alloc] initWithFrame:CGRectMake(0, 44,self.frame.size.width, self.frame.size.height-44*2)];
    _pickerView.hidden = YES;
    [self addSubview:_pickerView];
}

#pragma mark - 加载数据
- (void)configData{
    [_collectionView registerClass:[TXCanlendarCell class] forCellWithReuseIdentifier:TXCalendarCellIdentifier];
    _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}

- (void)setDate:(NSDate *)date {
    _date = date;
//    [_dateLabel setText:[NSString stringWithFormat:@"%.2li-%ld",(long)[self year:date],(long)[self month:date]]];
    [_dateButton setTitle:[NSString stringWithFormat:@"%.2li-%ld",(long)[self year:date],(long)[self month:date]] forState:UIControlStateNormal];
    [_collectionView reloadData];
}

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


/**
    当前月份第一天是周几
*/
- (NSInteger)firstWeekDayInThisMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

/**
    当前月份的总天数
*/
- (NSInteger)totaldaysInThisMonth:(NSDate *)date {
//    NSRange totaldaysInThisMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
//    return totaldaysInThisMonth.length;
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}
/**
    上个月
*/
- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

/**
    下个月
*/
- (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
/**
    上一年
 */
- (NSDate *)lastYear:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
/**
    下一年
 */
- (NSDate*)nextYear:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma mark - 手势
- (void)addSwip {
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipLeft:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipRight:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
    
//    UISwipeGestureRecognizer *swipUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipUp:)];
//    swipUp.direction = UISwipeGestureRecognizerDirectionUp;
//    [self addGestureRecognizer:swipUp];
//    
//    UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipDown:)];
//    swipDown.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self addGestureRecognizer:swipDown];
}

- (void)swipLeft:(UISwipeGestureRecognizer *)swip {
    [self nextMonthAction:nil];
}

- (void)swipRight:(UISwipeGestureRecognizer *)swip {
    [self lastMonthAction:nil];
}

//- (void)swipUp:(UISwipeGestureRecognizer *)swip {
//    [self lastYearButtonAction:nil];
//}
//
//- (void)swipDown:(UISwipeGestureRecognizer *)swip {
//    [self nextYearButtonAction:nil];
//}

#pragma mark - Action
/**
    翻转动画，选择年月
 */
- (void)dateButtonAction:(UIButton *)button {
    [self showPickerView];
}

- (void)lastYearButtonAction:(UIButton *)button {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:^(void) {
        self.date = [self lastYear:self.date];
    } completion:nil];
}

- (void)nextYearButtonAction:(UIButton *)button {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^(void) {
        self.date = [self nextYear:self.date];
    } completion:nil];
}

- (void)lastMonthAction:(UIButton *)button {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [self lastMonth:self.date];
    } completion:nil];
}

- (void)nextMonthAction:(UIButton *)button {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [self nextMonth:self.date];
    } completion:nil];
}

#pragma mark - ShowPickerView
- (void)showPickerView {
    _pickerView.hidden = NO;
    _lastYearButton.hidden = YES;
    _lastMonthButton.hidden = YES;
    _nextYearButton.hidden = YES;
    _nextMonthButton.hidden = YES;
    [_dateButton setTitle:@"请选择年月" forState:UIControlStateNormal];
    
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = -1.0/500.0;
    trans = CATransform3DTranslate(trans, 0, 45, 0);
    trans=CATransform3DRotate(trans, -M_PI/2.8, 1, 0,0);
    trans = CATransform3DScale(trans, 0.8, 0.8, 0.8);
    _collectionView.layer.transform = trans;
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    basicAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    basicAnimation.toValue = [NSValue valueWithCATransform3D:trans];
    basicAnimation.duration = 0.3f;
    basicAnimation.cumulative = NO;
    basicAnimation.repeatCount = 0;
    [_collectionView.layer addAnimation:basicAnimation forKey:nil];
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        return 42;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXCanlendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TXCalendarCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.dateLabel.text = _weekDayArray[indexPath.row];
        cell.dateLabel.textColor =RGBA(32, 196, 138, 1);
    }else {
        NSInteger daysInThisMonth = [self totaldaysInThisMonth:_date];
        NSInteger firstWeekDay = [self firstWeekDayInThisMonth:_date];
        NSInteger day = 0;
        if (indexPath.row < firstWeekDay) {
            cell.dateLabel.text = @"";
        }
        else if (indexPath.row >firstWeekDay+daysInThisMonth-1) {
            cell.dateLabel.text = @"";
        }
        else {
            day = indexPath.row - firstWeekDay + 1;
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)day];
            cell.dateLabel.textColor = RGBA(111, 111, 111, 1);
            
            //this month
            if ([_today isEqualToDate:_date]) {
                if (day == [self day:_date]) {
                    cell.dateLabel.textColor = [UIColor redColor];
                } else if (day > [self day:_date]) {
                    [cell.dateLabel setTextColor:[UIColor grayColor]];
                }
            } else if ([_today compare:_date] == NSOrderedAscending) {
                [cell.dateLabel setTextColor:[UIColor grayColor]];
            }
        }
    }
    
    return cell;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
