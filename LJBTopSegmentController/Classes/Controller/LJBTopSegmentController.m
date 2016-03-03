//
//  LJBTopSegmentController.m
//  LJBTopSegmentController
//
//  Created by CookieJ on 16/3/3.
//  Copyright © 2016年 ljunb. All rights reserved.
//

#import "LJBTopSegmentController.h"
#import "UIView+LJBExtension.h"
#import "LJBContentController.h"

#define LJBScreenSize [UIScreen mainScreen].bounds.size
#define TopTitleFont [UIFont systemFontOfSize:15]

@interface LJBTopSegmentController () < UIScrollViewDelegate >
/**
 *  顶部滚动视图
 */
@property (nonatomic, strong) UIScrollView * topMenuScrollView;
/**
 *  顶部菜单数组
 */
@property (nonatomic, copy) NSArray * titles;
/**
 *  底部指示器
 */
@property (nonatomic, strong) UIView * indicatorView;
/**
 *  当前选中按钮
 */
@property (nonatomic, strong) UIButton * selectedBtn;
/**
 *  内容滚动视图
 */
@property (nonatomic, strong) UIScrollView * contentScrollView;

@end


static CGFloat const kTopTitleViewHeight = 43;  // 顶部标题高度
static CGFloat const kTitleMargin = 15;         // 标题两边间距
static CGFloat const kIndicatorViewHeight = 3;  // 指示器高度

@implementation LJBTopSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseConfig];
    
    [self setupAllChildControllers];
    
    [self setupTopMenuScrollView];
    
    [self setupContentScrollView];
    
}

#pragma mark - 基础配置
- (void)baseConfig {
    
    self.title = @"简易多菜单控制器";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - 顶部菜单滚动视图
- (void)setupTopMenuScrollView {
    
    // 记录标题数组总宽度
    CGFloat totalWidth = 0;
    
    // 添加标题数组
    for (NSInteger index = 0; index < self.titles.count; index++) {
        
        // 按钮长度
        CGFloat titleWidth = [self widthWithTitle:self.titles[index]];
        
        UIButton * titleBtn = [[UIButton alloc] init];
        titleBtn.frame = CGRectMake(totalWidth, 0, titleWidth, kTopTitleViewHeight);
        titleBtn.titleLabel.font = TopTitleFont;
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        [titleBtn setTitle:self.titles[index] forState:UIControlStateNormal];
        [titleBtn setTitle:self.titles[index] forState:UIControlStateDisabled];
        [titleBtn addTarget:self action:@selector(didClickTitle:) forControlEvents:UIControlEventTouchUpInside];
        [self.topMenuScrollView addSubview:titleBtn];
        
        // 总宽度
        totalWidth += titleWidth;
        
        // 默认指示器位置
        if (index == 0) {
            
            // 当前按钮不可点击
            self.selectedBtn = titleBtn;
            self.selectedBtn.enabled = NO;
            
            // 指示器宽度&中心位置
            [titleBtn.titleLabel sizeToFit];
            self.indicatorView.width = titleBtn.titleLabel.width;
            self.indicatorView.centerX = titleBtn.centerX;
        }
    }

    // 添加指示器
    [self.topMenuScrollView addSubview:self.indicatorView];
    
    // 可滚动范围
    self.topMenuScrollView.contentSize = CGSizeMake(totalWidth, 1);
}

- (void)setupContentScrollView {
    
    self.contentScrollView.contentSize = CGSizeMake(LJBScreenSize.width * self.titles.count, 0);
    
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

#pragma mark - 添加所有子控制器
- (void)setupAllChildControllers {
    
    for (NSInteger index = 0; index < self.titles.count; index++) {
        
        LJBContentController * contentVC = [LJBContentController new];
        [self addChildViewController:contentVC];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView == self.topMenuScrollView) return;
        
    NSInteger index = scrollView.contentOffset.x / LJBScreenSize.width;
    
    UIViewController * viewController = self.childViewControllers[index];
    
    viewController.view.frame = CGRectMake(LJBScreenSize.width * index,
                                           0,
                                           LJBScreenSize.width,
                                           self.contentScrollView.height);
    
    [scrollView addSubview:viewController.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.topMenuScrollView)  return;
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self didClickTitle:self.topMenuScrollView.subviews[index]];
    
    // 手动拖拽时，显式调用代理方法
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    
}


#pragma mark - 按钮点击事件
- (void)didClickTitle:(UIButton *)titleBtn {
    
    // 切换当前按钮
    self.selectedBtn.enabled = YES;
    self.selectedBtn = titleBtn;
    self.selectedBtn.enabled = NO;
    
    // 指示器位移动画
    [UIView animateWithDuration:0.35 animations:^{
        self.indicatorView.width = titleBtn.titleLabel.width;
        self.indicatorView.centerX = titleBtn.centerX;
    }];
    
    // 子控制器偏移
    NSInteger index = [self.titles indexOfObject:titleBtn.currentTitle];
    [self.contentScrollView setContentOffset:CGPointMake(LJBScreenSize.width * index, 0) animated:YES];
    
    [self.topMenuScrollView scrollRectToVisible:titleBtn.frame animated:YES];
    
}

#pragma mark - 标题按钮长度-文字长度+10*2
- (CGFloat)widthWithTitle:(NSString *)title {
    return [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                               options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{
                                         NSFontAttributeName : TopTitleFont
                                         }
                               context:nil].size.width + kTitleMargin * 2;
}


#pragma mark - Getter
- (NSArray *)titles {
    
    if (!_titles) {
        _titles = @[@"全部", @"新闻", @"娱乐", @"热点", @"体育", @"轻松一刻", @"云课堂", @"国际新闻", @"家居"];
    }
    return _titles;
}


- (UIScrollView *)topMenuScrollView {
    
    if (!_topMenuScrollView) {
        _topMenuScrollView = [UIScrollView new];
        _topMenuScrollView.delegate = self;
        _topMenuScrollView.backgroundColor = [UIColor orangeColor];
        _topMenuScrollView.frame = CGRectMake(0, 0, LJBScreenSize.width, kTopTitleViewHeight);
        _topMenuScrollView.showsHorizontalScrollIndicator = NO;
        _topMenuScrollView.bounces = NO;
        [self.view addSubview:_topMenuScrollView];
    }
    return _topMenuScrollView;
}

- (UIView *)indicatorView {
    
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = [UIColor redColor];
        _indicatorView.frame = CGRectMake(0, kTopTitleViewHeight - kIndicatorViewHeight, 0, kIndicatorViewHeight);
    }
    return _indicatorView;
}

- (UIScrollView *)contentScrollView {
    
    if (!_contentScrollView) {
        _contentScrollView = [UIScrollView new];
        _contentScrollView.frame = CGRectMake(0, kTopTitleViewHeight, LJBScreenSize.width, LJBScreenSize.height - kTopTitleViewHeight - 64);
        _contentScrollView.delegate = self;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.pagingEnabled = YES;
        [self.view addSubview:_contentScrollView];
    }
    return _contentScrollView;
}

@end
