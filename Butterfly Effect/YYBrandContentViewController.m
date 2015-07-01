//
//  YYBrandContentViewController.m
//  Butterfly Effect
//
//  Created by lyan on 15/6/19.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "YYBrandContentViewController.h"
#import "YYBrandContentTableViewCell.h"
#import "YYShowCommentViewController.h"
#import "UMSocial.h"
#import "QQMySelfViewController.h"

@interface YYBrandContentViewController ()<UMSocialUIDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
    NSDictionary*dict;
}
@property (weak, nonatomic) IBOutlet UIWebView *webViewBrandContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicators;
@end

@implementation YYBrandContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"YYBrandContentViewController");
    
    // Do any additional setup after loading the view from its nib.
    
    //导航栏
    [self createNavigation];
    
    //WebView
    [self createWebView];
    
    //请求数据
    [self createRequest];
    
    //Tabbar
    [self createTabBar];
    
    [self createActivity];
}

-(void)recordAction{
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"recordArr"]!=nil) {
        NSArray*arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"recordArr"];
        NSMutableArray*mstArr=[[NSMutableArray alloc]init];
        BOOL isSame=NO;
        
        for (int i=0; i<arr.count; i++) {
            if (i<10) {
                [mstArr addObject:[arr objectAtIndex:i]];
                if ([[arr objectAtIndex:i]isEqualToString:self.strID]) {
                    isSame=YES;
                }
            }
        }
        if (isSame==NO) {
            [mstArr insertObject:self.strID atIndex:0];
        }
        [[NSUserDefaults standardUserDefaults]setObject:mstArr forKey:@"recordArr"];
    }else{
        NSArray*arr=[NSArray arrayWithObjects:self.strID, nil];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"recordArr"];
    }
}

-(void)createWebView{
    NSString*webStr=[[dict objectForKey:@"msg"] objectForKey:@"bodyLink"];
    NSURLRequest*request=[NSURLRequest requestWithURL:[NSURL URLWithString:webStr] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    [_webViewBrandContent loadRequest:request];
    _webViewBrandContent.scalesPageToFit=YES;
    _webViewBrandContent.scrollView.showsVerticalScrollIndicator=NO;
    _webViewBrandContent.scrollView.showsHorizontalScrollIndicator=NO;
    _webViewBrandContent.delegate=self;
}

-(void)createActivity{
    _indicators.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
}

#pragma mark-请求数据

-(void)createRequest{
    
    [_indicators startAnimating];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString*body=[NSString stringWithFormat:@"action=v1&id=%@&uid=",self.strID];
        GetData*getData=[GetData getdataWithUrl:@"/document/info.php" Body:body];
        dict=getData.dict;
        NSLog(@"====%@",dict);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createWebView];
            //播放的记录
            [self recordAction];
        });
    });
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_indicators stopAnimating];
    _indicators.hidden=YES;
}

#pragma mark-TabBar

-(void)createTabBar{
    _btnCollection.imageEdgeInsets=UIEdgeInsetsMake(5, (SCREEN_W/4-30)/2, 5, (SCREEN_W/4-30)/2);
    [_btnCollection addTarget:self action:@selector(btnCollectionAction) forControlEvents:UIControlEventTouchUpInside];
    
    _btnLike.imageEdgeInsets=UIEdgeInsetsMake(5, (SCREEN_W/4-30)/2, 5, (SCREEN_W/4-30)/2);
    [_btnLike addTarget:self action:@selector(btnLikeAction) forControlEvents:UIControlEventTouchUpInside];
    
    _btnShare.imageEdgeInsets=UIEdgeInsetsMake(5, (SCREEN_W/4-30)/2, 5, (SCREEN_W/4-30)/2);
    [_btnShare addTarget:self action:@selector(btnShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    _btnComments.imageEdgeInsets=UIEdgeInsetsMake(5, (SCREEN_W/4-30)/2, 5, (SCREEN_W/4-30)/2);
    [_btnComments addTarget:self action:@selector(btnCommentsAction) forControlEvents:UIControlEventTouchUpInside];
}

//收藏
-(void)btnCollectionAction{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]==nil) {
        UIAlertView*alertViewAnswer=[[UIAlertView alloc]initWithTitle:nil message:@"还没登录，\n快去登录再来收藏我吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alertViewAnswer show];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString*body=[NSString stringWithFormat:@"action=v1&mid=%@&aid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],self.strID];
            GetData*getData=[GetData getdataWithUrl:@"/document/fav_insert.php" Body:body];
            NSDictionary*dictCollection=getData.dict;
            NSLog(@"====%@",dictCollection);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictCollection objectForKey:@"status"] isEqualToString:@"success"]) {
                    UIAlertView*alerts=[[UIAlertView alloc]initWithTitle:nil message:@"收藏成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alerts show];
                }else if ([[dictCollection objectForKey:@"status"] isEqualToString:@"has_fav"]){
                    UIAlertView*alerts=[[UIAlertView alloc]initWithTitle:nil message:@"已经收藏" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alerts show];
                }
            });
        });
    }
}

//喜欢
-(void)btnLikeAction{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]==nil) {
        UIAlertView*alertViewAnswer=[[UIAlertView alloc]initWithTitle:nil message:@"还没登录，\n快去登录再来喜欢我吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alertViewAnswer show];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString*body=[NSString stringWithFormat:@"action=v1&mid=%@&aid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],self.strID];
            GetData*getData=[GetData getdataWithUrl:@"/document/like_insert.php" Body:body];
            NSDictionary*dictLike=getData.dict;
            NSLog(@"Like====%@",dictLike);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictLike objectForKey:@"status"] isEqualToString:@"success"]) {
                    UIAlertView*alerts=[[UIAlertView alloc]initWithTitle:nil message:@"喜欢该文章" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alerts show];
                }else if ([[dictLike objectForKey:@"status"] isEqualToString:@"has_like"]){
                    UIAlertView*alerts=[[UIAlertView alloc]initWithTitle:nil message:@"已经喜欢" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alerts show];
                }
            });
        });
    }
}

//分享
-(void)btnShareAction{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"558a12d267e58e4fee0005b8"
                                      shareText:@"滚水网：www.imus.cn"
                                     shareImage:[UIImage imageNamed:@"App ios7,8  3x"]
                                shareToSnsNames:@[UMShareToSina,UMShareToDouban,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
}

//评论
-(void)btnCommentsAction{
    YYShowCommentViewController*showComment=[[YYShowCommentViewController alloc]init];
    [self.navigationController pushViewController:showComment animated:NO];
    showComment.strID=self.strID;
    showComment.strClassID=[[dict objectForKey:@"msg"] objectForKey:@"classComment"];
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

#pragma mark-导航栏

-(void)createNavigation{
    if ([self.strClassID isEqualToString:@"0"]) {
        self.title=@"评测";
    }else if ([self.strClassID isEqualToString:@"1"]){
        self.title=@"讲堂";
    }else{
        self.title=self.strTitles;
    }
    
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
    if ([self.strClassID isEqualToString:@"0"]||[self.strClassID isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Show_Tabbar" object:nil];
    }
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
