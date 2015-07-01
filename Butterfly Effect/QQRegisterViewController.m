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
@property (weak, nonatomic) IBOutlet UITextField *aTextField1;
@property (weak, nonatomic) IBOutlet UITextField *aTextField2;
@property (weak, nonatomic) IBOutlet UITextField *aTextField3;
@property (weak, nonatomic) IBOutlet UITextField *aTextField4;
- (IBAction)registerAction:(id)sender;

@end

@implementation QQRegisterViewController
@synthesize btnRegister,btnProtocol,aTextField1,aTextField2,aTextField3,aTextField4;
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
        [aTextField1 resignFirstResponder];
        [aTextField2 resignFirstResponder];
        [aTextField3 resignFirstResponder];
        [aTextField4 resignFirstResponder];
        
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


#pragma mark 注册
- (IBAction)registerAction:(id)sender {
    
    
        if ([aTextField1.text isEqualToString:@""]||[aTextField2.text isEqualToString:@""]||[aTextField3.text isEqualToString:@""]||[aTextField4.text isEqualToString:@""])
        {
            [ProgressHUD showError:@"注册信息不能为空"];
        }
        else if (aTextField2.text.length<6)
        {
            [ProgressHUD showError:@"请填写密码长度大于6个字符"];
        }
        else if (![aTextField3.text isEqualToString:aTextField2.text])
        {
            [ProgressHUD showError:@"两次密码不一致"];
        }
        else
        {
            [ProgressHUD show:@"loading..."];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString*body=[NSString stringWithFormat:@"action=v2&username=%@&password=%@&email=%@",aTextField1.text,aTextField2.text,aTextField4.text];
                GetData*getData=[GetData getdataWithUrl:@"/user/reg.php" Body:body];
                NSLog(@"我要注册----%@",getData.dict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString*strStatus=[getData.dict objectForKey:@"status"];
                    NSString*strMsg=[getData.dict objectForKey:@"msg"];
                    
                    if ([strStatus isEqualToString:@"error1"])
                    { [ProgressHUD showError:@"用户名含有不合法字符"];
                       
                    }
                    if ([strStatus isEqualToString:@"error2"])
                    {  [ProgressHUD showError:@"用户名包含不允许注册的词语"];
                       
                    }
                    if ([strStatus isEqualToString:@"error3"])
                    {
                        [ProgressHUD showError:@"用户名已经存在"];
                        
                    }
                    if ([strStatus isEqualToString:@"error4"])
                    {
                         [ProgressHUD showError:@"email格式有误"];
                      
                    }
                    if ([strStatus isEqualToString:@"error5"])
                    {
                        [ProgressHUD showError:@"该email不允许注册"];
                        
                    }
                    if ([strStatus isEqualToString:@"error6"])
                    {
                        [ProgressHUD showError:@"该email已经被注册"];
                       
                    }
                    if ([strStatus isEqualToString:@"error7"])
                    {
                        [ProgressHUD showError:@"注册失败"];
                        
                    }else{
                        if ([strStatus isEqualToString:@"success"])
                        {
                     
                            NSString*strUrl=[NSString stringWithFormat:@"%@",[[getData.dict objectForKey:@"msg"] objectForKey:@"face"]];
                            NSString*strCredits=[[getData.dict objectForKey:@"msg"]objectForKey:@"credits"];
                            NSString*strLevel=[[getData.dict objectForKey:@"msg"] objectForKey:@"usergroup"];
//                            NSLog(@"iiii-----dict6",strCredits,strLevel);
                            
                               NSString*bigFace=[[getData.dict objectForKey:@"msg"] objectForKey:@"face_big"];
                            
                            [ProgressHUD dismiss];
                            //用户id
                            [[NSUserDefaults standardUserDefaults] setObject:strMsg forKey:@"ID"];
                            [[NSUserDefaults standardUserDefaults] setObject:strStatus forKey:@"status"];
                            [[NSUserDefaults standardUserDefaults] setObject:strUrl forKey:@"face"];
                              [[NSUserDefaults standardUserDefaults]setObject:bigFace forKey:@"bigFace"];
                            [[NSUserDefaults standardUserDefaults] setObject:aTextField1.text forKey:@"userName"];
                            [[NSUserDefaults standardUserDefaults] setObject:aTextField2.text forKey:@"userPassword"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [[NSUserDefaults standardUserDefaults] setObject:strLevel forKey:@"level"];
                            [[NSUserDefaults standardUserDefaults] setObject:strCredits forKey:@"credits"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"State" object:nil];
                            

                            
                            
                        
                        }
                        
                    }
                });
            });
        }
    }



@end
