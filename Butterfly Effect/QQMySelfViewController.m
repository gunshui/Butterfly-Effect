//
//  QQMySelfViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/17.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQMySelfViewController.h"

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
    
//    UIView*viewHeader=[[[NSBundle mainBundle]loadNibNamed:@"HeaderTableView" owner:nil options:nil] lastObject];
//    tableViewMe.tableHeaderView=viewHeader;
//    tableViewMe.sectionHeaderHeight=50;
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

}

- (IBAction)btnRegisterAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [textFieldPassword
         resignFirstResponder];
        [textFieldName resignFirstResponder];
        self.view.frame=KRect(0, 0, SCREEN_W, SCREEN_H);
    }];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*identifier=@"me";
    UITableViewCell*cell=[tableViewMe dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
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

@end
