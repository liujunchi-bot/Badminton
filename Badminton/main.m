//
//  main.m
//  Badminton
//
//  Created by calmliu on 2021/7/3.
//

#import <Foundation/Foundation.h>
#import "Work.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        while () {
//            char buffer[1000];
//            NSLog(@"请输入你的操作：\n");
//            scanf(@"%s",buffer);
//            NSString *option = [NSString stringWithUTF8String:buffer];
//        NSArray *input = @[@"U002 2017-08-01 19:00~22:00 A",@"U003 2017-08-01 18:00~20:00 A",@"U002 2017-08-01 19:00~22:00 A C",@"U002 2017-08-01 19:00~22:00 A C",@"U003 2017-08-01 18:00~20:00 A",@"U003 2017-08-02 13:00~17:00 B"];
            Work *work = [[Work alloc] init];
//        for(NSString *option in input){
//            [work bookOrcancel:option];
//        }
//        [work printIncomeResult];
        char buffer[100];
        gets(buffer);
        NSString *option = [NSString stringWithUTF8String:buffer];
//        NSLog(@"%lu",(unsigned long)option.length);
        [work bookOrcancel:option];
        while (option.length !=0 && ![option isEqualToString: @""]) {
            gets(buffer);
            option = [NSString stringWithUTF8String:buffer];
            [work bookOrcancel:option];
//            NSLog(@"%lu",(unsigned long)option.length);
        }
        [work printIncomeResult];
        
        
        
        
        
//        }
    }
    return 0;
}
