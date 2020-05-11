//
//  MyPhotoBrowser.m
//  MyTestDemo
//
//  Created by 御坂美琴 on 16/9/19.
//  Copyright © 2016年 chiu. All rights reserved.
//

#import "MyPhotoBrowser.h"
#import "MyPhotoBrowserCell.h"

#if __has_include(<UIImageView+WebCache.h>)
#import <UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif


#define Kwindows [UIApplication sharedApplication].keyWindow

typedef CGPoint (^sPoint)(void);
typedef CGPoint (^ePount)(NSInteger index);

typedef void (^CheckIndex)(NSInteger index,UIImage *image);

@interface MyPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    NSArray *dataArray;
    NSInteger _currentPage;
    
    UIScrollView *bgView;
    
    NSInteger selectRow;
    BOOL scrollerEnabled;
}


@property (strong, nonatomic) UICollectionView *collection;
@property (strong, nonatomic) UILabel *pageLabel;

@property (strong, nonatomic) UIImage *placeholderImage;

@property (assign, nonatomic) CGRect animateRect;

@property (copy, nonatomic) sPoint sPointBlock;
@property (copy, nonatomic) ePount ePointBlock;

@property (copy, nonatomic) CheckIndex checkIndexBlock;
@property (strong, nonatomic) NSArray *sheetTitleArray;

@end

//static MyPhotoBrowser *itans = nil;
@implementation MyPhotoBrowser


+(MyPhotoBrowser *)showImageArray:(NSArray *)ImageArray placeholderImage:(UIImage *)placeholderImage Index:(NSInteger)index AnimateWithStartPoint:(CGPoint (^)(void))startPoint AnimateWithEndPoint:(CGPoint (^)(NSInteger))endPoint
{
//    if (itans == nil) {
        MyPhotoBrowser *itans = [[MyPhotoBrowser alloc] init];
    if (!placeholderImage) {
        placeholderImage = [UIImage imageNamed:@"rectangular"];
    }
        itans.placeholderImage = placeholderImage;
        itans.sPointBlock = startPoint;
        itans.ePointBlock = endPoint;
        [itans CreateUIWithArray:ImageArray index:index];
//    }
    return itans;
}

-(void)ShowActionSheetWithTitle:(NSArray *)SheetTitleArray ChickIndex:(void (^)(NSInteger, UIImage *))checkIndex
{
    _checkIndexBlock = checkIndex;
    _sheetTitleArray = [SheetTitleArray mutableCopy];
    
    [_collection reloadData];
    
}

-(void)CreateUIWithArray:(NSArray *)array index:(NSInteger)index
{
    if (index <0 || index > array.count) {
        index = 0;
    }
    
    dataArray = [array mutableCopy];
    selectRow = index;
    CGRect bgRect = Kwindows.bounds;
    
    bgView = [[UIScrollView alloc] initWithFrame:bgRect];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.bounces = YES;
    bgView.delegate = self;
    bgView.pagingEnabled = YES;
    bgView.showsHorizontalScrollIndicator = NO;
    bgView.showsVerticalScrollIndicator = NO;
    bgView.contentOffset = CGPointMake(0, Kwindows.bounds.size.height);
    bgView.contentSize = CGSizeMake(bgRect.size.width, bgRect.size.height * 3);
    [Kwindows addSubview:bgView];
    
//    CGRect ctRect = CGRectMake(0, Kwindows.bounds.size.height, bgRect.size.width, bgRect.size.height);
//    UIView *view = [[UIView alloc] initWithFrame:ctRect];
//    view.backgroundColor = [UIColor redColor];
//    [bgView addSubview:view];
    
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    flowlayout.minimumLineSpacing = 0;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    CGRect ctRect = CGRectMake(0, Kwindows.bounds.size.height, bgRect.size.width, bgRect.size.height);
    self.collection = [[UICollectionView alloc] initWithFrame:ctRect collectionViewLayout:flowlayout];
    self.collection.showsHorizontalScrollIndicator = NO;
    self.collection.dataSource = self;
    self.collection.delegate = self;
    self.collection.pagingEnabled = YES;
    self.collection.backgroundColor = [UIColor clearColor];
    [self.collection registerClass:[MyPhotoBrowserCell class] forCellWithReuseIdentifier:MYPHOTOBROWSERCELL];
    [self.collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [bgView addSubview:self.collection];
    
    
    
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, bgView.frame.size.width, 80)];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",index + 1,dataArray.count];
    self.pageLabel.adjustsFontSizeToFitWidth = YES;
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.hidden = YES;
    [Kwindows addSubview:self.pageLabel];
//
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [bgView addGestureRecognizer:tap];
    
    bgView.alpha = 0;
    [self showView];
}



