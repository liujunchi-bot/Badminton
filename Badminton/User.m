//
//  User.m
//  Badminton
//
//  Created by calmliu on 2021/7/4.
//

#import "User.h"

@implementation User
@synthesize userID,year,month,day,start,end,place,isCancel;

- (instancetype)initWithuser:(NSString *)userID andYear:(int)year andMonth:(int)month andDay:(int)day andStart:(int)start andEnd:(int)end andPlace:(NSString *)place andIsCancel:(int)isCancel {
    if(self = [super init]) {
        self.userID = userID;
        self.year = year;
        self.month = month;
        self.day = day;
        self.start = start;
        self.end = end;
        self.place = place;
        self.isCancel = isCancel;
    }
    return self;
}

- (BOOL)isEquaToUserID:(User *)user {
    if([self.userID isEqualToString:user.userID]) {
        return YES;
    }
    return NO;
}


- (BOOL)isEqalToDate:(User *)user {
    if((self.year == user.year) && (self.month == user.month) && (self.day == user.day)) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqualToPlace:(User *)user {
    if([self.place isEqualToString:user.place]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqualToUser:(User *)user {
    if(([self.userID isEqualToString:user.userID]) && (self.year == user.year) && (self.month == user.month) && (self.day == user.day) && (self.start == user.start) && (self.end == user.end) && [self.place isEqualToString:user.place] && (self.isCancel == user.isCancel)) {
        return YES;
    }
    return NO;
}

- (BOOL)isTimeError:(User *)user {    //时间冲突的几种情况
    if(([self isEqalToDate:user]) && ((self.start < user.start && self.end < user.end && self.end > user.start) || (self.start > user.start && self.start < user.end && self.end > user.start && self.end < user.end)|| (self.start > user.start && self.start < user.end && self.end > user.end) || (user.start < self.start && user.end < self.end && user.end > self.start) || (user.start > self.start && user.end < self.end && user.end > self.start && user.end < self.end) || (user.start > self.start && user.start < self.end && user.end > self.end) || (self.start == user.start && self.end == user.end)) && ([self isEqualToPlace:user])) {
        return YES;
    }
    return NO;
}

- (NSComparisonResult)compareWithTime:(User *)user {
    NSComparisonResult result = [[NSNumber numberWithInt:self.year] compare:[NSNumber numberWithInt:user.year]];   //按照年份排序
    if(result == NSOrderedSame) {
        //年份相同按照月份排序
        result = [[NSNumber numberWithInt:self.month] compare:[NSNumber numberWithInt:user.month]];
        if(result == NSOrderedSame) {
            //年份月份相同按照日排序
            result = [[NSNumber numberWithInt:self.day] compare:[NSNumber numberWithInt:user.day]];
            if(result == NSOrderedSame) {
                //年月日相同按照开始时间排序
                result = [[NSNumber numberWithInt:self.start] compare:[NSNumber numberWithInt:user.start]];
            }
        }
    }
    return result;
}

@end
