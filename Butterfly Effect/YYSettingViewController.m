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
    UITableView*tableViewSetting=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64) style:UITableViewStyleGrouped];
    tableViewSetting.delegate=self;
    tableViewSetting.dataSource=self;
    [self.view addSubview:tableViewSetting];
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
    UIImageView*imageViewBackground=[[UIImageView alloc]init];
    imageViewBackground.userInteractionEnabled=YES;
    
    UIButton*btnExit=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*2/7, 80, SCREEN_W*3/7, 40)];
    btnExit.backgroundColor=[UIColor lightGrayColor];
    btnExit.layer.cornerRadius=5;
    [btnExit setTitle:@"退出登录" forState:0];
    [btnExit addTarget:self action:@selector(btnExit:) forControlEvents:UIControlEventTouchUpInside];
    [imageViewBackground addSubview:btnExit];
    
    return imageViewBackground;
}

-(void)btnExit:(UIButton*)sender{
    NSLog(@"退出退出");
    //控件抖动
    CABasicAnimation*animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue=[NSNumber numberWithFloat:-0.1];
    animation.toValue=[NSNumber numberWithFloat:+0.1];
    animation.duration=0.1;
    animation.repeatCount=3;
    animation.autoreverses=YES;
    [sender.layer addAnimation:animation forKey:@"doudong"];
     [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];

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
