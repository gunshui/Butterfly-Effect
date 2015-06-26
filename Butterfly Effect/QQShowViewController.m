//
//  QQShowViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/8.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQShowViewController.h"
#import "YYShowDetailsViewController.h"
#import "QQShowTableViewCell.h"

@interface QQShowViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary*dict;
    int maxSize;
    int totalNums;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewShow;

@end

@implementation QQShowViewController
@synthesize tableViewShow;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    maxSize=10;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self createNavigation];
    
    [self createTableView];
    
    //请求数据
    [self createRequest];
}

#pragma mark-请求数据

-(void)createRequest{
    
    DDIndicator*indicators=[[DDIndicator alloc]initWithFrame:CGRectMake(SCREEN_W/2-20, 100, 40, 40)];
    [self.view addSubview:indicators];
    [indicators startAnimating];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString*body=[NSString stringWithFormat:@"action=v1&page=1&maxsize=%d&typeid=44&sort=time&isTop=yes",maxSize];
        GetData*getData=[GetData getdataWithUrl:@"/document/list.php" Body:body];
        dict=getData.dict;
//        NSLog(@"%@",dict);
        totalNums=[[dict objectForKey:@"totalNums"] intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicators stopAnimating];
            
            [tableViewShow reloadData];
        });
    });
}

-(void)createTableView{
   tableViewShow.separatorStyle=UITableViewCellSeparatorStyleNone;
   tableViewShow.contentInset=UIEdgeInsetsMake(0, 0, 55, 0)
    ;
    //橡皮糖刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:tableViewShow];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
     [tableViewShow addFooterWithTarget:self action:@selector(footAction)];

}
-(void)footAction{
    maxSize=maxSize+10;
    
    if (maxSize<=totalNums) {
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [tableViewShow footerEndRefreshing];
            NSLog(@"加载");
            [self createRequest];
            
        });
    }else{
        maxSize=totalNums;
        
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [tableViewShow footerEndRefreshing];
            NSLog(@"加载");
            [self createRequest];
            
        });
    }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [refreshControl endRefreshing];
        NSLog(@"刷新");
        [self createRequest];
        
    });
}

-(void)createNavigation{
    
    
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME size:19]};
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    //设置导航栏文本的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //搜索
    UIButton*btnRight=[[UIButton alloc]initWithFrame:KRect(0, 0, 25, 25)];
    [btnRight setImage:KImage(@"搜索") forState:0];
    UIBarButtonItem*barRight=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barRight;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[dict objectForKey:@"msg"] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*identifier=@"show";
    QQShowTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"QQShowTableViewCell" owner:nil options:nil]lastObject];
        
    }
    
    cell.labelTitle.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"title"];//标题
    cell.labelTitle.font=[UIFont fontWithName:FONTNAME size:12];
    
    cell.labelTime.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"pubdate"];//发表时间
    cell.labelTime.font=[UIFont fontWithName:FONTNAME size:10];
    
    cell.labelPlayNums.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"click"];//播放数
    cell.labelPlayNums.font=[UIFont fontWithName:FONTNAME size:9];
    
    cell.labelCollectionNums.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"goodpost"];//收藏数
    cell.labelCollectionNums.font=[UIFont fontWithName:FONTNAME size:9];
    
    cell.labelLikeNums.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"like"];//喜欢数
    cell.labelLikeNums.font=[UIFont fontWithName:FONTNAME size:9];
    
    cell.labelCommentNums.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"commentNum"];//评论数
    cell.labelCommentNums.font=[UIFont fontWithName:FONTNAME size:9];
    
    cell.labelDescribe.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"description"];//视频描述
    cell.labelDescribe.font=[UIFont fontWithName:FONTNAME size:10];
    
    //缩略图
    NSString*strUrl=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"litpic"];
    [cell.imageViewPic setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:nil];
    cell.imageViewPic.contentMode=UIViewContentModeScaleAspectFill;
    cell.imageViewPic.clipsToBounds=YES;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 266;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYShowDetailsViewController*showDetails=[[YYShowDetailsViewController alloc]init];
    [self.navigationController pushViewController:showDetails animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Hidden_Tabbar" object:nil userInfo:nil];
    showDetails.strID=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"id"];
    showDetails.typeID=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"typeid"];
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
