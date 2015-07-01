//
//  YYShowCommentViewController.m
//  Butterfly Effect
//
//  Created by lyan on 15/6/24.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "YYShowCommentViewController.h"
#import "YYShowCommentTableViewCell.h"
#import "YFInputBar.h"
#import "QQMySelfViewController.h"

@interface YYShowCommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,YFInputBarDelegate,UIAlertViewDelegate>
{
    NSDictionary*dictComment;
    NSString*strStatus;
    UILabel*labelPrompt;
    NSDictionary*dictSender;
    YFInputBar*inputBar;
    NSString*sendStr;
    int maxSize;
    int totalNums;
    UITableView*_tableViewComment;
    UIActivityIndicatorView*indicators;
}
//@property (weak, nonatomic) IBOutlet UITableView *tableViewComment;
//@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackgrond;

@end

@implementation YYShowCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"YYShowCommentViewController");
    
    // Do any additional setup after loading the view from its nib.
    
    maxSize=10;
    
    //导航栏
    [self createNavigation];
    
    //TableView
    [self createTableView];
    
    //请求评论数据
    [self createRequestComment];
    
    //没有评论时候的提示
    [self createPrompt];
    
    //评论框
    [self createTalkBox];
}

-(void)createActivity{
    indicators=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREEN_W/2-20, 150, 40, 40)];
    indicators.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicators];
}

#pragma mark-没有评论时候的提示

-(void)createPrompt{
    labelPrompt=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_W, 20)];
    labelPrompt.text=@"暂无评论，快去抢沙发吧";
    labelPrompt.textAlignment=NSTextAlignmentCenter;
    labelPrompt.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    labelPrompt.font=[UIFont fontWithName:FONTNAME size:14];
    labelPrompt.hidden=YES;
    [_tableViewComment addSubview:labelPrompt];
}

#pragma mark-评论框

-(void)createTalkBox{
    inputBar=[[YFInputBar alloc]initWithFrame:CGRectMake(0, SCREEN_H-50, SCREEN_W, 50)];
    inputBar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    inputBar.delegate=self;
    inputBar.clearInputWhenSend = YES;
    inputBar.resignFirstResponderWhenSend = YES;
    inputBar.textField.placeholder=@"   我来评论";
    inputBar.textField.delegate=self;
    inputBar.textField.returnKeyType=UIReturnKeyDone;
    [inputBar.sendBtn addTarget:self action:@selector(senderAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputBar];
}

-(void)senderAction{
    NSLog(@"评论");
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]==nil) {
        UIAlertView*alertViewAnswer=[[UIAlertView alloc]initWithTitle:nil message:@"还没登录，快去登录再来回答吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alertViewAnswer show];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString*bodyStr=[NSString stringWithFormat:@"action=v1&aid=%@&fid=0&tfid=0&fromuid=%@&touid=0&class=%@&comt=%@",self.strID,[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],self.strClassID,sendStr];
            GetData*getData=[GetData getdataWithUrl:@"/comment/save.php" Body:bodyStr];
            dictSender=getData.dict;
//            NSLog(@"dictSender====%@",dictSender);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictSender objectForKey:@"status"] isEqualToString:@"success"]) {
                    UIAlertView*alerts=[[UIAlertView alloc]initWithTitle:nil message:@"评论成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alerts show];
                    [self createRequestComment];
                }else if ([[dictSender objectForKey:@"status"] isEqualToString:@"toofast"]){
                    UIAlertView*alerts=[[UIAlertView alloc]initWithTitle:nil message:@"请稍后再试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alerts show];
                }
            });
        });
    }
}

-(void)inputBar:(YFInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)str
{
    NSLog(@"%@",str);
    sendStr=str;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]==nil) {
        UIAlertView*alertViewAnswer=[[UIAlertView alloc]initWithTitle:nil message:@"还没登录，快去登录再来回答吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alertViewAnswer show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSLog(@"去登录");
        QQMySelfViewController*mySelf=[[QQMySelfViewController alloc]init];
        UINavigationController*nav_mySelf=[[UINavigationController alloc]initWithRootViewController:mySelf];
        [self presentViewController:nav_mySelf animated:YES completion:nil];
        mySelf.isHidden=YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [inputBar.textField resignFirstResponder];
    sendStr=inputBar.textField.text;
    [self senderAction];
    inputBar.textField.text=@"";
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [((UIView*)obj) resignFirstResponder];
    }];
}

