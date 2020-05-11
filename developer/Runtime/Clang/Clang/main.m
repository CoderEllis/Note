//
//  main.m
//  Clang
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        id objc =  [NSObject alloc];
//
//        objc_msgSend(objc_getClass("NSObject"), sel_registerName("alloc"))
//        
//        objc = [objc init];
//        
//       objc_msgSend(objc, sel_registerName("init"))
        /*
         id objc = ((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSObject"), sel_registerName("alloc"));
         
         objc = ((id (*)(id, SEL))(void *)objc_msgSend)((id)objc, sel_registerName("init"));
         */
        
    }
    
    return 0;
}
