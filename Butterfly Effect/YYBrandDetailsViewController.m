//
//  YYBrandDetailsViewController.m
//  Butterfly Effect
//
//  Created by lyan on 15/6/19.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "YYBrandDetailsViewController.h"
#import "YYBrandContentViewController.h"
#import "QQShowTableViewCell.h"
#import "YYShowDetailsViewController.h"

@interface YYBrandDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary*dict;
    int classID;
    int maxSize;
    int totalNums;
    NSString*strStatus;
    UILabel*labelPrompt;
    UIButton*btnReview;
    UIButton*btnlecturehall;
    UIButton*btnShow;
    UILabel*labelRedline;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewBrandDetails;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicators;

@end

@implementation YYBrandDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"YYBrandDetailsViewController");
    
    // Do any additional setup after loading the view from its nib.
    
    classID=4;
    maxSize=10;
    
    //导航栏
    [self createNavigation];
    
    //TableView
    [self createTableView];
    
    //Segement
    [self createSegement];
    
    //请求数据
    [self createRequest];
    
    //提示
    [self createPrompt];
    
    [self createActivity];
}

-(void)createActivity{
    _indicators.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
}

#pragma mark-没有数据时候的提示

-(void)createPrompt{
    labelPrompt=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/4, 100, SCREEN_W/2, 40)];
    labelPrompt.text=@"实在是不好意思,这里暂时还没有内容!";
    labelPrompt.numberOfLines=0;
    labelPrompt.textAlignment=NSTextAlignmentCenter;
    labelPrompt.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    labelPrompt.font=[UIFont fontWithName:FONTNAME size:14];
    labelPrompt.hidden=YES;
    [_tableViewBrandDetails addSubview:labelPrompt];
}

#pragma mark-请求数据

-(void)createRequest{
    
    [_indicators startAnimating];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString*body=[NSString stringWithFormat:@"action=v1&page=1&maxsize=%d&prodid=%@&sort=time&classid=%d",maxSize,self.prodID,classID];
        NSLog(@"%d--%@",classID,self.prodID);
        GetData*getData=[GetData getdataWithUrl:@"/document/list_product.php" Body:body];
        dict=getData.dict;
//        NSLog(@"====%@",dict);
        totalNums=[[dict objectForKey:@"totalNums"] intValue];
        strStatus=[dict objectForKey:@"status"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_indicators stopAnimating];
            _indicators.hidden=YES;
            
            [_tableViewBrandDetails reloadData];
            if ([strStatus isEqualToString:@"empty"]) {
                labelPrompt.hidden=NO;
            }else if ([strStatus isEqualToString:@"ok"]){
                labelPrompt.hidden=YES;
            }
        });
    });
}

#pragma mark-Segement

-(void)createSegement{
    //评测
    btnReview=[[UIButton alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W/3, 35)];
    [btnReview setTitle:@"评测" forState:0];
    [btnReview setTitleColor:[UIColor blackColor] forState:0];
    btnReview.titleLabel.font=[UIFont fontWithName:FONTNAME size:15];
    [self.view addSubview:btnReview];
    [btnReview addTarget:self action:@selector(btnReviewAction) forControlEvents:UIControlEventTouchUpInside];
    
    //讲堂
    btnlecturehall=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/3, 64, SCREEN_W/3, 35)];
    [btnlecturehall setTitle:@"讲堂" forState:0];
    [btnlecturehall setTitleColor:[UIColor blackColor] forState:0];
    btnlecturehall.titleLabel.font=[UIFont fontWithName:FONTNAME size:15];
    [self.view addSubview:btnlecturehall];
    [btnlecturehall addTarget:self action:@selector(btnLecturehallAction) forControlEvents:UIControlEventTouchUpInside];
    
    //秀场
    btnShow=[[UIButton alloc]initWithFrame:CGRectMake(2*SCREEN_W/3, 64, SCREEN_W/3, 35)];
    [btnShow setTitle:@"秀场" forState:0];
    [btnShow setTitleColor:[UIColor blackColor] forState:0];
    btnShow.titleLabel.font=[UIFont fontWithName:FONTNAME size:15];
    [self.view addSubview:btnShow];
    [btnShow addTarget:self action:@selector(btnShowAction) forControlEvents:UIControlEventTouchUpInside];
    
    //灰色长条
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 99, SCREEN_W, 2)];
    label.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:label];
    
    //红色线
    labelRedline=[[UILabel alloc]initWithFrame:CGRectMake(0, 99, SCREEN_W/3, 2)];
    labelRedline.backgroundColor=[UIColor redColor];
    [self.view addSubview:labelRedline];
}

