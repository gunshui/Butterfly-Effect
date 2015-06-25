//
//  QQMySelfViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/17.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQMySelfViewController.h"
#import "QQMyselfTableViewCell.h"
#import "QQRegisterViewController.h"

@interface QQMySelfViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIButton*btnRight;
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_Distance;
- (IBAction)btnLoginAction:(id)sender;
- (IBAction)btnRegisterAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMe;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left_Distance;

@end

@implementation QQMySelfViewController
@synthesize textFieldName,textFieldPassword,btnLogin,btnRegister,tableViewMe;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    btnLogin.layer.cornerRadius=5;
    btnLogin.layer.masksToBounds=YES;
    btnRegister.layer.cornerRadius=5;
    btnRegister.layer.masksToBounds=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    tableViewMe.hidden=YES;
    tableViewMe.contentInset=UIEdgeInsetsMake(0, 0, 55, 0);
//    UIView*viewHeader=[[[NSBundle mainBundle]loadNibNamed:@"HeaderTableView" owner:nil options:nil] lastObject];
//    tableViewMe.tableHeaderView=viewHeader;
//    tableViewMe.sectionHeaderHeight=50;
    
//    self.left_Distance.constant=SCREEN_W-120;
  }
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
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
          self.view.frame=KRect(0, -150, SCREEN_W, SCREEN_H+150);
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

- (IBAction)btnLoginAction:(id)sender {
    NSLog(@"login");
    [UIView animateWithDuration:0.5 animations:^{
        [textFieldPassword resignFirstResponder];
        [textFieldName resignFirstResponder];
        
        self.view.frame=KRect(0, 0, SCREEN_W, SCREEN_H);
        
        
    }];
    
    if ([textFieldName.text isEqualToString:@""]) {
        NSLog(@"用户名或者密码为空");
        [ProgressHUD showError: @"用户名为空"];
        
    }else if ([textFieldPassword.text isEqualToString:@""]){
        [ProgressHUD showError:@"密码为空"];
        
    }else{
        NSLog(@"都不空啦，，");
        
        [ProgressHUD show:@"loading..."];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString*body=[NSString stringWithFormat:@"action=v1&username=%@&password=%@",textFieldName.text,textFieldPassword.text];
            GetData*getData=[GetData getdataWithUrl:@"/user/login.php" Body:body];
//            NSLog(@"getData==%@",getData.dict);
            NSString*strStatus=[getData.dict objectForKey:@"status"];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [ProgressHUD dismiss];
                
                if ([strStatus isEqualToString:@"error1"]) {
                    UIAlertView*alertViewPrampt=[[UIAlertView alloc]initWithTitle:nil message:@"用户不存在" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertViewPrampt show];
                }
                else if ([strStatus isEqualToString:@"error2"]){
                    UIAlertView*alertViewPrampt=[[UIAlertView alloc]initWithTitle:nil message:@"密码错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertViewPrampt show];
                }
                else if ([strStatus isEqualToString:@"error3"]){
                    UIAlertView*alertViewPrampt=[[UIAlertView alloc]initWithTitle:nil message:@"登录失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertViewPrampt show];
                }
                else{
                    
                    
                    NSString*strMsg=[[getData.dict objectForKey:@"msg"] objectForKey:@"uid"];
                    NSString*strUrl=[NSString stringWithFormat:@"%@",[[getData.dict objectForKey:@"msg"] objectForKey:@"face"]];
                    
                    if ([strStatus isEqualToString:@"success"])
                    {
                        
                        [ProgressHUD dismiss];
                        //用户id
                        [[NSUserDefaults standardUserDefaults] setObject:strMsg forKey:@"ID"];
                        [[NSUserDefaults standardUserDefaults] setObject:strStatus forKey:@"status"];
                        [[NSUserDefaults standardUserDefaults] setObject:strUrl forKey:@"face"];
                        [[NSUserDefaults standardUserDefaults] setObject:textFieldName.text forKey:@"userName"];
                        [[NSUserDefaults standardUserDefaults] setObject:textFieldPassword.text forKey:@"userPassword"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                       //登录成功
                        [self loadSuccess];
                    }
                }
            });
        });
        
        
    }
    
    

}
-(void)loadSuccess{
  
//    tableViewMe.hidden=NO;
    [UIView animateWithDuration:3 animations:^{
        tableViewMe.hidden=NO;
        tableViewMe.alpha=0;
        tableViewMe.alpha=1;
        
    }];
}
- (IBAction)btnRegisterAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [textFieldPassword
         resignFirstResponder];
        [textFieldName resignFirstResponder];
        self.view.frame=KRect(0, 0, SCREEN_W, SCREEN_H);
    }];
    
    QQRegisterViewController*registerView=[[QQRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerView animated:YES];
    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*identifier=@"me";
    QQMyselfTableViewCell*cell=[tableViewMe dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"QQMyselfTableViewCell" owner:nil options:nil] lastObject];
        
    }
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*viewHeader=[[[NSBundle mainBundle]loadNibNamed:@"HeaderTableView" owner:nil options:nil] lastObject];
    return viewHeader;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 213;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
@end
