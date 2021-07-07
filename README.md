# 测试输入输出样例

- 测试样例一：

输入样例：

```bash
U001 2021-07-01 08:00~10:00 A
U001 2021-07-01 09:00~09:00 A
U001 2021-07-01 19:00~23:00 A
U001 2021-07-01 09:00~10:30 A
U001 2021-07-01 09:00~10:00 E
U001 2021-7-01 09:00~10:00 E
abcdcdcassa
U001 2021-07-01 09:00~12:00 A
U001 2021-07-01 20:00~22:00 A
U001 2021-07-01 13:00~20:00 B
U002 2021-07-03 09:00~11:00 C
U002 2021-07-03 13:00~20:00 D
```

输入输出完整样例：

```bash
U001 2021-07-01 08:00~10:00 A   //9:00才开始，8：00不能预定
Error: the booking is invalid!
U001 2021-07-01 09:00~09:00 A   //必须为整小时，预定时间不能为0
Error: the booking is invalid!
U001 2021-07-01 19:00~23:00 A     //22:00以后就不能预定了，23:00错误不合法
Error: the booking is invalid!
U001 2021-07-01 09:00~10:30 A     //必须为整点整小时，没有10:30
Error: the booking is invalid!
U001 2021-07-01 09:00~10:00 E    //预定场地必须为A，B，C，D，没有E，不合法
Error: the booking is invalid!
U001 2021-7-01 09:00-10:00 A     //格式不符合规范
Error: the booking is invalid!
abcdasadaa                      //格式不符合规范
Error: the booking is invalid!
U001 2021-07-01 09:00~12:00 A   
Success: the booking is accepted!
U001 2021-07-01 20:00~22:00 A
Success: the booking is accepted!
U001 2021-07-01 13:00~20:00 B
Success: the booking is accepted!
U002 2021-07-03 09:00~11:00 C
Success: the booking is accepted!
U002 2021-07-03 13:00~20:00 D
Success: the booking is accepted!

收入汇总
---

场地:A
2021-7-1 09:00~12:00 90 元
2021-7-1 20:00~22:00 120 元
小计：210 元

场地:B
2021-7-1 13:00~20:00 410 元
小计：410 元

场地:C
2021-7-3 09:00~11:00 80 元
小计：80 元

场地:D
2021-7-3 13:00~20:00 370 元
小计：370 元

---
总计：1070 元

//输出结果准确
```

- 测试样例二：

输入样例：

```bash
U001 2021-07-01 09:00~12:00 A
U001 2021-07-01 09:00~12:00 A
U001 2021-07-01 11:00~13:00 A
U001 2021-07-01 10:00~12:00 A C
U001 2021-07-01 09:00~12:00 A D
U001 2021-07-01 09:00~12:00 A C
U001 2021-07-01 09:00~12:00 A C
U001 2021-07-01 13:00~20:00 B
U002 2021-07-01 09:00~12:00 B
```

输入输出完整样例：

```bash
U001 2021-07-01 09:00~12:00 A
Success: the booking is accepted!
U001 2021-07-01 09:00~12:00 A     //预定冲突，A场地该时间段已经预定过了
Error: the booking conflicts with existing bookings!
U001 2021-07-01 11:00~13:00 A    //预定冲突，预定的时间段里，11:00～12:00已经被预定了，不能再预定
Error: the booking conflicts with existing bookings!
U001 2021-07-01 10:00~12:00 A C   //只能完整取消之前的预订，不能取消部分时间段
Error: the booking being cancelled does not exist!
U001 2021-07-01 09:00~12:00 A D   //取消标记只能是 C，若为其他字符则报错
Error: the booking is invalid!
U001 2021-07-01 09:00~12:00 A C   
Success: the booking is accepted!
U001 2021-07-01 09:00~12:00 A C   预定场次已经被取消过了，不能再次取消
Error: the booking being cancelled does not exist!
U001 2021-07-01 13:00~20:00 B
Success: the booking is accepted!
U002 2021-07-01 09:00~12:00 B
Success: the booking is accepted!
U001 2021-07-01 13:00~20:00 C
Success: the booking is accepted!
U002 2021-07-01 09:00~12:00 C
Success: the booking is accepted!
U002 2021-07-01 09:00~12:00 C C
Success: the booking is accepted!

收入汇总
---

场地:A   //收入记录有多条时按照时间顺序输出
2021-7-1 09:00~12:00 违约金 45 元
小计：45 元

场地:B
2021-7-1 09:00~12:00 90 元
2021-7-1 13:00~20:00 410 元
小计：500 元

场地:C
2021-7-1 09:00~12:00 违约金 45 元
2021-7-1 13:00~20:00 410 元
小计：455 元

场地:D
小计：0 元

---
总计：1000 元

//输出结果符合题目要求
```

