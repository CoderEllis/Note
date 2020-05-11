//
//  MyPhotoBrowserCell.m
//  MyTestDemo
//
//  Created by 御坂美琴 on 16/9/19.
//  Copyright © 2016年 chiu. All rights reserved.
//

#import "MyPhotoBrowserCell.h"

#import "MBCircularProgressBarView.h"

#if __has_include(<UIImageView+WebCache.h>)
#import <UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif

typedef void (^CheckIndex)(NSInteger index,UIImage *image);

typedef void (^Scale)(CGFloat scale);

@interface MyPhotoBrowserCell ()<UIScrollViewDelegate,UIActionSheetDelegate>
{
    BOOL scrollerEnabled;
    NSArray *_titleArray;
    UIImage *_placeholderImage;
}

@property (strong, nonatomic) UIScrollView *imgSv;
//@property (strong, nonatomic) UIScrollView *sv;

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) MBCircularProgressBarView *circular;

@property (copy, nonatomic) CheckIndex checkIndexBlock;
@property (copy, nonatomic) Scale scaleBlock;
@end

@implementation MyPhotoBrowserCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    
    return self;
}

- (void)setupWithUrlString:(NSString*)url placeholderImage:(UIImage*)placeholderImage {
    [self setupImageView];
    
    _placeholderImage = placeholderImage;
    [self setFrameWithImage:placeholderImage];
    self.imageView.image = placeholderImage;
    
    _circular.hidden = NO;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    
//    [manager loadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
////        NSLog(@"显示当前进度 = %ld,大小 = %ld",receivedSize,expectedSize);
//        _circular.value = receivedSize / expectedSize;
//
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        if (image) {
//            _circular.hidden = YES;
//            self.imageView.image = image;
//            [self setFrameWithImage:image];
//
//        }
//        else
//        {
//            NSLog(@"error = %@",error);
//             _circular.hidden = YES;
//        }
//    }];
    
    [manager loadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        NSLog(@"显示当前进度 = %ld,大小 = %ld",receivedSize,expectedSize);
        self->_circular.value = receivedSize / expectedSize;
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            self->_circular.hidden = YES;
            self.imageView.image = image;
            [self setFrameWithImage:image];
            
        }
        else
        {
            NSLog(@"error = %@",error);
            self->_circular.hidden = YES;
        }
    }];
    
    
    
    
   
}
- (void)setupWithImageName:(NSString*)imgName placeholderImage:(UIImage*)placeholderImage {
    [self setupImageView];
    _placeholderImage = placeholderImage;
    UIImage* image = [UIImage imageNamed:imgName];
    if (!image) {
        image  = placeholderImage;
    }
    self.imageView.image = image;
    [self setFrameWithImage:image];
}

- (void)setupWithImage:(UIImage*)img placeholderImage:(UIImage*)placeholderImage {
    [self setupImageView];
    _placeholderImage = placeholderImage;
    if (img) {
        self.imageView.image = img;
    }else {
        self.imageView.image = placeholderImage;
    }
    [self setFrameWithImage:self.imageView.image];
}




- (void)setupImageView {
    if (_imgSv) {
        [_imgSv removeFromSuperview];
        _imgSv = nil;
    }
    
    _placeholderImage = nil;
    scrollerEnabled = NO;
    _circular.hidden = YES;
//    [self.contentView addSubview:self.sv];
    [self.contentView addSubview:self.imgSv];
    
}


-(void)showActionSheetWithTitile:(NSArray *)titleArray CheckIndex:(void (^)(NSInteger, UIImage *))checkIndex
{
    _checkIndexBlock = checkIndex;
    _titleArray = [titleArray mutableCopy];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 1;
    [_imgSv addGestureRecognizer:longPress];
}

-(void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        for (NSString *title in _titleArray) {
            [sheet addButtonWithTitle:title];
        }
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }
    
}

-(void)setSvZoom:(CGFloat)zoom
{
    _imgSv.zoomScale = zoom;
}

-(void)svZoomScale:(void (^)(CGFloat))scaleBlock
{
    self.scaleBlock = scaleBlock;
}


/*
-(UIScrollView *)sv
{
    if (!_sv) {
        CGRect rect = self.bounds;
        rect.origin.y = 0;
        rect.size.height = rect.size.height;
        _sv = [[UIScrollView alloc] initWithFrame:rect];
        _sv.backgroundColor = [UIColor redColor];
        _sv.delegate = self;
//        _sv.maximumZoomScale = 3.0;
//        _sv.minimumZoomScale = 1.0;
        _sv.showsHorizontalScrollIndicator = NO;
        _sv.showsVerticalScrollIndicator = NO;
        _sv.bounces = YES;
        _sv.pagingEnabled = YES;
//        [_sv addSubview:self.imageView];
        [_sv addSubview:self.imgSv];

        _sv.contentOffset = CGPointMake(0, self.contentView.center.y *2);

        _sv.contentSize = CGSizeMake(0, self.bounds.size.height + (self.contentView.center.y *4));
        
        
    }
    return _sv;
}
*/

