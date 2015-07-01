//
//  QQFindDetailController.m
//  Gunshui
//
//  Created by digime on 15/3/24.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQFindDetailController.h"

@interface QQFindDetailController ()<UIGestureRecognizerDelegate,UIWebViewDelegate>
{
    UIActivityIndicatorView*indicator;
}
@end

@implementation QQFindDetailController
@synthesize numClass;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
   
    [self creataWebViews];
    
}
-(void)createActivity{
    
    indicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    indicator.center=self.view.center;
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
}
-(void)creataWebViews{
    
    UIWebView*webViews=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64)];
    webViews.backgroundColor=[UIColor clearColor];
    [self.view addSubview:webViews];
    
    [self createActivity];
    NSString*webStr;
    
    
    self.title=@"关于滚水";
    webStr=@"http://www.gunshui.com.cn/web/m/about_app/about.php";
    
    
    NSURLRequest*request=[NSURLRequest requestWithURL:[NSURL URLWithString:webStr]];
    [webViews loadRequest:request];
    
    webViews.scalesPageToFit=YES;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)createNavigation{
    UIImageView*imageBackground=[[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:imageBackground];
    imageBackground.userInteractionEnabled=YES;
    imageBackground.image=[UIImage imageNamed:@"滚水网-首页（导航）背景图片"];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 65, SCREEN_W, 20)];
    label.text=@"滚水网  www.imus.cn";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont fontWithName:FONTNAME size:10];
    [self.view addSubview:label];
    
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"滚水网-首页bantouming"] forBarMetrics:UIBarMetricsDefault];
    UIButton*left=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [left addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [left setImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem=barLeft;
    //右拉手势
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
}

-(void)backAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
