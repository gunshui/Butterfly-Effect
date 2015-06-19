//
//  QQRegisterViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/19.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQRegisterViewController.h"

@interface QQRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnProtocol;
@property (weak, nonatomic) IBOutlet UITextField *textFiewName;
@property (weak, nonatomic) IBOutlet UITextField *textFiewPassWord;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassWDAgain;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;

@end

@implementation QQRegisterViewController
@synthesize btnRegister,btnProtocol,textFieldEmail,textFieldPassWDAgain,textFiewName,textFiewPassWord;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createLeftBar_Back];
    self.title=@"注册";
    btnRegister.layer.cornerRadius=5;
    btnRegister.titleLabel.font=[UIFont fontWithName:FONTNAME3 size:17];
    btnProtocol.titleLabel.font=[UIFont fontWithName:FONTNAME size:14];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
    
    
}
-(void)tapAction{
    [UIView animateWithDuration:0.5 animations:^{
        [textFiewName resignFirstResponder];
        [textFiewPassWord resignFirstResponder];
        [textFieldPassWDAgain resignFirstResponder];
        [textFieldEmail resignFirstResponder];
        
        self.view.frame=KRect(0, 0, SCREEN_W, SCREEN_H);
    }];
   
}
-(void)createNavigation{
    
    
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
//    //设置导航栏文本的颜色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

-(void)createLeftBar_Back{
    //返回
    UIButton*backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮"] forState:0];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*bar=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=bar;
}
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=KRect(0, -50, SCREEN_W, SCREEN_H+50);
    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
        [textField resignFirstResponder];
        
        self.view.frame=KRect(0, 0, SCREEN_W, SCREEN_H);
    }];
    
    
    return YES;
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