-(void)showView
{
    self.collection.hidden = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    imageView.center = _sPointBlock();
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [Kwindows addSubview:imageView];
    
    NSObject *object = dataArray[selectRow];
    if ([object isKindOfClass:[NSString class]]) {
        if ([(NSString*)object hasPrefix:@"http://"] || [(NSString*)object hasPrefix:@"https://"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)object] placeholderImage:self.placeholderImage];
            
        }else {
            imageView.image = [UIImage imageNamed:(NSString *)object];
        }
        
    }else if ([object isKindOfClass:[UIImage class]]) {
        imageView.image = (UIImage *)object;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = Kwindows.bounds;
        self->bgView.alpha = 1;
    } completion:^(BOOL finished) {
        self.collection.hidden = NO;
        self.pageLabel.hidden = NO;
        [imageView removeFromSuperview];
    }];
    
}

-(void)hiddenView
{
    
    CGPoint point = _ePointBlock(selectRow);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:Kwindows.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [Kwindows addSubview:imageView];
    
    MyPhotoBrowserCell *cell = (MyPhotoBrowserCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectRow inSection:0]];
    imageView.image = [cell getCellImage];
  
    self.collection.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = CGRectMake(point.x, point.y, 1, 1);
        self->bgView.alpha = 0;
        self->_pageLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [self disView];
    }];
}

-(void)disView
{
    [bgView removeFromSuperview];
    [_pageLabel removeFromSuperview];
    bgView = nil;
    _pageLabel = nil;
//    itans = nil;
}



-(void)tap:(UITapGestureRecognizer *)tap
{
    [self hiddenView];
}

-(void)imageOffset:(CGFloat)offset DisMiss:(BOOL)disMiss
{
    [self bgViewBackgroundColor:offset];
    if (disMiss) {
        [self disView];
    }
    
    
}

-(void)bgViewBackgroundColor:(CGFloat)offset
{
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:offset];
    _pageLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:offset];
}

#pragma mark - collectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MYPHOTOBROWSERCELL forIndexPath:indexPath];
//    selectRow = indexPath.row;
    
    NSObject* object = [dataArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        if ([(NSString*)object hasPrefix:@"http"]) {
            [cell setupWithUrlString:(NSString*)object placeholderImage:self.placeholderImage];
        }else {
            [cell setupWithImageName:(NSString*)object placeholderImage:self.placeholderImage];
        }
    }else if ([object isKindOfClass:[UIImage class]]) {
        [cell setupWithImage:(UIImage*)object placeholderImage:self.placeholderImage];
    }
    
    
    [cell svZoomScale:^(CGFloat scale) {
        if (scale == 1) {
            self->bgView.scrollEnabled = YES;
        }
        else
        {
            self->bgView.scrollEnabled = NO;
        }
    }];
    
    if (_sheetTitleArray.count) {
        [cell showActionSheetWithTitile:_sheetTitleArray CheckIndex:^(NSInteger index,UIImage *image) {
            self->_checkIndexBlock(index,image);
        }];
    }
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    MyPhotoBrowserCell *MyCell = (MyPhotoBrowserCell *)cell;
    [MyCell setSvZoom:1];
}

#pragma mark - scrollerView
//触摸
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == bgView) {
        scrollerEnabled = YES;
    }
    
    
    
}
//离手
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}


//准备滑动
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

//正在滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == bgView) {
        
        if (scrollerEnabled) {
            CGFloat OffsetY = scrollView.contentOffset.y;
            CGFloat py = bgView.frame.size.height / 2;
            
            CGFloat Offset = 1 - fabs(OffsetY - bgView.frame.size.height) / py;
            Offset = Offset < 0 ? 0 : Offset;
            [self imageOffset:Offset DisMiss:NO];
        }
        
    }
    
}

//停止滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == bgView) {
        CGFloat OffsetY = scrollView.contentOffset.y;
        CGFloat py = bgView.frame.size.height / 2;
        
        CGFloat Offset = 1 - fabs(OffsetY - bgView.frame.size.height) / py;
        Offset = Offset < 0 ? 0 : Offset;
        
        if (OffsetY == 0 || OffsetY == bgView.frame.size.height * 2) {
            [self imageOffset:Offset DisMiss:YES];
        }
        else
        {
            [self imageOffset:Offset DisMiss:NO];
        }
        
        
        scrollerEnabled = NO;
    }
    else
    {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat newSelectRow = offsetX / [UIApplication sharedApplication].keyWindow.bounds.size.width;
        if (newSelectRow != selectRow) {
            selectRow = newSelectRow;
            bgView.scrollEnabled = YES;
        }
        
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",selectRow + 1 , dataArray.count];
    }
    
}



@end
