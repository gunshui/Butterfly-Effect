//
//  YYChangePasswordViewController.m
//  滚水音乐课堂
//
//  Created by lyan on 15/4/29.
//  Copyright (c) 2015年 com.longjianchuanmei. All rights reserved.
//

#import "YYChangePasswordViewController.h"

@interface YYChangePasswordViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    NSArray*arrChangeName;
    UITextField*textField1;
    UITextField*textField2;
    UITextField*textField3;
}
@end

@implementation YYChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1];
    arrChangeName=@[@"旧密码",@"新密码",@"确认新密码"];
    //导航栏
    [self createNavigation];
    
    //修改密码界面
    [self createView];
    
    [self creataSure];
}

-(void)creataSure{
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(textField3.frame)+20, SCREEN_W-80, 35)];
    [btn setTitle:@"确认修改" forState:UIControlStateNormal];
    btn.layer.cornerRadius=5;
    btn.backgroundColor=[UIColor colorWithRed:93.0/255.0 green:174.0/255.0 blue:33.0/255.0 alpha:1];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)btnAction{
    NSLog(@"发送请求");
    if ([textField2.text isEqualToString:@""]||[textField3.text isEqualToString:@""]||![textField2.text isEqualToString:textField3.text]) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"确认密码输入不正确" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString*strBody=[NSString stringWithFormat:@"action=resetpwd&username=%@&oldpwd=%@&newpwd=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],textField1.text,textField2.text];
            GetData*getData=[GetData getdataWithGUNSHUIUrl:@"/app/v1.php" Body:strBody];
            NSDictionary*dict=getData.dict;
            NSLog(@"=111=%@",dict);
        dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dict objectForKey:@"status"] isEqualToString:@"success"]) {
                    [ProgressHUD showSuccess:@"修改成功"];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:textField2.text forKey: @"userPassword"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

              [self.navigationController popToRootViewControllerAnimated:YES];
                }
            });
        });
    }
}

#pragma mark 修改密码界面

-(void)createView{
    
    //当前密码
    UILabel*label1=[[UILabel alloc]initWithFrame:CGRectMake(15, 84, SCREEN_W/5, 40)];
    label1.backgroundColor=[UIColor whiteColor];
    label1.layer.cornerRadius=3;
    label1.layer.masksToBounds=YES;
    label1.text=@"当前密码";
    label1.textAlignment=NSTextAlignmentCenter;
    label1.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    label1.font=[UIFont fontWithName:FONTNAME size:13];
    [self.view addSubview:label1];
    
    textField1=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+10, 84, SCREEN_W*2/3, 40)];
    textField1.backgroundColor=[UIColor whiteColor];
    textField1.layer.cornerRadius=3;
    textField1.delegate=self;
    textField1.secureTextEntry=YES;
    [self.view addSubview:textField1];
    
    //新密码
    UILabel*label2=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(label1.frame)+10, SCREEN_W/5, 40)];
    label2.backgroundColor=[UIColor whiteColor];
    label2.layer.cornerRadius=3;
    label2.layer.masksToBounds=YES;
    label2.text=@"新密码";
    label2.textAlignment=NSTextAlignmentCenter;
    label2.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    label2.font=[UIFont fontWithName:FONTNAME size:13];
    [self.view addSubview:label2];
    
    textField2=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame)+10, CGRectGetMaxY(label1.frame)+10, SCREEN_W*2/3, 40)];
    textField2.backgroundColor=[UIColor whiteColor];
    textField2.layer.cornerRadius=3;
    textField2.delegate=self;
    textField2.secureTextEntry=YES;
    [self.view addSubview:textField2];
    
    //确认密码
    UILabel*label3=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(label2.frame)+10, SCREEN_W/5, 40)];
    label3.backgroundColor=[UIColor whiteColor];
    label3.layer.cornerRadius=3;
    label3.layer.masksToBounds=YES;
    label3.text=@"确认密码";
    label3.textAlignment=NSTextAlignmentCenter;
    label3.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    label3.font=[UIFont fontWithName:FONTNAME size:13];
    [self.view addSubview:label3];
    
    textField3=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame)+10, CGRectGetMaxY(label2.frame)+10, SCREEN_W*2/3, 40)];
    textField3.backgroundColor=[UIColor whiteColor];
    textField3.layer.cornerRadius=3;
    textField3.delegate=self;
    textField3.secureTextEntry=YES;
    [self.view addSubview:textField3];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==textField1)
    {
        if (![textField1.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"]])
        {
            [ProgressHUD showError:@"旧密码不正确"];
        }
        if ([textField1.text isEqualToString: @""]) {
            [ProgressHUD showError:@"当前密码不能为空"];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
    [textField3 resignFirstResponder];
    
    return YES;
}

#pragma mark Navigation

-(void)createNavigation{
    self.title=@"修改密码";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    UIButton*btnLeft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btnLeft addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setImage:[UIImage imageNamed:@"返回按钮"] forState:0];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barLeft;
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
}

-(void)btnBack{
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
