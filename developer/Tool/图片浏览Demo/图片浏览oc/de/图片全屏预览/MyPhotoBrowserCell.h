//
//  MyPhotoBrowserCell.h
//  MyTestDemo
//
//  Created by 御坂美琴 on 16/9/19.
//  Copyright © 2016年 chiu. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MYPHOTOBROWSERCELL @"MyPhotoBrowserCell"

/*
typedef NS_ENUM(NSInteger,ScrollerDirection){
    DirectionWithNone,
    DirectionWithUp,
    DirectionWithDown,
};
*/

@interface MyPhotoBrowserCell : UICollectionViewCell



- (void)setupWithUrlString:(NSString*)url placeholderImage:(UIImage*)placeholderImage;
- (void)setupWithImageName:(NSString*)imgName placeholderImage:(UIImage*)placeholderImage;
- (void)setupWithImage:(UIImage*)img placeholderImage:(UIImage*)placeholderImage;

-(void)setSvZoom:(CGFloat)zoom;

-(void)svZoomScale:(void (^)(CGFloat scale))scaleBlock;

-(UIImage *)getCellImage;

-(void)showActionSheetWithTitile:(NSArray *)titleArray CheckIndex:(void (^)(NSInteger index,UIImage *image))checkIndex;

@end
