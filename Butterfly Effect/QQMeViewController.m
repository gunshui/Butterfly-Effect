//
//  QQMeViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/8.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQMeViewController.h"
#import "MBTwitterScroll.h"
#import "YYSettingViewController.h"

@interface QQMeViewController ()<UITableViewDelegate, UITableViewDataSource, MBTwitterScrollDelegate>
{
    NSArray*arrKind;
}

@end

@implementation QQMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"QQMeViewController");
    // Do any additional setup after loading the view from its nib.
    
    //分类数组
    [self createArray];
    
    //效果方法
    [self createTopInfo];
}

#pragma mark-分类数组

-(void)createArray{
    arrKind=[NSArray arrayWithObjects:@"我的收藏",@"我的关注",@"我的提问", nil];
}

#pragma mark-效果方法

-(void)createTopInfo{
    MBTwitterScroll *myTableView = [[MBTwitterScroll alloc]
                                    initTableViewWithBackgound:[UIImage imageNamed:@"u=3823724296,3457142115&fm=21&gp=0.jpg"]
                                    avatarImage:[UIImage imageNamed:@"11.jpg"]
                                    titleString:@"滚水网管理员宣"
                                    subtitleString:@"积分:1200"
                                    buttonTitle:@"设置"];  // Set nil for no button
    
    myTableView.tableView.delegate = self;
    myTableView.tableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
}

//MBTwitterScrollDelegate
-(void) recievedMBTwitterScrollEvent {
    NSLog(@"你好________推送页面");
    YYSettingViewController*setting=[[YYSettingViewController alloc]init];
    [self presentViewController:setting animated:NO completion:nil];
}

- (void) recievedMBTwitterScrollButtonClicked {
    YYSettingViewController*setting=[[YYSettingViewController alloc]init];
    [self presentViewController:setting animated:NO completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrKind count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text =[arrKind objectAtIndex:indexPath.row];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
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
