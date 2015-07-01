//
//  YYSettingViewController.m
//  滚水音乐课堂
//
//  Created by lyan on 15/4/28.
//  Copyright (c) 2015年 com.longjianchuanmei. All rights reserved.
//

#import "YYSettingViewController.h"
#import "YYSettingTableViewCell.h"
#import "QQFindDetailController.h"
#import "YYChangePasswordViewController.h"
#import "DXAlertView.h"

@interface YYSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView*tableViewSetting;
    NSArray*arr;
    NSArray*arrPic;
    NSArray*files;
    NSString*str;
}
@end

@implementation YYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"YYSettingViewController");
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    arr=@[@[@"修改密码"],@[@"清除缓存",@"关于滚水"]];
//    arrPic=@[@[@"滚水网-发现1",@"滚水网-发现3"],@[@"滚水网-发现5",@"滚水网-发现6",@"滚水网-发现7",@"滚水网-发现8"]];
    
    //导航栏
    [self createNavigation];
    
    
    //tableView
    [self createTableView];
    
}


#pragma mark 退出

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIImageView*imageViewFooter=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 80)];
        imageViewFooter.userInteractionEnabled=YES;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]!=nil) {
            //退出按钮
            UIButton*btnExit=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_W-100)/2, 40, SCREEN_W-100, 35)];
            btnExit.center=CGPointMake(self.view.center.x, 40);
            btnExit.backgroundColor=[UIColor colorWithRed:93.0/255.0 green:174.0/255.0 blue:33.0/255.0 alpha:1];
            btnExit.layer.cornerRadius=5;
            [btnExit setTitle:@"退出登录" forState:0];
            btnExit.titleLabel.font=[UIFont fontWithName:FONTNAME size:18];
            [btnExit addTarget:self action:@selector(btnExit) forControlEvents:UIControlEventTouchUpInside];
            [imageViewFooter addSubview:btnExit];
            
            return imageViewFooter;
        }
    }
    return nil;
}

-(void)btnExit{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"status"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAgein" object:nil];
    [self btnBack];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"State" object:nil];
    
    
    
}

#pragma mark Navigation

-(void)createNavigation{
    self.title=@"设置";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    //设置导航栏文本的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    
    UIButton*btnLeft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btnLeft addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setImage:[UIImage imageNamed:@"返回按钮"] forState:0];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barLeft;
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    
}

-(void)btnBack{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Show_Tabbar" object:nil];
    
}

#pragma mark tableView

-(void)createTableView{
    tableViewSetting=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
    tableViewSetting.delegate=self;
    tableViewSetting.dataSource=self;
    [self.view addSubview:tableViewSetting];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0.001;
    }
    return 80;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ident=@"CELL";
    YYSettingTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[YYSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    

    cell.lableClass.text=[[arr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]!=nil) {
                YYChangePasswordViewController*changePassword=[[YYChangePasswordViewController alloc]init];
                [self.navigationController pushViewController:changePassword animated:YES];
            }else{
                [ProgressHUD showError:@"请登录，才可以修改密码"];
            }
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            dispatch_async(
                           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                               NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                               
                               files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                               //                           NSLog(@"files :%lu",(unsigned long)[files count]);
                               str=[NSString stringWithFormat:@"%@%lu%@",@"清理缓存文件:",(unsigned long)[files count],@"个"];
                               NSLog(@"====%@",str);
                               for (NSString *p in files) {
                                   NSError *error;
                                   NSString *path = [cachPath stringByAppendingPathComponent:p];
                                   if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                       [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                                       //清除SDwebImage的缓存图片
                                       [[SDImageCache sharedImageCache]clearDisk];
                                       [[SDImageCache sharedImageCache]clearMemory];
                                   }
                               }
                               [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                           });
        }else if (indexPath.row==1){
            QQFindDetailController*brandStory=[[QQFindDetailController alloc]init];
            
            [self.navigationController pushViewController:brandStory animated:YES];
        }
        
        
    }
}
-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
    
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"清理缓存" contentText:str leftButtonTitle:@"确定" rightButtonTitle:nil];
    [alert show];
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