#pragma mark-请求评论数据

-(void)createRequestComment{
    
    [indicators startAnimating];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString*body=[NSString stringWithFormat:@"action=v1&aid=%@&page=1&maxsize=%d&class=%@",self.strID,maxSize,self.strClassID];
        GetData*getData=[GetData getdataWithUrl:@"/comment/list.php" Body:body];
        dictComment=getData.dict;
        NSLog(@"dictComment====%@",dictComment);
        NSLog(@"dict--------=%@",self.strClassID);
        strStatus=[dictComment objectForKey:@"status"];
        totalNums=[[dictComment objectForKey:@"totalNums"] intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicators stopAnimating];
            
            [_tableViewComment reloadData];
            if ([strStatus isEqualToString:@"empty"]) {
                labelPrompt.hidden=NO;
            }else if ([strStatus isEqualToString:@"ok"]){
                labelPrompt.hidden=YES;
            }
        });
    });
}

#pragma mark-TableView

-(void)createTableView{
    _tableViewComment=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64) style:UITableViewStyleGrouped];
    _tableViewComment.delegate=self;
    _tableViewComment.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableViewComment.showsVerticalScrollIndicator=NO;
    _tableViewComment.contentInset=UIEdgeInsetsMake(0, 0, 50, 0);
    [self.view addSubview:_tableViewComment];
    
    //橡皮糖刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableViewComment];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [_tableViewComment addFooterWithTarget:self action:@selector(footAction)];
}

-(void)footAction{
    maxSize=maxSize+10;
    
    if (maxSize<=totalNums) {
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [_tableViewComment footerEndRefreshing];
            NSLog(@"加载1");
            [self createRequestComment];
            
        });
    }else{
        maxSize=totalNums;
        
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [_tableViewComment footerEndRefreshing];
            NSLog(@"加载2");
            [self createRequestComment];
            
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
        [self createRequestComment];
        
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*text=[NSString stringWithFormat:@"%@",[[[dictComment objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"msg"]];
    CGSize mySize=[text boundingRectWithSize:CGSizeMake(SCREEN_W-55, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:FONTNAME size:10]} context:nil].size;
    
    return 40+mySize.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (![strStatus isEqualToString:@"empty"]) {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 20)];
        label.text=[NSString stringWithFormat:@"%@%@%@",@"     共有 ",[dictComment objectForKey:@"totalNums"],@" 条评论"];
        label.font=[UIFont fontWithName:FONTNAME size:10];
        return label;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([strStatus isEqualToString:@"empty"]) {
        return 0;
    }
    return [[dictComment objectForKey:@"msg"] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ident=@"CELL";
    YYShowCommentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"YYShowCommentTableViewCell" owner:nil options:nil] lastObject];
    }
    
    [cell.imageViewUserPic setImageWithURL:[NSURL URLWithString:[[[dictComment objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"face"]] placeholderImage:nil];//头像
    cell.imageViewUserPic.layer.cornerRadius=15;
    cell.imageViewUserPic.clipsToBounds=YES;
    cell.imageViewUserPic.contentMode=UIViewContentModeScaleAspectFill;
    
    cell.labelUserName.text=[[[dictComment objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"fromuname"];//用户名
    cell.labelContent.text=[[[dictComment objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"msg"];//评论内容
    cell.labelContent.numberOfLines=0;
    cell.labelContent.textAlignment=NSTextAlignmentJustified;
    cell.labelContent.font=[UIFont fontWithName:FONTNAME size:10];
    cell.labelNumber.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark-导航栏

-(void)createNavigation{
    self.title=@"评论";
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
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAgain" object:nil];
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