-(UIScrollView *)imgSv
{
    if (!_imgSv) {
//        CGRect rect = self.bounds;
//        rect.origin.y = self.contentView.center.y *2;
//        rect.size.height = self.bounds.size.height;
        
        CGRect rect = self.bounds;
        rect.origin.y = 0;
        rect.size.height = rect.size.height;
        
        _imgSv = [[UIScrollView alloc] initWithFrame:rect];
        _imgSv.backgroundColor = [UIColor clearColor];
        _imgSv.delegate = self;
        _imgSv.minimumZoomScale = 1;
        _imgSv.maximumZoomScale = 5;
        _imgSv.zoomScale = 1;
//        _imgSv.bounces = NO;
        [_imgSv addSubview:self.imageView];
    }
    
    return _imgSv;
}

- (UIImageView* )imageView {
    if (!_imageView) {
//        CGRect rect = self.bounds;
//        rect.origin.y = self.contentView.center.y *2;
//        rect.size.height = self.bounds.size.height;
        
        CGRect rect = CGRectMake(0, 0, _imgSv.frame.size.width, _imgSv.frame.size.height);
        
        _imageView = [[UIImageView alloc]initWithFrame:rect];
        _imageView.userInteractionEnabled = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor blueColor];
        [_imageView addSubview:self.circular];
    }
    return _imageView;
}


-(MBCircularProgressBarView *)circular
{
    if (!_circular) {
        _circular = [[MBCircularProgressBarView alloc] init];
        [self setCircularFrame];
        _circular.backgroundColor = [UIColor clearColor];
        _circular.maxValue = 1;
        _circular.value = 0;
        _circular.progressLineWidth = 2; //进度条宽度
        _circular.progressColor = [UIColor orangeColor]; //进度条已完成颜色
        _circular.progressStrokeColor = [UIColor orangeColor]; //进度条外部颜色
        _circular.emptyLineColor = [UIColor lightGrayColor];//进度条未完成颜色
        _circular.valueFontSize = 13;
        _circular.progressAngle = 100;
        _circular.showUnitString = NO;
        _circular.fontColor = [UIColor blackColor];
        _circular.hidden = YES;
        [_imageView addSubview:_circular];
    }
    return _circular;
}


-(void)setCircularFrame
{
    _circular.frame = CGRectMake(_imageView.frame.size.width / 2 - 18, _imageView.frame.size.height / 2 - 18, 36, 36);
    
    [_imageView bringSubviewToFront:_circular];
}

-(UIImage *)getCellImage
{
    if (_imageView.image) {
        return _imageView.image;
    }
    return nil;
}

-(void)setFrameWithImage:(UIImage *)image
{
    CGFloat i = image.size.width / image.size.height;
    CGFloat j = self.contentView.frame.size.width / self.contentView.frame.size.height;
    
    if (i >= j) {
        _imageView.frame=CGRectMake(0,
                                    (0 + (_imgSv.frame.size.height-image.size.height*_imgSv.frame.size.width/image.size.width)/2),
                                    _imgSv.frame.size.width,
                                    image.size.height*_imgSv.frame.size.width/image.size.width);
    }
    
    else
    {
        _imageView.frame=CGRectMake((_imgSv.frame.size.width-image.size.width*_imgSv.frame.size.height/image.size.height)/2,
                                    0,
                                    image.size.width*_imgSv.frame.size.height/image.size.height,
                                    _imgSv.frame.size.height);
    }
    
    [self setCircularFrame];
}



#pragma mark - scroller 缩放

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == _imgSv) {
        if (_imageView.frame.size.height > self.bounds.size.height) {
            CGRect rect = CGRectMake(_imageView.frame.origin.x, 0,
                                     _imageView.frame.size.width, _imageView.frame.size.height);
            _imageView.frame = rect;
            
        }
        else
        {
            CGRect rect = CGRectMake(_imageView.frame.origin.x,
                                     (self.bounds.size.height - _imageView.frame.size.height) /2,
                                     _imageView.frame.size.width, _imageView.frame.size.height);
            _imageView.frame = rect;
        }
        
        
        if (self.scaleBlock) {
            self.scaleBlock(scrollView.zoomScale);
        }
        
    }
    

}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}


#pragma mark - scroller 滚动




#pragma mark - actionSheet 

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"index = %ld",buttonIndex);
    if (buttonIndex == 0) {
        return;
    }
    else
    {
        if (self.checkIndexBlock) {
            if (_imageView.image == _placeholderImage || _imageView.image == nil) {
                self.checkIndexBlock(buttonIndex,nil);
            }
            else
            {
                self.checkIndexBlock(buttonIndex,_imageView.image);
            }
        }
    }
}

@end
