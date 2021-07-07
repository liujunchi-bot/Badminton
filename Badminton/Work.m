//
//  Work.m
//  Badminton
//
//  Created by calmliu on 2021/7/4.
//

#import "Work.h"

@implementation Work
@synthesize incomeResultList;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.incomeResultList = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}

- (void)bookOrcancel:(NSString *)operation {
    NSString *userID,*place;
    int year,month,day,start,end;
    //用于处理输入的正则表达式
    NSString *bookPattern = @"(U)(\\d{3})(\\s)(\\d{4})(-)(\\d{2})(-)(\\d{2})(\\s)(\\d{2})(:)(00)(~)(\\d{2})(:)(00)(\\s)([A-D])";
    NSString *cancelPattern = @"(U)(\\d{3})(\\s)(\\d{4})(-)(\\d{2})(-)(\\d{2})(\\s)(\\d{2})(:)(00)(~)(\\d{2})(:)(00)(\\s)([A-D])(\\s)([C])";
    NSPredicate *bookPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bookPattern];
    NSPredicate *cancelPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cancelPattern];
    //谓词来判断匹配结果
    BOOL isBook = [bookPredicate evaluateWithObject:operation];
    BOOL isCancel = [cancelPredicate evaluateWithObject:operation];
    if(isBook) {
        //手动提取操作信息
        userID = [operation substringWithRange:NSMakeRange(0, 4)];
        year = [[operation substringWithRange:NSMakeRange(5,4 )] intValue];
        month = [[operation substringWithRange:NSMakeRange(10, 2)] intValue];
        day = [[operation substringWithRange:NSMakeRange(13, 2)] intValue];
        start = [[operation substringWithRange:NSMakeRange(16, 2)] intValue];
        end = [[operation substringWithRange:NSMakeRange(22, 2)] intValue];
        place = [operation substringWithRange:NSMakeRange(28, 1)];
        if (start == end || start < minStart || end > maxStart) {
            [self printValidOptionError];
        }else{
        User *user = [[User alloc] initWithuser:userID andYear:year andMonth:month andDay:day andStart:start andEnd:end andPlace:place andIsCancel:0];
            [self book:user];
        }
    }
    else if(isCancel) {
        userID = [operation substringWithRange:NSMakeRange(0, 4)];
        year = [[operation substringWithRange:NSMakeRange(5,4 )] intValue];
        month = [[operation substringWithRange:NSMakeRange(10, 2)] intValue];
        day = [[operation substringWithRange:NSMakeRange(13, 2)] intValue];
        start = [[operation substringWithRange:NSMakeRange(16, 2)] intValue];
        end = [[operation substringWithRange:NSMakeRange(22, 2)] intValue];
        place = [operation substringWithRange:NSMakeRange(28, 1)];
        User *user = [[User alloc] initWithuser:userID andYear:year andMonth:month andDay:day andStart:start andEnd:end andPlace:place andIsCancel:0];
        [self cancel:user];
    }else {
        if(operation.length != 0)
        [self printValidOptionError];
    }
}

- (void)cancel:(User *)user {
    BOOL flag = false;
    for(User *u in self.incomeResultList) {
        if([user isEqualToUser:u]) {
            [self.incomeResultList removeObject:u];   //移除预定信息
            user.isCancel = 1;
            [self.incomeResultList addObject:user];   //加入取消信息
            [self printBookingSuccess];
            flag = YES;
            break;
        }
    }
    if(!flag) {
        [self printCancelError];
    }
    
}

- (void)book:(User *)user {
    for(User *u in self.incomeResultList) {
        if([u isTimeError:user] && u.isCancel == 0) {
            [self printConfictError];
            return;
        }
    }
    [self.incomeResultList addObject:user];
    [self printBookingSuccess];
}

- (void)printCancelError {
    NSLog(@"Error: the booking being cancelled does not exist!");
}

- (void)printBookingSuccess {
    NSLog(@"Success: the booking is accepted!");
}

