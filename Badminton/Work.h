//
//  Work.h
//  Badminton
//
//  Created by calmliu on 2021/7/4.
//

#import <Foundation/Foundation.h>
#import "User.h"
#define minStart 9
#define maxStart 22
NS_ASSUME_NONNULL_BEGIN
//功能类，替代管理员的工作职能
@interface Work : NSObject {
    NSMutableArray *incomeResultList;    //保留所有预定和取消的信息
}
@property NSMutableArray *incomeResultList;

- (void)bookOrcancel:(NSString *)operation;   //进行预定和取消操作逻辑的函数

- (void)book:(User *)user;                    //预定场地

- (void)cancel:(User *)user;                  //取消预定

- (void)printIncomeResult;                    //打印收入记录

- (int)getPriceforOption:(User *)user;        //得到预定操作的收入

- (int)calCancelIncome:(User *)user;          //得到取消预定的违约收入

- (int)getWeek:(User *)user;                  //得到当前日期对应的星期索引

- (void)printCancelError;                     //打印取消不合法的操作

- (void)printConfictError;                    //打印操作冲突

- (void)printValidOptionError;                //打印不合法操作

- (void)printBookingSuccess;                  //打印成功操作



@end

NS_ASSUME_NONNULL_END
