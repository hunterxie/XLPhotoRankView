//
//  XLPhotoRankView.m
//  DramaProject
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 xll. All rights reserved.
//

#import "XLPhotoRankView.h"



@interface XLPhotoRankView()<UIScrollViewDelegate>


@property(nonatomic,assign)CGPoint itemCenterPoint;
@property(nonatomic,assign)CGPoint itemStartPoint;

@property(nonatomic,assign) CGFloat photoViewHeight;

@property(nonatomic,strong)UIView *trashView;


@property(nonatomic,strong)UIButton *trashBtn;

@property(nonatomic,strong)NSMutableArray *dataArray;
@end
@implementation XLPhotoRankView

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
        _photoViewHeight = 0;
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        [self makeUI];
    }
    return self;
}
-(void)setItemDragEnable:(BOOL)itemDragEnable
{
    for (int i = 0; i< 9; i++) {
        XLImageView *imageView =  [self viewWithTag:100+i];
        imageView.canDrag = itemDragEnable;
    }
}
-(void)setMoveEnable:(BOOL)moveEnable
{
    if (!moveEnable) {
        for (int i = 0; i< 9; i++) {
            XLImageView *imageView =  [self viewWithTag:100+i];
            NSArray *gesArray = imageView.gestureRecognizers;
            for (UIGestureRecognizer *ges in gesArray) {
                if ([ges isKindOfClass:[UILongPressGestureRecognizer class]]) {
                    [imageView removeGestureRecognizer:ges];
                    continue;
                }
            }
        }
    }
}
-(NSString *)GetContentOffSetArrayString
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.dataArray.count; i++) {
        XLImageView *imageView =  [self viewWithTag:100+i];
        CGPoint offSet = imageView.contentOffset;
        CGPoint newOffSet = CGPointMake((int)(offSet.x * 1000 / imageView.contentSize.width),(int)(offSet.y * 1000 / imageView.contentSize.height));
        NSString *offSetStr = NSStringFromCGPoint(newOffSet);
        [array addObject:offSetStr];
    }
    return [array mj_JSONString];
}
-(void)makeUI
{
    _trashView = [[UIView alloc]initWithFrame:CGRectMake(0, -SCREENHEIGHT, SCREENWIDTH, 3 * SCREENHEIGHT)];
    _trashView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    _trashView.hidden = YES;
    [self addSubview:_trashView];
    
    CGFloat distance = 13;
    CGFloat gap = 5;
    CGFloat width = (SCREENWIDTH - distance * 2 - gap * 2)/3;
    
    for ( int i = 0; i<9; i++) {
        XLImageView *imageView = [[XLImageView alloc]initWithFrame:CGRectMake(distance + (width + gap) * (i % 3), (i / 3)*(width + gap), width, width)];
        imageView.canDrag = NO;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 2;
        imageView.hidden = YES;
        imageView.tag = 100+i;
        imageView.delegate = self;
        __weak typeof(self) weakSelf = self;
        imageView.tapClick = ^(XLImageView *tempImageView)
        {
            if (weakSelf.clickImage) {
                weakSelf.clickImage(tempImageView);
            }
        };
        imageView.LongPressGes = ^(XLImageView *temoImageView,UILongPressGestureRecognizer *recognizer)
        {
            [weakSelf longPress:recognizer];
        };
        [self addSubview:imageView];
    }
    
   
    
    _trashBtn = [DMTool CreateBtnWithFrame:CGRectMake(0, 70, SCREENWIDTH, 45.5) withNormalImg:@"moment_deletePic_un" withSelectedImg:@"moment_deletePic_un" selector:nil target:nil];
    _trashBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _trashBtn.hidden = YES;
    _trashBtn.backgroundColor =  MAIN_COLOR;
    [self addSubview:_trashBtn];
}
-(CGFloat)reloadWithArray:(NSArray *)array withContentOffSetString:(NSString *)offSetString
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    NSArray *picArray = array;
  
    NSArray *offSetArray = [offSetString mj_JSONObject];
    
    
    BOOL onlyOnePhoto = NO;
    
    if (picArray.count == 1) {
        onlyOnePhoto = YES;
    }
    
    for (int i = 0; i< 9; i++) {
        XLImageView *imageView =  [self viewWithTag:100+i];
        if (i < picArray.count) {
            imageView.hidden = NO;
            
            if (i < offSetArray.count ) {
                NSString *offStr = offSetArray[i];
                CGPoint contentOffSet = CGPointFromString(offStr);
                CGPoint newPoint =CGPointMake(contentOffSet.x / 1000, contentOffSet.y /1000);
                imageView.offSet = newPoint;
            }
            else
            {
                imageView.offSet = CGPointZero;
            }
            
            if (_isNetImage) {
                //一张的时候 就不采取压缩的方案
                if (onlyOnePhoto) {
                    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",picArray[i]]] placeholderImage:nil completed:^(UIImage *image) {
                        
                    }];
                }
                else
                {
                    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@-m7",picArray[i]]] placeholderImage:nil completed:^(UIImage *image) {
                        
                    }];
                }
            }
            else
            {
                //本地图片 未处理
                [imageView setLocalImage:picArray[i]];
            }
        }
        else
        {
            imageView.hidden = YES;
        }
    }
    return [self LayOutViews:picArray];
}
-(CGFloat)LayOutViews:(NSArray *)picArray
{
    CGFloat distance = 13;
    CGFloat gap = 5;
    CGFloat totalHeight = 0;
    
    switch (MIN(picArray.count, 9)) {
        case 1:
        {
            CGFloat anotherWidth = SCREENWIDTH - 2 * distance;
            XLImageView *imageView =  [self viewWithTag:100];
            imageView.frame = CGRectMake(distance, 0,anotherWidth, anotherWidth);
            totalHeight = anotherWidth;
        }
            break;
        case 2:
        {
            CGFloat width = (SCREENWIDTH - distance *2 - gap)/2;
            for (int i = 0; i<picArray.count; i++) {
                XLImageView *imageView =  [self viewWithTag:100+ i];
                imageView.frame = CGRectMake(distance + (width + gap) * (i % 2), 0, width, width);
            }
            totalHeight = width;
        }
            break;
        case 3:
        {
            CGFloat width = (SCREENWIDTH - distance * 2 - gap)/2;
            for (int i = 0; i<picArray.count; i++) {
                XLImageView *imageView =  [self viewWithTag:100+ i];
                if (i == 0) {
                    imageView.frame = CGRectMake(distance, 0, SCREENWIDTH - 2* distance, width);
                }
                else
                {
                    imageView.frame = CGRectMake(distance + (width + gap) * ((i - 1) % 2), width  + gap, width, width);
                }
            }
            totalHeight = width + gap + width;
        }
            break;
        case 4:
        {
            CGFloat width = (SCREENWIDTH - distance *2 - gap)/2;
            for (int i = 0; i<picArray.count; i++) {
                XLImageView *imageView =  [self viewWithTag:100+ i];
                imageView.frame = CGRectMake(distance + (width + gap) * (i % 2), (width + gap) *(i / 2), width, width);
            }
            totalHeight = width + gap + width;
        }
            break;
        case 5:
        {
            CGFloat width = (SCREENWIDTH - distance *2 - gap)/2;
            
            CGFloat anotherWidth = (SCREENWIDTH - distance * 2 - gap *2) / 3;
            
            for (int i = 0; i<picArray.count; i++) {
                XLImageView *imageView =  [self viewWithTag:100+ i];
                if (i < 2) {
                    imageView.frame = CGRectMake(distance + (width + gap) * (i % 2), 0, width, width);
                }
                else
                {
                    imageView.frame = CGRectMake(distance + (anotherWidth + gap) * ((i - 2) % 3), width + gap, anotherWidth, anotherWidth);
                }
                
            }
            totalHeight = width + gap + anotherWidth;
        }
            break;
        case 6:
        {
            CGFloat anotherWidth = (SCREENWIDTH - distance * 2 - gap *2) / 3;
            
            for (int i = 0; i<picArray.count; i++) {
                XLImageView *imageView =  [self viewWithTag:100+ i];
                
                if (i == 0) {
                    imageView.frame = CGRectMake(distance, 0, anotherWidth * 2 + gap, anotherWidth * 2 + gap);
                }
                else if(i == 1)
                {
                    imageView.frame = CGRectMake(distance + (anotherWidth + gap) * 2, 0, anotherWidth, anotherWidth);
                }
                else if (i == 2)
                {
                    imageView.frame = CGRectMake(distance + (anotherWidth + gap) * 2, (anotherWidth + gap), anotherWidth, anotherWidth);
                }
                else
                {
                    imageView.frame = CGRectMake(distance + (anotherWidth + gap) * ((i - 3) % 3), (anotherWidth + gap) * 2, anotherWidth, anotherWidth);
                }
            }
            totalHeight = anotherWidth * 3 + 2* gap;
        }
            break;
        case 7:
        {
            CGFloat width = (SCREENWIDTH - distance *2 - gap)/2;
            CGFloat anotherWidth = (SCREENWIDTH - distance * 2 - gap *2) / 3;
            
            for (int i = 0; i<picArray.count; i++) {
                XLImageView *imageView =  [self viewWithTag:100+ i];
                if (i == 0) {
                    imageView.frame = CGRectMake(distance, 0, SCREENWIDTH - 2* distance, width);
                }
                else
                {
                    imageView.frame = CGRectMake(distance + (anotherWidth + gap) * ((i - 1) % 3), (width  + gap) + ((i - 1)/3)*(anotherWidth + gap), anotherWidth, anotherWidth);
                }
            }
            totalHeight = (width + gap) + (anotherWidth * 2 + gap);
        }
            break;
        case 8:
        {
            CGFloat width = (SCREENWIDTH - distance *2 - gap)/2;
            
            CGFloat anotherWidth = (SCREENWIDTH - distance * 2 - gap *2) / 3;
            
            for (int i = 0; i<picArray.count; i++) {
                XLImageView *imageView =  [self viewWithTag:100+ i];
                if (i < 2) {
                    imageView.frame = CGRectMake(distance + (width + gap) * (i % 2), 0, width, width);
                }
                else
                {
                    imageView.frame = CGRectMake(distance + (anotherWidth + gap) * ((i - 2) % 3),width + gap + (anotherWidth + gap) *((i - 2) / 3), anotherWidth, anotherWidth);
                }
                
            }
            totalHeight = (width + gap) + anotherWidth * 2 + gap;
        }
            break;
        case 9:
        {
            CGFloat anotherWidth = (SCREENWIDTH - distance * 2 - gap *2) / 3;
            
            for (int i = 0; i<picArray.count; i++) {
                XLImageView *imageView =  [self viewWithTag:100+ i];
                imageView.frame = CGRectMake(distance + (anotherWidth + gap) * (i % 3), (anotherWidth + gap) *(i / 3), anotherWidth, anotherWidth);
                
            }
            totalHeight = anotherWidth * 3 + 2*gap;
        }
            break;
        default:
        {
            totalHeight = 0;
        }
            break;
    }
    
    
    _photoViewHeight = totalHeight + 10;
    
    _trashBtn.frame = CGRectMake(0, totalHeight + 85 - 45.5, SCREENWIDTH, 45.5);
    
    if (self.rankViewHeightChanged) {
        self.rankViewHeightChanged(totalHeight);
    }
    
    return totalHeight;
}
-(void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.rankState) {
            self.rankState(RankViewStateStartBegan);
        }
        _trashView.hidden = NO;
         _trashBtn.hidden = NO;
        _itemStartPoint = [recognizer locationInView:recognizer.view];
        _itemCenterPoint = recognizer.view.center;
        [self bringSubviewToFront:recognizer.view];
        recognizer.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        recognizer.view.alpha = 0.8;
        
        for (int i = 0; i<self.dataArray.count ; i++) {
            XLImageView *tempImageView = (XLImageView *)[self viewWithTag:100 + i];
            if (tempImageView != recognizer.view) {
                tempImageView.canLongPress = NO;
            }
            else
            {
                tempImageView.canLongPress = YES;
            }
        }
        
        
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if (self.rankState) {
            self.rankState(RankViewStateMoveing);
        }
        CGPoint newPoint = [recognizer locationInView:recognizer.view];
        CGFloat deltaX = newPoint.x-_itemStartPoint.x;
        CGFloat deltaY = newPoint.y-_itemStartPoint.y;
        recognizer.view.center = CGPointMake(recognizer.view.center.x+deltaX,recognizer.view.center.y+deltaY);
        
        
        if (recognizer.view.center.y > _photoViewHeight) {
            _trashBtn.selected = YES;
             _trashBtn.backgroundColor = [MAIN_COLOR colorWithAlphaComponent:0.8];
            
        }
        else
        {
            _trashBtn.selected = NO;
             _trashBtn.backgroundColor = [MAIN_COLOR colorWithAlphaComponent:1];
        }
        
        [self throughView:(XLImageView *)recognizer.view];
        
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        XLImageView *imageView = (XLImageView *)recognizer.view;
         CGPoint endPoint = imageView.center;;
        if (endPoint.y >_photoViewHeight) {
            [self handleDelete:imageView];
        }
        else
        {
            _trashView.hidden = YES;
            _trashBtn.selected = NO;
            _trashBtn.hidden = YES;
            
            [self rankImageViewLocation:imageView];
        }
        
        for (int i = 0; i<self.dataArray.count ; i++) {
            XLImageView *tempImageView = (XLImageView *)[self viewWithTag:100 + i];
            tempImageView.canLongPress = YES;
        }
    }
}
/**
 *  开始删除
 *
 *  @param imageView 拖动控件
 */