- (void)printConfictError {
    NSLog(@"Error: the booking conflicts with existing bookings!");
}

- (void)printValidOptionError {
    NSLog(@"Error: the booking is invalid!");
}

- (int)getWeek:(User *)user {
    NSArray *week = [[NSArray alloc] initWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天",nil];
    NSDate *date = nil;
    NSString *myDate = [[NSString alloc] initWithFormat:@"%i-%i-%i",user.year,user.month,user.day];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    date = [format dateFromString:myDate];
    [format setDateFormat:@"EEEE"];       //星期格式
    NSString *myweek = [format stringFromDate:date];
    for(int i = 0;i < [week count];i++){
        if([myweek isEqualToString:[week objectAtIndex:i]]) {
            return i+1;
        }
    }
    return 0;
}

- (int)calCancelIncome:(User *)user {
    int week = [self getWeek:user];
    int price = [self getPriceforOption:user];
    if(week <= 5) {
        return price*0.5;
    }else {
        return price*0.25;
    }
}

- (int)getPriceforOption:(User *)user {
    NSArray *workDayPrice = @[@30,@50,@80,@60];
    NSArray *weekendayPrice = @[@40,@50,@60];
    int weekIndex = [self getWeek:user];
    int price = 0;
    if(weekIndex <= 5) {     //周内时间的消费计算
        if(user.start >= 9 && user.start <= 12) {
            if(user.end >= 9 && user.end <= 12) {
                price = (user.end - user.start)*[[workDayPrice objectAtIndex:0] intValue];
            }else if(user.end >= 12 && user.end <= 18) {
                price = (12 - user.start)*[[workDayPrice objectAtIndex:0] intValue] + (user.end - 12)*[[workDayPrice objectAtIndex:1] intValue];
            }else if(user.end >=18 && user.end <= 20) {
                price = (12 - user.start)*[[workDayPrice objectAtIndex:0] intValue] + (18 - 12)*[[workDayPrice objectAtIndex:1] intValue] + (user.end - 18)*[[workDayPrice objectAtIndex:2] intValue];
            }else if(user.end >= 20 && user.end <= 22) {
                price = (12 - user.start)*[[workDayPrice objectAtIndex:0] intValue] + (18 - 12)*[[workDayPrice objectAtIndex:1] intValue] + (20 - 18)*[[workDayPrice objectAtIndex:2] intValue] + (user.end - 20)*[[workDayPrice objectAtIndex:3] intValue];
            }
            
        }else if(user.start >= 12 && user.start <= 18) {
            if(user.end >= 12 && user.end <= 18) {
                price = (user.end - user.start)*[[workDayPrice objectAtIndex:1] intValue];
            }else if(user.end >= 18 && user.end <= 20) {
                price = (18 - user.start)*[[workDayPrice objectAtIndex:1] intValue] + (user.end - 18)*[[workDayPrice objectAtIndex:2] intValue];
            }else if(user.end >=20 && user.end <= 22) {
                price = (18 - user.start)*[[workDayPrice objectAtIndex:1] intValue] + (20 - 18)*[[workDayPrice objectAtIndex:2] intValue] + (user.end - 20)*[[workDayPrice objectAtIndex:3] intValue];
            }
        }else if(user.start >= 18 && user.start <= 20) {
            if(user.end >= 18 && user.end <= 20) {
                price = (user.end - user.start)*[[workDayPrice objectAtIndex:2] intValue];
            }else if(user.end >= 20 && user.end <= 22) {
                price = (20 - user.start)*[[workDayPrice objectAtIndex:2] intValue] + (user.end - 20)*[[workDayPrice objectAtIndex:3] intValue];
            }
        }else if(user.start >= 20 && user.start <= 22) {
            if(user.end >= 20 && user.end <= 22) {
                price = (user.end - user.start)*[[workDayPrice objectAtIndex:3] intValue];
            }
        }
        
    }else {         //周末时间的消费计算
        if(user.start >= 9 && user.start <= 12) {
            if(user.end >= 9 && user.end <= 12) {
                price = (user.end - user.start)*[[weekendayPrice objectAtIndex:0] intValue];
            }else if(user.end >= 12 && user.end <= 18) {
                price = (12 - user.start)*[[weekendayPrice objectAtIndex:0] intValue] + (user.end - 12)*[[weekendayPrice objectAtIndex:1] intValue];
            }else if(user.end >= 18 && user.end <= 22) {
                price = (12 - user.start)*[[weekendayPrice objectAtIndex:0] intValue] + (18 - 12)*[[weekendayPrice objectAtIndex:1] intValue] + (user.end - 18)*[[weekendayPrice objectAtIndex:2] intValue];
            }
        }else if(user.start >= 12 && user.start <= 18) {
            if(user.end >= 12 && user.end <= 18) {
                price = (user.end - user.start)*[[weekendayPrice objectAtIndex:1] intValue];
            }else if(user.end >= 18 && user.end <= 22) {
                price = (18 - user.start)*[[weekendayPrice objectAtIndex:1] intValue] + (user.end - 18)*[[weekendayPrice objectAtIndex:2] intValue];
            }
        }else if(user.start >= 18 && user.start <= 22) {
            price = (user.end - user.start)*[[weekendayPrice objectAtIndex:2] intValue];
        }
    }
    return price;
}

- (void)printIncomeResult {

    [self.incomeResultList sortUsingSelector:@selector(compareWithTime:)];   //对所有信息按照时间排序
    NSArray *placeArr = @[@"A",@"B",@"C",@"D"];   //场地
    NSMutableArray *incomeStr = [NSMutableArray arrayWithObjects:@"场地:A\n",@"场地:B\n",@"场地:C\n",@"场地:D\n", nil];    //收入信息字符串
//    NSArray *incomeInt = @[@(0),@(0),@(0),@(0)];
    NSMutableArray *incomeInt = [NSMutableArray arrayWithObjects:@0,@0,@0,@0, nil];   //每个场地的收入
    int bookIncome = 0;
    int cancelIncome = 0;
    for(User *user in incomeResultList) {
        if(user.isCancel == 0) {
            bookIncome = [self getPriceforOption:user];
            for(int i = 0;i < 4;i++) {
                if([placeArr[i] isEqualToString:user.place]) {
                    [incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i-%i-%i ",user.year,user.month,user.day]];
                    if(user.start < 10) {
                        [incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i",0]];
                    }
                    [incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i:00~",user.start]];
                    if(user.end < 10) {
                        [incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i",0]];
                    }
                    [incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i:00 %i 元\n",user.end,bookIncome]];
                    
                    bookIncome+=[incomeInt[i] intValue];
                                [incomeInt replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:bookIncome]];
                }
                
            }
        }
        if(user.isCancel == 1) {
            cancelIncome = [self calCancelIncome:user];
            for(int i = 0;i < 4;i++) {
                if([placeArr[i] isEqualToString:user.place]) {
                    [incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i-%i-%i ",user.year,user.month,user.day]];
                    if(user.start < 10) {
                        [incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i",0]];
                    }
                    [incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i:00~",user.start]];
                    if(user.end < 10) {
                        [incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i",0]];
                    }
                    [incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i:00 违约金 %i 元\n",user.end,cancelIncome]];
                    cancelIncome+=[incomeInt[i] intValue];
                    [incomeInt replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:cancelIncome]];
                }
                
            }
        }
    }
    NSLog(@"\n收入汇总\n---\n");
    int sum = 0;
    int i = 0;
    for(NSString *res in incomeStr) {
        sum+=[incomeInt[i] intValue];
        NSLog(@"%@",res);
        NSLog(@"小计：%i 元\n",[incomeInt[i] intValue]);
        i++;
    }
    NSLog(@"---\n总计：%i 元\n",sum);
}


@end
