//
//  MyPhotoBrowser.h
//  MyTestDemo
//
//  Created by 御坂美琴 on 16/9/19.
//  Copyright © 2016年 chiu. All rights reserved.
//  16年写的，有点乱。没怎么整理

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyPhotoBrowser : NSObject

/**
 *	@brief	浏览图片组   适合多张图片
 *
 *
 */

+(MyPhotoBrowser *)showImageArray:(NSArray *)ImageArray placeholderImage:(UIImage *)placeholderImage Index:(NSInteger)index AnimateWithStartPoint:(CGPoint (^)(void))startPoint AnimateWithEndPoint:(CGPoint (^)(NSInteger index))endPoint;


-(void)ShowActionSheetWithTitle:(NSArray *)SheetTitleArray ChickIndex:(void (^)(NSInteger index,UIImage *image))checkIndex;

@end
