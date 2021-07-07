//
//  User.h
//  Badminton
//
//  Created by calmliu on 2021/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject {     //用户类，保留每一个用户输入的操作信息
    NSString *userID;            //用户ID
    int year;                    //年
    int month;                   //月
    int day;                     //日
    int start;                   //开始时间
    int end;                     //结束时间
    NSString *place;             //场地
    int isCancel;     //isCancel为0表示是预定，isCancel为1代表为取消预定的操作
}
@property NSString *userID,*place;
@property int year,month,day,start,end,isCancel;

- (instancetype)initWithuser:(NSString *)userID andYear:(int)year andMonth:(int)month andDay:(int)day andStart:(int)start andEnd:(int)end andPlace:(NSString *)place andIsCancel:(int)isCancel;     //自定义带参的构造函数

- (BOOL)isEquaToUserID:(User *)user;   //判断用户ID是否相同

- (BOOL)isEqalToDate:(User *)user;     //判断日期是否相同

- (BOOL)isEqualToPlace:(User *)user;   //判断场地是否相同

- (BOOL)isEqualToUser:(User *)user;    //判断用户操作信息是否相同

- (BOOL)isTimeError:(User *)user;      //判断预定和取消操作里，时间信息的合法性

-(NSComparisonResult)compareWithTime:(User *)user;   //自定义一个排序函数，按照时间顺序

@end

NS_ASSUME_NONNULL_END