-(void)handleDelete:(XLImageView *)imageView
{
    [UIView animateWithDuration:0.5 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        imageView.center = CGPointMake(GetWidth(self)/2, _photoViewHeight + 40 + 20);
    } completion:^(BOOL finished) {
        imageView.transform = CGAffineTransformMakeScale(1, 1);
        imageView.alpha = 1;
        _trashView.hidden = YES;
        _trashBtn.selected = NO;
        _trashBtn.hidden = YES;
        NSInteger index = imageView.tag - 100;
        
        [self.dataArray removeObjectAtIndex:index];
        
        if (self.deleteImage) {
            self.deleteImage(self.dataArray,index);
        }
        [self reloadWithArray:[NSArray arrayWithArray:self.dataArray] withContentOffSetString:nil];
        if (self.rankState) {
            self.rankState(RankViewStateEnded);
        }
    }];
    
    
}
-(void)throughView:(XLImageView *)imageView
{
    NSInteger index = imageView.tag - 100;
    
    CGPoint centerPoint = imageView.center;

    for (NSInteger i = 0; i<self.dataArray.count; i++) {
        XLImageView *tempImageView = (XLImageView *)[self viewWithTag:100 + i];
        if (index != i ) {
            if (centerPoint.x > GetOriginX(tempImageView) && centerPoint.x < GetMaxX(tempImageView) && centerPoint.y > GetOriginY(tempImageView) &&centerPoint.y < GetMaxY(tempImageView)) {
                tempImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            }
            else
            {
                tempImageView.transform = CGAffineTransformMakeScale(1, 1);
            }
        }
    }
}
-(void)rankImageViewLocation:(XLImageView *)imageView
{
    NSInteger index = imageView.tag - 100;
    
    CGPoint centerPoint = imageView.center;
    
    NSInteger locationIn = -1;
    
    for (NSInteger i = 0; i<self.dataArray.count; i++) {
        XLImageView *tempImageView = (XLImageView *)[self viewWithTag:100 + i];
        
        if (index != i ) {
            if (centerPoint.x > GetOriginX(tempImageView) && centerPoint.x < GetMaxX(tempImageView) && centerPoint.y > GetOriginY(tempImageView) &&centerPoint.y < GetMaxY(tempImageView)) {
                locationIn = i;
                break;
            }
        }
    }
    
    if (locationIn != -1) {
        XLImageView *tempImageView = (XLImageView *)[self viewWithTag:100 + locationIn];
        
        [UIView animateWithDuration:0.2 animations:^{
            imageView.transform = CGAffineTransformMakeScale(1, 1);
            tempImageView.transform = CGAffineTransformMakeScale(1, 1);
            imageView.alpha = 1;
            imageView.center = tempImageView.center;
            tempImageView.center = _itemCenterPoint;
        } completion:^(BOOL finished) {
            [self.dataArray exchangeObjectAtIndex:index withObjectAtIndex:locationIn];
            
            if (self.didRankImage) {
                self.didRankImage(self.dataArray,index,locationIn);
            }
            
            [self reloadWithArray:[NSArray arrayWithArray:self.dataArray] withContentOffSetString:nil];
            
            if (self.rankState) {
                self.rankState(RankViewStateEnded);
            }
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            imageView.transform = CGAffineTransformMakeScale(1, 1);
            imageView.center = _itemCenterPoint;
            imageView.alpha = 1;
        } completion:^(BOOL finished) {
            if (self.rankState) {
                self.rankState(RankViewStateEnded);
            }
        }];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.itemDraging) {
        self.itemDraging((XLImageView *)scrollView,scrollView.contentOffset);
    }
}
+(CGFloat)GetHeightOfRankView:(NSArray *)picArray
{
    CGFloat totalHeight = 0;
    CGFloat distance = 13;
    CGFloat gap = 5;
    switch (MIN(picArray.count, 9)) {
        case 1:
        {
            CGFloat anotherWidth = SCREENWIDTH - distance * 2;
           
            totalHeight = anotherWidth;
        }
            break;
        case 2:
        {
            CGFloat width = (SCREENWIDTH - distance *2 - gap)/2;
            
            totalHeight = width;
        }
            break;
        case 3:
        {
            CGFloat width = (SCREENWIDTH - distance * 2 - gap)/2;
            
            totalHeight = width + gap + width;
        }
            break;
        case 4:
        {
            CGFloat width = (SCREENWIDTH - distance *2 - gap)/2;
           
            totalHeight = width + gap + width;
        }
            break;
        case 5:
        {
            CGFloat width = (SCREENWIDTH - distance *2 - gap)/2;
            
            CGFloat anotherWidth = (SCREENWIDTH - distance * 2 - gap *2) / 3;
            
            totalHeight = width + gap + anotherWidth;
        }
            break;
        case 6:
        {
            CGFloat anotherWidth = (SCREENWIDTH - distance * 2 - gap *2) / 3;
            
            totalHeight = anotherWidth * 3 + 2* gap;
        }
            break;
        case 7:
        {
            CGFloat width = (SCREENWIDTH - distance *2 - gap)/2;
            CGFloat anotherWidth = (SCREENWIDTH - distance * 2 - gap *2) / 3;
            
            totalHeight = (width + gap) + (anotherWidth * 2 + gap);
        }
            break;
        case 8:
        {
            CGFloat width = (SCREENWIDTH - distance *2 - gap)/2;
            
            CGFloat anotherWidth = (SCREENWIDTH - distance * 2 - gap *2) / 3;
            
            totalHeight = (width + gap) + anotherWidth * 2 + gap;
        }
            break;
        case 9:
        {
            CGFloat anotherWidth = (SCREENWIDTH - distance * 2 - gap *2) / 3;
            totalHeight = anotherWidth * 3 + 2*gap;
        }
            break;
        default:
        {
            totalHeight = 0;
        }
            break;
    }
    return totalHeight;
}

-(NSArray *)GetReRankArray
{
    return self.dataArray;
}
@end
