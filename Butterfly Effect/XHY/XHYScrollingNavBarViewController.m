//
//  XHYScrollingNavBarViewController.m
//  XHYScrollingNavBarViewController
//
//  Created by smm_imac on 14-3-7.
//  Copyright (c) 2014年 XHY. All rights reserved.
//

#import "XHYScrollingNavBarViewController.h"
#define NavBarFrame self.navigationController.navigationBar.frame

@interface XHYScrollingNavBarViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView *scrollView;
@property (retain, nonatomic)UIPanGestureRecognizer *panGesture;
@property (retain, nonatomic)UIView *overLay;
@property (assign, nonatomic)BOOL isHidden;

@end

@implementation XHYScrollingNavBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        if (IOS7) {
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//            self.automaticallyAdjustsScrollViewInsets=NO;
//        }
    }
    return self;
}

//设置跟随滚动的滑动试图
-(void)followRollingScrollView:(UIView *)scrollView
{
    self.scrollView = scrollView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] init];
    self.panGesture.delegate=self;
    self.panGesture.minimumNumberOfTouches = 1;
    [self.panGesture addTarget:self action:@selector(handlePanGesture:)];
    [self.scrollView addGestureRecognizer:self.panGesture];
    
    self.overLay = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
//    NSLog(@"frame==%@",NSStringFromCGRect(self.overLay.frame));
    self.overLay.alpha=0;
    self.overLay.backgroundColor=self.navigationController.navigationBar.barTintColor;
    [self.navigationController.navigationBar addSubview:self.overLay];
    //bringSubviewToFront（）方法可以将指定的视图推送到前面，而 sendSubviewToBack()则可以将指定的视图推送到背面。
    [self.navigationController.navigationBar bringSubviewToFront:self.overLay];
}

#pragma mark - 兼容其他手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - 手势调用函数
-(void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:[self.scrollView superview]];
    
//    NSLog(@"point==%f",translation.y);
//    CGFloat detai = self.lastContentset - translation.y;
    //显示
    if (translation.y >= 5) {
        if (self.isHidden) {
            [self.overLay setHidden:YES];
            self.overLay.alpha=0;
            CGRect navBarFrame=NavBarFrame;
            CGRect scrollViewFrame=self.scrollView.frame;
            
            navBarFrame.origin.y = 20;
            scrollViewFrame.origin.y += 44;
            scrollViewFrame.size.height -= 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = navBarFrame;
                self.scrollView.frame=scrollViewFrame;
//                if ([self.scrollView isKindOfClass:[UIScrollView class]]) {
//                    UIScrollView *scrollView=(UIScrollView *)self.scrollView;
//                    scrollView.contentOffset=CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+44);
//                }else if ([self.scrollView isKindOfClass:[UIWebView class]]){
//                    UIWebView *webView=(UIWebView *)self.scrollView;
//                    webView.scrollView.contentOffset=CGPointMake(webView.scrollView.contentOffset.x, webView.scrollView.contentOffset.y+44);
//                }
            }];
            self.isHidden= NO;
        }
    }
    
    //隐藏
    if (translation.y <= -20) {
        if (!self.isHidden) {
           

            CGRect frame =NavBarFrame;
            CGRect scrollViewFrame=self.scrollView.frame;
            frame.origin.y = -24;
            scrollViewFrame.origin.y -= 44;
            scrollViewFrame.size.height += 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = frame;
                
                self.scrollView.frame=scrollViewFrame;
//                if ([self.scrollView isKindOfClass:[UIScrollView class]]) {
//                    UIScrollView *scrollView=(UIScrollView *)self.scrollView;
//                    scrollView.contentOffset=CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y-44);
//                }else if ([self.scrollView isKindOfClass:[UIWebView class]]){
//                    UIWebView *webView=(UIWebView *)self.scrollView;
//                    webView.scrollView.contentOffset=CGPointMake(webView.scrollView.contentOffset.x, webView.scrollView.contentOffset.y-44);
//                }
            } completion:^(BOOL finished) {
                 [self.overLay setHidden:NO];
                self.overLay.alpha=1;
            }];
            self.isHidden=YES;
        }
    }
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    
    self.overLay.alpha=0;
}
-(void)changeActon{
//     NSLog(@"changeAction");
    [self.overLay setHidden:YES];
//    [self.overLay removeFromSuperview];
    CGRect frame =NavBarFrame;
    frame.origin.y = 20;
    NavBarFrame=frame;
    self.isHidden=NO;
    
    }
-(void)viewDidAppear:(BOOL)animated{
    //    self.overLay.alpha=0;
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar bringSubviewToFront:self.overLay];
//    [self.navigationController.navigationBar sendSubviewToBack:self.overLay];

}

@end
