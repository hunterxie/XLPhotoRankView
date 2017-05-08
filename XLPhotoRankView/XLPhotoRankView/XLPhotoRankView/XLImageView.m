//
//  XLImageView.m
//  DramaProject
//
//  Created by admin on 16/7/22.
//  Copyright © 2016年 xll. All rights reserved.
//

#import "XLImageView.h"

@interface XLImageView()<UIScrollViewDelegate>
{
    UILongPressGestureRecognizer *_longPressGes;
}
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,assign)CGRect selfRect;

@end

@implementation XLImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        _offSet = CGPointMake(0, 0);
        _selfRect = frame;
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [self addSubview:_imageView];
        
        _longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        _longPressGes.minimumPressDuration = 0.6;
        _longPressGes.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_longPressGes];
    }
    return self;
}
-(void)tap:(UITapGestureRecognizer *)sender
{
    if ( self.tapClick) {
        self.tapClick(self);
    }
}
-(void)longPress:(UILongPressGestureRecognizer *)longGes
{
    if (self.LongPressGes) {
        self.LongPressGes(self,longGes);
    }
}
-(void)setCanLongPress:(BOOL)canLongPress
{
    _longPressGes.enabled = canLongPress;
}
-(void)setCanDrag:(BOOL)canDrag
{
    self.scrollEnabled = canDrag;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
     _selfRect = frame;
    if (_imageView.image) {
        [self setFitFrameWithImage:_imageView.image];
    }
}
-(void)setLocalImage:(UIImage *)image
{
    if (image) {
        self.image = image;
        _imageView.image = image;
        [self setFitFrameWithImage:image];
    }
}
/**
 *  加载网络图片
 *
 *  @param url            网络连接
 *  @param tempImage      默认图
 *  @param completedBlock 图片请求回来后的回调
 */
-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)tempImage completed:(void (^)(UIImage *))completedBlock
{
   
    NSArray *colorArray = COLORARRAY;
    UIColor *color = colorArray[arc4random()%19];
    
    self.backgroundColor =  color;
    __weak typeof(self)weakSelf = self;

    [_imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        if (image) {
            weakSelf.image = image;
        }
        if (completedBlock) {
            completedBlock(image);
        }
        if (image && !error) {
            
            [weakSelf setFitFrameWithImage:image];
        }
    }];
}
/**
 *  根据图片的大小  设置图片的显示
 *
 *  @param image
 */
-(void)setFitFrameWithImage:(UIImage *)image
{
    CGSize size = image.size;
    float imageScale = size.height / size.width;
    float contentScale = _selfRect.size.height / _selfRect.size.width ;
    
    
    if (imageScale > contentScale) {
        
         _imageView.frame = CGRectMake(0, 0, _selfRect.size.width, imageScale * _selfRect.size.width);
        self.contentSize = CGSizeMake(_selfRect.size.width, imageScale * _selfRect.size.width);
//        if (_offSet.x == 0&& _offSet.y == 0) {
//            [self setContentOffset:CGPointMake(0, (GetHeight(_imageView) - _selfRect.size.height) / 2)];
//        }
//        else
//        {
            [self setContentOffset:CGPointMake(0, _offSet.y * GetHeight(_imageView))];
//        }
    }
    else
    {
        _imageView.frame = CGRectMake(0, 0, _selfRect.size.height / imageScale, _selfRect.size.height);
        self.contentSize = CGSizeMake(_selfRect.size.height / imageScale, _selfRect.size.height);
//        if (_offSet.x == 0 && _offSet.y == 0) {
//             [self setContentOffset:CGPointMake((GetWidth(_imageView) - _selfRect.size.width)/2, 0)];
//        }
//        else
//        {
             [self setContentOffset:CGPointMake(_offSet.x * GetWidth(_imageView), 0)];
//        }
    }
}
-(void)dealloc
{
//    NSLog(@"自定义图片显示框销毁");
}
@end