- (void)btnReviewAction{
    NSLog(@"测评");
    classID=4;
    [self createRequest];
    [UIView animateWithDuration:0.2 animations:^{
        labelRedline.frame=CGRectMake(0, 99, SCREEN_W/3, 2);
    }];
}

- (void)btnLecturehallAction{
    NSLog(@"讲堂");
    classID=2;
    [self createRequest];
    [UIView animateWithDuration:0.2 animations:^{
        labelRedline.frame=CGRectMake(SCREEN_W/3, 99, SCREEN_W/3, 2);
    }];
}

- (void)btnShowAction{
    NSLog(@"秀场");
    classID=5;
    [self createRequest];
    [UIView animateWithDuration:0.2 animations:^{
        labelRedline.frame=CGRectMake(2*SCREEN_W/3, 99, SCREEN_W/3, 2);
    }];
}

#pragma mark-TableView

-(void)createTableView{
    _tableViewBrandDetails.delegate=self;
    _tableViewBrandDetails.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    //橡皮糖刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableViewBrandDetails];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [_tableViewBrandDetails addFooterWithTarget:self action:@selector(footAction)];
}

-(void)footAction{
    maxSize=maxSize+10;
    
    if (maxSize<=totalNums) {
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [_tableViewBrandDetails footerEndRefreshing];
            NSLog(@"加载");
            [self createRequest];
            
        });
    }else{
        maxSize=totalNums;
        
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [_tableViewBrandDetails footerEndRefreshing];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![strStatus isEqualToString:@"ok"]) {
        return 0;
    }
    return [[dict objectForKey:@"msg"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 266;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ident=@"CELL";
    QQShowTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"QQShowTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.labelTitle.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"title"];//标题
    cell.labelTitle.font=[UIFont fontWithName:FONTNAME size:12];
    
    cell.labelTime.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"pubdate"];//发表时间
    cell.labelTime.font=[UIFont fontWithName:FONTNAME size:10];
    
    cell.labelPlayNums.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"click"];//播放数
    cell.labelPlayNums.font=[UIFont fontWithName:FONTNAME size:9];
    
    cell.labelCollectionNums.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"fav"];//收藏数
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
    
    //动画效果
    cell.imageViewPic.backgroundColor=[UIColor blackColor];
    [UIView animateWithDuration:0.5 animations:^{
        cell.imageViewPic.alpha=0;
        cell.imageViewPic.alpha=1;
    }];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    
    if (classID==4) {
        NSLog(@"评测");
        YYBrandContentViewController*brandContent=[[YYBrandContentViewController alloc]init];
//        brandContent.strTitles=self.title;
        [self.navigationController pushViewController:brandContent animated:YES];
        brandContent.strID=[[[dict objectForKey:@"msg"]objectAtIndex:indexPath.row] objectForKey:@"id"];
        brandContent.strClassID=@"0";
    }else if (classID==2){
        NSLog(@"讲堂");
        YYBrandContentViewController*brandContent=[[YYBrandContentViewController alloc]init];
//        brandContent.strTitles=self.title;
        [self.navigationController pushViewController:brandContent animated:YES];
        brandContent.strID=[[[dict objectForKey:@"msg"]objectAtIndex:indexPath.row]objectForKey:@"id"];
        brandContent.strClassID=@"1";
    }else{
        NSLog(@"秀场");
        YYShowDetailsViewController*showDetails=[[YYShowDetailsViewController alloc]init];
        [self.navigationController pushViewController:showDetails animated:YES];
        showDetails.strID=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"id"];
        showDetails.typeID=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"typeid"];
        showDetails.isTop=@"品牌荟";
    }
}

#pragma mark-导航栏

-(void)createNavigation{
    self.title=self.strTitle;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    
    //设置导航栏文本的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //返回
    UIButton*btnLeft=[[UIButton alloc]initWithFrame:KRect(0, 0, 20, 20)];
    [btnLeft setImage:KImage(@"返回按钮") forState:0];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barLeft;
}

-(void)btnLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Show_Tabbar" object:nil];
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
