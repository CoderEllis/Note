//
//  NSObject+Model.m
//  05-Runtime(字典转模型KVC实现)
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/message.h>

@implementation NSObject (Model)

/*
 int a = 2;
 int b = 3;
 int c = 4;
 int arr[] = {a,b,c};
 int *p = arr;
 p[0];
 NSLog(@"%d %d",p[0],p[1]);

 */

// 获取类里面所有方法
// class_copyMethodList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)// 本质:创建谁的对象


// 获取类里面属性
//  class_copyPropertyList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)

// Ivar:成员变量 以下划线开头
// Property:属性
+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    id objc = [[self alloc] init];
    
    // runtime:根据模型中属性,去字典中取出对应的value给模型属性赋值
    // 1.获取模型中所有成员变量 key
    // 获取哪个类的成员变量
    // count:成员变量个数
    unsigned int count = 0;
    // 获取成员变量数组
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    // 遍历所有成员变量
    for (int i = 0; i < count; i++) {
        // 获取成员变量
        Ivar ivar = ivarList[i];
        
        // 获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        // 获取key
        NSString *key = [ivarName substringFromIndex:1];
        
        // 去字典中查找对应value
        id value = dict[key];
        
        // 给模型中属性赋值
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
        
    return objc;
}


void test(int *count){
    *count = 3;
}

@end
