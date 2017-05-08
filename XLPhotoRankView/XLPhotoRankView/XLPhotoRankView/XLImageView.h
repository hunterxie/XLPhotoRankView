//
//  XLImageView.h
//  DramaProject
//
//  Created by admin on 16/7/22.
//  Copyright © 2016年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MJExtension.h"
#import "DMTool.h"


#define SCREENHEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREENWIDTH   [[UIScreen mainScreen] bounds].size.width

//app主色调
#define MAIN_COLOR [UIColor redColor]

#define COLORARRAY @[[UIColor colorWithRed:0.84f green:0.38f blue:0.41f alpha:1.00f],[UIColor colorWithRed:0.74f green:0.53f blue:0.69f alpha:1.00f],[UIColor colorWithRed:0.95f green:0.65f blue:0.76f alpha:1.00f],[UIColor colorWithRed:1.00f green:0.78f blue:0.79f alpha:1.00f],[UIColor colorWithRed:1.00f green:0.91f blue:0.89f alpha:1.00f],[UIColor colorWithRed:0.64f green:0.65f blue:0.43f alpha:1.00f],[UIColor colorWithRed:0.66f green:0.77f blue:0.73f alpha:1.00f],[UIColor colorWithRed:0.93f green:0.96f blue:0.75f alpha:1.00f],[UIColor colorWithRed:0.92f green:0.90f blue:0.19f alpha:1.00f],[UIColor colorWithRed:0.80f green:0.78f blue:0.88f alpha:1.00f],[UIColor colorWithRed:0.62f green:0.82f blue:0.87f alpha:1.00f],[UIColor colorWithRed:0.65f green:0.84f blue:0.86f alpha:1.00f],[UIColor colorWithRed:0.71f green:0.93f blue:0.83f alpha:1.00f],[UIColor colorWithRed:0.91f green:0.88f blue:0.86f alpha:1.00f],[UIColor colorWithRed:0.72f green:0.69f blue:0.70f alpha:1.00f],[UIColor colorWithRed:0.52f green:0.48f blue:0.60f alpha:1.00f],[UIColor colorWithRed:0.80f green:0.57f blue:0.65f alpha:1.00f],[UIColor colorWithRed:0.81f green:0.87f blue:0.86f alpha:1.00f],[UIColor colorWithRed:0.42f green:0.83f blue:0.78f alpha:1.00f]]

#define GetHeight(a) CGRectGetHeight(a.frame)
#define GetWidth(a) CGRectGetWidth(a.frame)

#define GetOriginX(a) a.frame.origin.x
#define GetOriginY(a) a.frame.origin.y

#define GetMaxX(a) CGRectGetMaxX(a.frame)
#define GetMaxY(a) CGRectGetMaxY(a.frame)

typedef NS_ENUM(NSUInteger, XLContentModeType) {
    XLContentModeLeft = 0,  //如果超出范围  显示图片的左边部分  默认的
    XLContentModeRight, // 右边部分
    
    XLContentModeTop, //默认的
    XLContentModeBottom, //
    XLContentModeCenter, //居中显示
    
    
    XLContentModeAspectFull,//保持比例铺满
    XLContentModeFill,//不保持比例铺满
};
@interface XLImageView : UIScrollView

@property(nonatomic,assign)XLContentModeType contentMode;  //设置图片显示的区域

@property(nonatomic,assign)BOOL canDrag;//内部是否可以拖动图片

@property(nonatomic,assign)BOOL canLongPress;//是否可以长按

@property(nonatomic,assign)CGPoint offSet;//一开始的默认偏移量 如果不赋值  就是CGPointZero

-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image completed:(void(^)(UIImage *image))completedBlock;//显示网络图片

-(void)setLocalImage:(UIImage *)image;// 显示本地图片

@property(nonatomic,strong)UIImage *image;


@property(nonatomic,copy)void (^tapClick)(XLImageView *imageView);
@property(nonatomic,copy)void (^LongPressGes)(XLImageView *imageView,UILongPressGestureRecognizer *ges);

@end
