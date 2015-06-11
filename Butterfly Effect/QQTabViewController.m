//
//  QQTabViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/5.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQTabViewController.h"
#define TABBAR_H 58
@interface QQTabViewController ()
{
    UIImageView*imageViewTabBar;
    UIButton*btnHome;
    UILabel*labelHome;
    UIImageView*imageViewHome;
    
    UIButton*btnClass;
    UILabel*labelClass;
    UIImageView*imageViewClass;
    
    UIButton*btnShow;
    UILabel*labelShow;
    UIImageView*imageViewShow;
    
    UIButton*btnMe;
    UILabel*labelMe;
    UIImageView*imageViewMe;
    
}
@end

@implementation QQTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBar.hidden=YES;
    imageViewTabBar=[[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_H-TABBAR_H, SCREEN_W, TABBAR_H)];
    //    imageViewTabBar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    imageViewTabBar.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    imageViewTabBar.userInteractionEnabled=YES;
    [self.view addSubview:imageViewTabBar];
    //首页
    btnHome=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/4, TABBAR_H)];
    btnHome.tag=1000;
    [btnHome addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageViewTabBar addSubview:btnHome];
   
    imageViewHome=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W/6-12.5, 5, TABBAR_H/2, TABBAR_H/2)];
    imageViewHome.center=CGPointMake(btnHome.frame.size.width/2, 20);
    imageViewHome.image=[UIImage imageNamed:@"首页2-恢复的(red)"];
    [btnHome addSubview:imageViewHome];
    //
    labelHome=[[UILabel alloc]initWithFrame:CGRectMake(0, 35, SCREEN_W/4, 20)];
    labelHome.text=@"首页";
    labelHome.textAlignment=NSTextAlignmentCenter;
    labelHome.font=[UIFont fontWithName:FONTNAME3 size:10];
    labelHome.textColor=[UIColor redColor];
//    labelHome.backgroundColor=[UIColor magentaColor];
    [btnHome addSubview:labelHome];
    
    //品牌会
    btnClass=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/4, 0, SCREEN_W/4, TABBAR_H)];
    btnClass.tag=1001;
    [btnClass addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageViewTabBar addSubview:btnClass];
    
    
    imageViewClass=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W/6-12.5, 5, TABBAR_H/2, TABBAR_H/2)];
    imageViewClass.image=[UIImage imageNamed:@"首页2-品牌"];
    imageViewClass.center=CGPointMake(btnClass.frame.size.width/2, 20);
    [btnClass addSubview:imageViewClass];
    
    //
    labelClass=[[UILabel alloc]initWithFrame:CGRectMake(0, 35, SCREEN_W/4, 20)];
    labelClass.text=@"品牌荟";
    labelClass.textAlignment=NSTextAlignmentCenter;
    labelClass.font=[UIFont fontWithName:FONTNAME3 size:10];
    labelClass.textColor=[UIColor blackColor];
    [btnClass addSubview:labelClass];
    
    //秀场
    btnShow=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/2, 0, SCREEN_W/4, TABBAR_H)];
    btnShow.tag=1002;
    [btnShow addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageViewTabBar addSubview:btnShow];
    
    imageViewShow=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W/6-12.5, 5, TABBAR_H/2, TABBAR_H/2)];
    imageViewShow.image=[UIImage imageNamed:@"首页2-广场"];
    imageViewShow.center=CGPointMake(btnShow.frame.size.width/2, 20);
    [btnShow addSubview:imageViewShow];
    
    //
    labelShow=[[UILabel alloc]initWithFrame:CGRectMake(0, 35, SCREEN_W/4, 20)];
    labelShow.text=@"秀场";
    labelShow.textAlignment=NSTextAlignmentCenter;
    labelShow.font=[UIFont fontWithName:FONTNAME3 size:10];
    labelShow.textColor=[UIColor blackColor];
    [btnShow addSubview:labelShow];
    
    
    
    //秀场
    btnMe=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/4*3, 0, SCREEN_W/4, TABBAR_H)];
    btnMe.tag=1003;
    [btnMe addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageViewTabBar addSubview:btnMe];
    
    imageViewMe=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W/6-12.5, 5, TABBAR_H/2, TABBAR_H/2)];
    imageViewMe.image=[UIImage imageNamed:@"首页2-个人中心"];
    imageViewMe.center=CGPointMake(btnShow.frame.size.width/2, 20);
    [btnMe addSubview:imageViewMe];
    
    //
    labelMe=[[UILabel alloc]initWithFrame:CGRectMake(0, 35, SCREEN_W/4, 20)];
    labelMe.text=@"个人中心";
    labelMe.textAlignment=NSTextAlignmentCenter;
    labelMe.font=[UIFont fontWithName:FONTNAME3 size:10];
    labelMe.textColor=[UIColor blackColor];
    [btnMe addSubview:labelMe];

    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenAction) name:@"hidden" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAction) name:@"show" object:nil];
//    self.selectedIndex=1;


}
-(void)btnAction:(UIButton*)sender{
  
    self.selectedIndex=sender.tag-1000;
    
    CABasicAnimation*animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue=[NSNumber numberWithFloat:-0.1];
    animation.toValue=[NSNumber numberWithFloat:+0.1];
    animation.duration=0.1;
    animation.repeatCount=3;
    animation.autoreverses=YES;
    [sender.layer addAnimation:animation forKey:@"doudong"];
    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
    if (self.selectedIndex==0) {
        labelHome.textColor=[UIColor redColor];
        labelMe.textColor=[UIColor blackColor];
        labelShow.textColor=[UIColor blackColor];
        labelClass.textColor=[UIColor blackColor];
        
        imageViewHome.image=KImage(@"首页2-恢复的(red)");
        imageViewClass.image=KImage(@"首页2-品牌");
        imageViewShow.image=KImage(@"首页2-广场");
        imageViewMe.image=KImage(@"首页2-个人中心");
        
        
        
    }else if (self.selectedIndex==1){
        labelHome.textColor=[UIColor blackColor];
        labelMe.textColor=[UIColor blackColor];
        labelShow.textColor=[UIColor blackColor];
        labelClass.textColor=[UIColor redColor];
        
        imageViewHome.image=KImage(@"首页图标");
        imageViewClass.image=KImage(@"首页2 品牌会(red)");
        imageViewShow.image=KImage(@"首页2-广场");
        imageViewMe.image=KImage(@"首页2-个人中心");
    }else if (self.selectedIndex==2){
        labelHome.textColor=[UIColor blackColor];
        labelMe.textColor=[UIColor blackColor];
        labelShow.textColor=[UIColor redColor];
        labelClass.textColor=[UIColor blackColor];
        
        imageViewHome.image=KImage(@"首页图标");
        imageViewClass.image=KImage(@"首页2-品牌");
        imageViewShow.image=KImage(@"首页2-广场（red）");
        imageViewMe.image=KImage(@"首页2-个人中心");
    }else{
        labelHome.textColor=[UIColor blackColor];
        labelMe.textColor=[UIColor redColor];
        labelShow.textColor=[UIColor blackColor];
        labelClass.textColor=[UIColor blackColor];
        
        imageViewHome.image=KImage(@"首页图标");
        imageViewClass.image=KImage(@"首页2-品牌");
        imageViewShow.image=KImage(@"首页2-广场");
        imageViewMe.image=KImage(@"首页2-个人中心（red）");
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
