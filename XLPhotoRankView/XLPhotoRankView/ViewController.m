//
//  ViewController.m
//  XLPhotoRankView
//
//  Created by 谢乐乐 on 2017/5/8.
//  Copyright © 2017年 xll. All rights reserved.
//

#import "ViewController.h"
#import "XLPhotoRankView.h"
@interface ViewController ()

@property(nonatomic,strong)XLPhotoRankView *rankView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    [array addObject:[UIImage imageNamed:@"a.jpeg"]];
    [array addObject:[UIImage imageNamed:@"b.jpeg"]];
    [array addObject:[UIImage imageNamed:@"c.jpeg"]];
    [array addObject:[UIImage imageNamed:@"d.jpeg"]];
    [array addObject:[UIImage imageNamed:@"e.jpeg"]];
    [array addObject:[UIImage imageNamed:@"f.jpeg"]];
    
    __weak typeof(self)weakSelf = self;
    _rankView = [[XLPhotoRankView alloc]initWithFrame:CGRectMake(0, 30, SCREENWIDTH, 0)];
    _rankView.itemDragEnable = YES;
    _rankView.isNetImage = NO;
    _rankView.rankViewHeightChanged =^(CGFloat height)
    {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.rankView.frame = CGRectMake(0, 30, SCREENWIDTH, height);
    };
    _rankView.deleteImage = ^(NSArray *remainArray,NSInteger deleteTag)
    {
        
    };
    _rankView.didRankImage = ^(NSArray *rankedArray,NSInteger originImageTag,NSInteger nowImageTag)
    {
        
    };
    _rankView.rankState = ^(RankViewState state)
    {
       
    };
    _rankView.itemDraging = ^(XLImageView *imageView,CGPoint contentOffset)
    {
       
    };
    _rankView.clickImage = ^(XLImageView *imageView)
    {
        
    };
    _rankView.moveEnable = YES;
    [self.view addSubview:_rankView];
    
    
    [self.rankView reloadWithArray:array withContentOffSetString:nil];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