# 遇到的问题与解决

- NSArray为不可变数组，里面的元素不能被赋值改变，不像java里面的数组a[1] = 0，可以直接访问赋值改变，因此需要用不可变数组NSMutableArray，如下,用它的replaceObjectAtIndex方法：

```objective-c
[incomeStr replaceObjectAtIndex:i withObject:[incomeStr[i] stringByAppendingFormat:@"%i-%i-%i ",user.year,user.month,user.day]];
```

- NSArry不能储存基本数据类型，只能类似于NSString，NSNumber类型，如果要取出来当作int这些基本类型使用，得进行类型转换。

如NSNumber转int：

```objective-c
[[workDayPrice objectAtIndex:0] intValue];
```

- 正则表达式的使用：这个题需要使用正则表达式来巧妙地处理输入，让输入转化成我们想要去使用的数据，正则表达式如下：

```objective-c
NSString *bookPattern = @"(U)(\\d{3})(\\s)(\\d{4})(-)(\\d{2})(-)(\\d{2})(\\s)(\\d{2})(:)(00)(~)(\\d{2})(:)(00)(\\s)([A-D])";
    NSString *cancelPattern = @"(U)(\\d{3})(\\s)(\\d{4})(-)(\\d{2})(-)(\\d{2})(\\s)(\\d{2})(:)(00)(~)(\\d{2})(:)(00)(\\s)([A-D])(\\s)([C])";
```

之后便是使用谓词来对输入字符串，根据正则表达式来进行匹配。

本来我是想利用下面的语句来对匹配的子串进行提取，也就是说把用户ID，年，月，日，开始时间，结束时间，场地这些子串都一一提取出来：

```objective-c
NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:bookPattern options:NSRegularExpressionCaseInsensitive error:nil];


        NSArray *result = [reg matchesInString:operation options:NSMatchingReportCompletion range:NSMakeRange(0, operation.length)];
        NSUInteger *number = [reg numberOfMatchesInString:operation options:NSMatchingReportProgress range:NSMakeRange(0, operation.length)];
        NSLog(@"number:  %lu",(unsigned long)number);
        [reg enumerateMatchesInString:operation options:0 range:NSMakeRange(0, operation.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            NSLog(@"%@",result);
        }];
        for(NSTextCheckingResult *res in result) {
            NSLog(@"%@ %@",NSStringFromRange(res.range),[operation substringWithRange:res.range]);
            [patternRes addObject:[operation substringWithRange:res.range]];
        }
        NSLog(@"length:  %lu",[patternRes count]);
```

但是OC里面没有向Java里面正则表达式处理的group函数一样，把正则表达式里的括号一一提取出匹配的子串，所以我只能用谓词匹配完以后，自己手动将匹配子串一一提取出来，这块儿地方网上搜了很久没找到。

- 日期处理函数：找到年月日对应的星期几，这个不需要手动实习，有专门的函数：

```objective-c
 [format setDateFormat:@"yyyy-MM-dd"];
    date = [format dateFromString:myDate];
    [format setDateFormat:@"EEEE"];  //星期几的格式
    NSString *myweek = [format stringFromDate:date];
```

- 使用OC还不够熟练，通过这些熟能生巧，还是保留着写Java的习惯，写起来有时候会带有Java函数思维去写嘿嘿。