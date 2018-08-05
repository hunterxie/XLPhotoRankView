# XLPhotoRankView
一个九宫格展示效果
------
```
typedef NS_ENUM(NSInteger, RankViewState) {
    RankViewStateStartBegan,
    RankViewStateMoveing,
    RankViewStateEnded,
};


@interface XLPhotoRankView : UIView


@property(nonatomic,assign)BOOL moveEnable;//是否开启拖动调整顺序

@property(nonatomic,assign)BOOL itemDragEnable;//每个item 是否可以内部调整显示

@property(nonatomic,copy)void(^itemDraging)(XLImageView *imageView,CGPoint contentOffset);//正在调整某个item内部显示  每拖动一下 就传出来一下

@property(nonatomic,copy)void (^rankViewHeightChanged)(CGFloat height);//替换图片数组后 得到显示高度

@property(nonatomic,copy)void(^clickImage)(XLImageView *imageView);//点击图片

@property(nonatomic,copy)void(^deleteImage)(NSArray *remainArray,NSInteger deleteTag);//删除图片后返回剩余图片数组和被删除的图片tag
/**
 *  排序后返回排序后数组 以及排序前拖动的图tag  已经排后图片tag
 */
@property(nonatomic,copy)void(^didRankImage)(NSArray *rankedArray,NSInteger originImageTag,NSInteger nowImageTag);

@property(nonatomic,copy)void(^rankState)(RankViewState state);//排序的状态

@property(nonatomic,assign)BOOL isNetImage;//是否是网络图片  

-(CGFloat)reloadWithArray:(NSArray *)array withContentOffSetString:(NSString *)offSetString;//刷新UI

/**
 *  获取图片偏移量数组的json 字符串
 */
-(NSString *)GetContentOffSetArrayString;

+(CGFloat)GetHeightOfRankView:(NSArray *)picArray;//获取图片高度

-(NSArray *)GetReRankArray;//获取排序后的图片数组
@end
```

<br>
![Image text](https://raw.githubusercontent.com/hunterxie/XLPhotoRankView/master/aa.gif)
