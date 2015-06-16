//
//  QQMeViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/8.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQMeViewController.h"

@interface QQMeViewController ()<UITextFieldDelegate>
{
    UIButton*btnRight;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAlphe;
@property (weak, nonatomic) IBOutlet UIButton *btnUserPic;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPic;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelIntegral;
@property (weak, nonatomic) IBOutlet UILabel *labelLevel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnRegistered;
@end

@implementation QQMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"QQMeViewController");
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"%f",SCREEN_W);
    
    //导航栏
    [self createNavigation];
    //个人信息数据
    [self userInfo];
    //登录注册页面
    [self loginAndRegistered];
    
    
}

#pragma mark-登录注册页面

-(void)loginAndRegistered{
    NSString*str=nil;
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"id"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"id"]==nil) {
        _imageViewLogin.hidden=NO;
        btnRight.hidden=YES;
        _btnLogin.backgroundColor=[UIColor colorWithRed:93.0/255.0 green:174.0/255.0 blue:33.0/255.0 alpha:1];
        _btnLogin.layer.cornerRadius=3;
        _textFieldUserName.delegate=self;
        _textFieldPassword.delegate=self;
        _textFieldUserName.returnKeyType=UIReturnKeyDone;
        NSLog(@"显示");
    }else{
        _imageViewLogin.hidden=YES;
        _imageViewLogo.hidden=YES;
        _textFieldUserName.hidden=YES;
        _textFieldPassword.hidden=YES;
        _btnLogin.hidden=YES;
        _btnForgetPassword.hidden=YES;
        _btnRegistered.hidden=YES;
        NSLog(@"隐藏");
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"beginEditing");
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0, -100, SCREEN_W, SCREEN_H);
    }];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"return");
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [_textFieldUserName resignFirstResponder];
        [_textFieldPassword resignFirstResponder];
    }];
    
    return YES;
}

#pragma mark-个人信息数据

-(void)userInfo{
    _imageViewAlphe.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [_imageViewPic setImage:KImage(@"首页2")];
    _imageViewPic.userInteractionEnabled=YES;
    _imageViewPic.layer.cornerRadius=5;
    _imageViewPic.layer.masksToBounds=YES;
    [_btnUserPic addTarget:self action:@selector(btnUserPicAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnUserPicAction{
    NSLog(@"换头像");
}

#pragma mark-导航栏

-(void)createNavigation{
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    //设置导航栏文本的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置
    btnRight=[[UIButton alloc]initWithFrame:KRect(0, 0, 40, 40)];
    [btnRight setImage:KImage(@"setting") forState:0];
    UIBarButtonItem*barRight=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barRight;
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
