//
//  QQHomeViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/8.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQHomeViewController.h"
#import "QQHomeTableViewCell.h"
#import "QQHome_DetailController.h"
#import "QQSearchViewController.h"


@interface QQHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSDictionary*dictHome;
    int maxSize;
    int totalNums;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewHome;

@end

@implementation QQHomeViewController
@synthesize tableViewHome;
- (void)viewDidLoad {
    [super viewDidLoad];
    maxSize=10;
    // Do any additional setup after loading the view from its nib.
     self.automaticallyAdjustsScrollViewInsets=NO;
    [self createNavigation];
    [self createTableView];
    [self createRequest];
    

}
-(void)createRequest{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString*body=[NSString stringWithFormat:@"action=v1&page=1&maxsize=%d&typeid=&sort=time&isTop=",maxSize];
        GetData*getData=[GetData getdataWithUrl:@"/document/list.php" Body:body];
//        NSLog(@"getData===%@",getData.dict);
        dictHome=getData.dict;
        totalNums=[[getData.dict objectForKey:@"totalNums"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableViewHome reloadData];
            
        });
        
    });
   
    
}
-(void)createTableView{
    tableViewHome.contentInset=UIEdgeInsetsMake(0, 0, 58, 0);
    tableViewHome.separatorStyle=UITableViewCellSeparatorStyleNone;
    //橡皮糖刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:tableViewHome];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [self followRollingScrollView:tableViewHome];
    [tableViewHome addFooterWithTarget:self action:@selector(footAction)];
    

}
-(void)footAction{
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        maxSize=maxSize+10;
        if (maxSize<=totalNums) {
            [self createRequest];
            [tableViewHome reloadData];
            [tableViewHome footerEndRefreshing];
            
        }else{
            NSLog(@"没有数据了");
            
            [ProgressHUD showError: @"没有数据了"];

        }
      
        
        
    });
 
}
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self createRequest];
        [refreshControl endRefreshing];
         [ProgressHUD showSuccess:@"更新成功"];
        
      
    });
}
-(void)createNavigation{
   

    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    //设置导航栏文本的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //分类
    UIButton*btnLeft=[[UIButton alloc]initWithFrame:KRect(0, 0, 30, 30)];
    [btnLeft setImage:KImage(@"分类") forState:0];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barLeft;
    //搜索
    UIButton*btnRight=[[UIButton alloc]initWithFrame:KRect(0, 0, 25, 25)];
    [btnRight setImage:KImage(@"搜索") forState:0];
    [btnRight addTarget:self action:@selector(btnRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*barRight=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barRight;
    
    
    
}
-(void)btnRightAction{
    QQSearchViewController*searchView=[[QQSearchViewController alloc]init];
//    [self.navigationController pushViewController:searchView animated:YES];
    UINavigationController*nav_search=[[UINavigationController alloc]initWithRootViewController:searchView];
    [self presentViewController:nav_search animated:YES completion:^{
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[dictHome objectForKey:@"msg"] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*identifier=@"home";
    QQHomeTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"QQHomeTableViewCell" owner:nil options:nil] lastObject];
    }
    //动画效果
    cell.backgroundColor=[UIColor blackColor];
    [UIView animateWithDuration:0.5 animations:^{
        cell.myBackground.alpha=0;
        cell.myBackground.alpha=1;
    }];
    //背景大图
    [cell.myBackground setImageWithURL:[NSURL URLWithString:[[[dictHome objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"litpic"]] placeholderImage:nil];
    //品牌图片
    NSString*pic=[NSString stringWithFormat:@"%@2222",[[[[dictHome objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"productInfo"] objectForKey:@"typename"]];
    cell.imageBrand.image=KImage(pic);
    //title
    cell.labelTitle.text=[[[dictHome objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"title"];
    //评论数
    cell.labelComment.text=[[[dictHome objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"commentNum"];
    //喜欢数
    cell.labelHeart.text=[[[dictHome objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"like"];
    //收藏数
    cell.labelCollection.text=[[[dictHome objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"fav"];
    
    
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QQHome_DetailController*home_Detail=[[QQHome_DetailController alloc]init];
    [self.navigationController pushViewController:home_Detail animated:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Hidden_Tabbar" object:nil userInfo:nil];
    
    
    
}
//屏幕一旦旋转，马上执行的代理
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    NSLog(@"change---------");
    
    [self changeActon];
    
    
    
    
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
