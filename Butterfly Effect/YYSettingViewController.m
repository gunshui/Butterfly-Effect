//
//  YYSettingViewController.m
//  Butterfly Effect
//
//  Created by lyan on 15/6/9.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "YYSettingViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface YYSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray*arrKind;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewSetting;
@end

@implementation YYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"YYSettingViewController");
    // Do any additional setup after loading the view from its nib.
    
    //返回
    [self createBack];
    
    //数组
    [self createArray];
    
    //tableview
    [self createTableView];
}

#pragma mark-分类数组

-(void)createArray{
    arrKind=[NSArray arrayWithObjects:@"修改密码",@"关于", nil];
}

#pragma mark-TableView

-(void)createTableView{
    _tableViewSetting.delegate=self;
    _tableViewSetting.dataSource=self;
    [self.view addSubview:_tableViewSetting];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrKind count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ident=@"CELL";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.textLabel.text=[arrKind objectAtIndex:indexPath.row];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*viewBackground=[[[NSBundle mainBundle]loadNibNamed:@"View" owner:nil options:nil]lastObject];
    
    viewBackground.backgroundColor=[UIColor clearColor];
    UIButton*btnExit=(UIButton*)[[viewBackground subviews] objectAtIndex:0];
    btnExit.layer.cornerRadius=5;
    [btnExit addTarget:self action:@selector(btnExitAction) forControlEvents:UIControlEventTouchUpInside];
    return viewBackground;
}

-(void)btnExitAction{
    NSLog(@"退出退出");
}

#pragma mark-返回

-(void)createBack{
    UIButton*btnBack=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [btnBack setTitle:@"返回" forState:0];
    [btnBack setTitleColor:[UIColor blackColor] forState:0];
    [btnBack addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
}

-(void)btnBack{
    [self dismissViewControllerAnimated:NO completion:nil];
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
