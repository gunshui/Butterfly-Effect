//
//  QQMySelfViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/17.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQMySelfViewController.h"
#import "QQMyselfTableViewCell.h"
#import "QQRegisterViewController.h"
#import "YYSettingViewController.h"
#import "YYBrandContentViewController.h"
#import "YYShowDetailsViewController.h"

@interface QQMySelfViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIButton*btnRight;
    NSDictionary*dictCollection;
    NSArray*arrClass;
    UILabel*lineRed;
    UIView*viewHeader;
    UIImageView*btnUser;
    UILabel*labelUserName;
    UILabel*labelPoint;
    UILabel*labelLevels;
    int maxSize;
    NSDictionary*dict;
    NSString*type;
    UIImageView*imageViewBackground;
    UIButton*btnLeft;
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_Distance;
- (IBAction)btnLoginAction:(id)sender;
- (IBAction)btnRegisterAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMe;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left_Distance;
@property (weak, nonatomic) IBOutlet UILabel *lableName;
@property (weak, nonatomic) IBOutlet UILabel *lableIntegral;
@property (weak, nonatomic) IBOutlet UILabel *labelLevel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distance_Line;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUser;
- (IBAction)btnCollectionAction:(id)sender;
- (IBAction)btnLoveAction:(id)sender;
- (IBAction)btnSeeAction:(id)sender;

@end

@implementation QQMySelfViewController
@synthesize textFieldName,textFieldPassword,btnLogin,btnRegister,tableViewMe,labelLevel,lableIntegral,lableName,imageViewUser;


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"Show_Tabbar" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    btnLogin.layer.cornerRadius=5;
    btnLogin.layer.masksToBounds=YES;
    btnRegister.layer.cornerRadius=5;
    btnRegister.layer.masksToBounds=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    arrClass=@[@"我的收藏",@"我的喜欢",@"我看过的"];
    type=@"1";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserState) name:@"State" object:nil];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"status"]isEqualToString:@"success"]) {
        NSLog(@"**********************");
        //请求数据
        [self createRequest];
        //创建头
        [self createHeader];
        //填充头的各种数据
        [self loadUserInfo];
        
        tableViewMe.hidden=NO;
        tableViewMe.alpha=1;
        tableViewMe.contentInset=UIEdgeInsetsMake(0, 0, 58, 0);
        
    }else{
        tableViewMe.hidden=YES;
    }
}

-(void)changeUserState{
    NSLog(@"changeUSer------------");
    [self viewDidLoad];
}

-(void)headerData{
    labelUserName.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString*strPic=[[NSUserDefaults standardUserDefaults] objectForKey:@"face"];
    [btnUser setImageWithURL:[NSURL URLWithString:strPic] placeholderImage:nil];
    
    labelPoint.text=[NSString stringWithFormat:@"积分  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"credits"]];
    labelLevels.text=[NSString stringWithFormat:@"等级  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"level"]];
    
}
-(void)createHeader{
    
    viewHeader=[[UIView alloc]initWithFrame:KRect(0, 0, SCREEN_W, 230)];
    tableViewMe.tableHeaderView=viewHeader;
    
    imageViewBackground=[[UIImageView alloc]initWithFrame:KRect(0, 0, SCREEN_W, 190)];
    imageViewBackground.contentMode=UIViewContentModeScaleAspectFill;
    imageViewBackground.clipsToBounds=YES;
    imageViewBackground.image=[UIImage imageNamed:@"个人中心背景图"];
    [viewHeader addSubview:imageViewBackground];
    UIImageView*imageBlack=[[UIImageView alloc]initWithFrame:KRect(0, 0, SCREEN_W, 190)];
    imageBlack.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
    [viewHeader addSubview:imageBlack];
    
    UIView*viewSegment=[[UIView alloc]initWithFrame:KRect(0, CGRectGetMaxY(imageBlack.frame), SCREEN_W, 40)];
    viewSegment.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [viewHeader addSubview:viewSegment];
    
    for (int i=0; i<3;i++ ) {
        UIButton*btn=[[UIButton alloc]initWithFrame:KRect(SCREEN_W/3*i, 0, SCREEN_W/3, 40)];
        btn.tag=2000+i;
        [viewSegment addSubview:btn];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[arrClass objectAtIndex:i] forState:0];
        [btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] forState:0];
        btn.titleLabel.font=[UIFont fontWithName:FONTNAME size:11];
        
       }
    
    btnUser=[[UIImageView alloc]initWithFrame:KRect(20, imageViewBackground.frame.size.height-55, 65, 65)];
    btnUser.layer.cornerRadius=5;
    btnUser.layer.masksToBounds=YES;
    btnUser.layer.borderColor=[UIColor whiteColor].CGColor;
    btnUser.layer.borderWidth=1;
    btnUser.userInteractionEnabled=YES;
    btnUser.contentMode=UIViewContentModeScaleAspectFill;
    btnUser.clipsToBounds=YES;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActions:)];
    tap.numberOfTapsRequired=1;
    [btnUser addGestureRecognizer:tap];
    
    [viewHeader addSubview:btnUser];
    
    labelUserName=[[UILabel alloc]initWithFrame:KRect(CGRectGetMaxX(btnUser.frame)+15, CGRectGetMinY(btnUser.frame)+5, 150, 20)];
    labelUserName.text=@"Amber Brown";
    labelUserName.textColor=[UIColor whiteColor];
    labelUserName.font=[UIFont fontWithName:FONTNAME3 size:14];
    [viewHeader addSubview:labelUserName];
    
    labelPoint=[[UILabel alloc]initWithFrame:KRect(CGRectGetMaxX(btnUser.frame)+15, CGRectGetMaxY(labelUserName.frame), 60, 20)];
    labelPoint.text=@"积分  ";
    labelPoint.textColor=[UIColor whiteColor];
    labelPoint.font=[UIFont fontWithName:FONTNAME3 size:11];
    [viewHeader addSubview:labelPoint];
    
    UILabel*line=[[UILabel alloc]initWithFrame:KRect(CGRectGetMaxX(labelPoint.frame), CGRectGetMaxY(labelUserName.frame)+4, 2, 11)];
    line.backgroundColor=[UIColor whiteColor];
    [viewHeader addSubview:line];
    
    
    labelLevels=[[UILabel alloc]initWithFrame:KRect(CGRectGetMaxX(line.frame)+15, CGRectGetMaxY(labelUserName.frame), 100, 20)];
    labelLevels.text=@"等级  ";
    labelLevels.textColor=[UIColor whiteColor];
    labelLevels.font=[UIFont fontWithName:FONTNAME3 size:11];
    [viewHeader addSubview:labelLevels];
    
    
    lineRed=[[UILabel alloc]initWithFrame:KRect(0, viewHeader.frame.size.height-1.5, SCREEN_W/3, 1.5)];
    lineRed.backgroundColor=[UIColor redColor];
    [viewHeader addSubview:lineRed];
    
    
    [self headerData];
}

-(void)tapActions:(UITapGestureRecognizer*)sender{
    NSLog(@"换头像");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.delegate=self;
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;//设置源类型
        [imagePicker setEditing:YES animated:YES];//允许编辑
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [ProgressHUD showError:@"无法打开相机"];
    }
}

//打开相册之后选择的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString*mediaType=[info valueForKey:UIImagePickerControllerMediaType];
    if ([mediaType hasSuffix:@"image"])
    {
        UIImage*image=[info valueForKey:UIImagePickerControllerOriginalImage];

//        btnUser.image=image;
//        imageViewBackground.image=image;
        
        //返回的就是jpeg格式的data
        NSData*data123=UIImageJPEGRepresentation(image, 0.00001);
        
        //        NSLog(@"data123=%@",data123);
        ///************************************************///
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
            //创建Url连接
            NSURL*url=[NSURL URLWithString:@"http://www.gunshuibbs.com/app/face.php"];
            //创建可变链接请求
            NSMutableURLRequest*request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
            //设置http请求方式
            [request setHTTPMethod:@"POST"];
            //设置http请求body
            NSString*bodyStr=[NSString stringWithFormat:@"action=v1&uid=%@&imgfile=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],data123];
            NSData*body=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setHTTPBody:body];
            //
            NSHTTPURLResponse*response=nil;
            NSError*error=nil;
            NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            //二进制转成字符串
            NSLog(@"respose=%@,error=%@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
            NSString*strResult=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"*******************************=%@",strResult);
            
            
            NSDictionary*dicts=[strResult objectFromJSONString];
            NSLog(@"dict=*************--------%@",dicts);
            
        });
        
        [self dismissViewControllerAnimated:YES completion:^{
            btnUser.image=image;
            imageViewBackground.image=image;
            //设置导航栏文本的颜色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}

-(void)btnAction:(UIButton*)sender{
    NSLog(@"btnAction");
    if (sender.tag==2000) {
        [UIView animateWithDuration:0.3 animations:^{
            lineRed.frame=KRect(0, viewHeader.frame.size.height-1.5, SCREEN_W/3, 1.5);
        }];
      
        type=@"1";
        
    }else if (sender.tag==2001){
        [UIView animateWithDuration:0.3 animations:^{
             lineRed.frame=KRect(SCREEN_W/3, viewHeader.frame.size.height-1.5, SCREEN_W/3, 1.5);
        }];
        type=@"2";
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
               lineRed.frame=KRect(SCREEN_W/3*2, viewHeader.frame.size.height-1.5, SCREEN_W/3, 1.5);
        }];
        type=@"3";
    }
    [self createRequest];
}

-(void)loadUserInfo{
    
    lableName.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    imageViewUser.layer.borderColor=[UIColor whiteColor].CGColor;
    imageViewUser.layer.borderWidth=2;
    imageViewUser.layer.masksToBounds=YES;
    imageViewUser.layer.cornerRadius=5;
    
    labelPoint.text=[NSString stringWithFormat:@"积分 %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"credits"]];
    NSLog(@"caocao----%@,,%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"credits"],[[NSUserDefaults standardUserDefaults]objectForKey:@"level"]);
    labelLevel.text=[NSString stringWithFormat:@"等级 %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"level"]];
  
    NSString*face=[NSString stringWithFormat:@"%@%d",[[NSUserDefaults standardUserDefaults] objectForKey:@"face"],arc4random_uniform(99999999)];
    NSString*faceBig=[NSString stringWithFormat:@"%@%d",[[NSUserDefaults standardUserDefaults]objectForKey:@"bigFace"],arc4random_uniform(99999999)];
    [btnUser setImageWithURL:[NSURL URLWithString:face] placeholderImage:nil];
    [imageViewBackground setImageWithURL:[NSURL URLWithString:faceBig] placeholderImage:nil];
}

-(void)createNavigation{
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    //设置导航栏文本的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (self.isHidden==YES) {
        //返回
        btnLeft=[[UIButton alloc]initWithFrame:KRect(0, 0, 20, 20)];
        [btnLeft setImage:KImage(@"返回按钮") forState:0];
        [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
        self.navigationItem.leftBarButtonItem=barLeft;
    }
    
    //设置
    btnRight=[[UIButton alloc]initWithFrame:KRect(0, 0, 40, 40)];
    [btnRight setImage:KImage(@"setting") forState:0];
    UIBarButtonItem*barRight=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    [btnRight addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=barRight;
}

-(void)btnLeftAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    btnLeft.hidden=YES;
    
    if (self.isHidden==YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Hidden_Tabbar" object:nil];
    }
    
}

-(void)settingAction{
    NSLog(@"pushi-----------");
    YYSettingViewController*set=[[YYSettingViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Hidden_Tabbar" object:nil];
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
    
    if ([textFieldName.text isEqualToString:@""]) {
        NSLog(@"用户名或者密码为空");
        [ProgressHUD showError: @"用户名为空"];
        
    }else if ([textFieldPassword.text isEqualToString:@""]){
        [ProgressHUD showError:@"密码为空"];
        
    }else{
        NSLog(@"都不空啦，，");
        
        [ProgressHUD show:@"loading..."];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString*body=[NSString stringWithFormat:@"action=v2&username=%@&password=%@",textFieldName.text,textFieldPassword.text];
            GetData*getData=[GetData getdataWithUrl:@"/user/login.php" Body:body];
            NSLog(@"登录==%@",getData.dict);
            NSString*strStatus=[getData.dict objectForKey:@"status"];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [ProgressHUD dismiss];
                
                if ([strStatus isEqualToString:@"error1"]) {
                    UIAlertView*alertViewPrampt=[[UIAlertView alloc]initWithTitle:nil message:@"用户不存在" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertViewPrampt show];
                }
                else if ([strStatus isEqualToString:@"error2"]){
                    UIAlertView*alertViewPrampt=[[UIAlertView alloc]initWithTitle:nil message:@"密码错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertViewPrampt show];
                }
                else if ([strStatus isEqualToString:@"error3"]){
                    UIAlertView*alertViewPrampt=[[UIAlertView alloc]initWithTitle:nil message:@"登录失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertViewPrampt show];
                }
                else{
                    
                    NSString*strMsg=[[getData.dict objectForKey:@"msg"] objectForKey:@"uid"];
                    NSString*strUrl=[NSString stringWithFormat:@"%@",[[getData.dict objectForKey:@"msg"] objectForKey:@"face"]];
                    //积分
                    NSString*strPoint=[[getData.dict objectForKey:@"msg"] objectForKey:@"credits"];
                    //等级
                    NSString*strLevel=[[getData.dict objectForKey:@"msg"] objectForKey:@"usergroup"];
//                    NSLog(@"strLevel==%@",strLevel);
                    if ([strStatus isEqualToString:@"success"])
                    {
                        
                        NSString*bigFace=[[getData.dict objectForKey:@"msg"] objectForKey:@"face_big"];
                        [ProgressHUD dismiss];
                        //用户id
                        [[NSUserDefaults standardUserDefaults] setObject:strMsg forKey:@"ID"];
                        [[NSUserDefaults standardUserDefaults] setObject:strStatus forKey:@"status"];
                        [[NSUserDefaults standardUserDefaults] setObject:strUrl forKey:@"face"];
                        [[NSUserDefaults standardUserDefaults]setObject:bigFace forKey:@"bigFace"];
                        [[NSUserDefaults standardUserDefaults] setObject:textFieldName.text forKey:@"userName"];
                        [[NSUserDefaults standardUserDefaults] setObject:textFieldPassword.text forKey:@"userPassword"];
                        [[NSUserDefaults standardUserDefaults] setObject:strPoint forKey:@"credits"];
                        [[NSUserDefaults standardUserDefaults] setObject:strLevel forKey:@"level"];
                        
                        [[NSUserDefaults standardUserDefaults] synchronize];
                       
                       //登录成功
                        [self loadSuccess];
                        [self btnLeftAction];
                    }
                }
            });
        });
    }
}

-(void)loadSuccess{
    //请求数据
    [self createRequest];
    //创建头
    [self createHeader];
    //填充头的各种数据
    [self loadUserInfo];
        

    [UIView animateWithDuration:1.5 animations:^{
        tableViewMe.hidden=NO;
        tableViewMe.alpha=0;
        tableViewMe.alpha=1;
    }];
}

- (IBAction)btnRegisterAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [textFieldPassword
         resignFirstResponder];
        [textFieldName resignFirstResponder];
        self.view.frame=KRect(0, 0, SCREEN_W, SCREEN_H);
    }];
    
    QQRegisterViewController*registerView=[[QQRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerView animated:YES];
    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[dictCollection objectForKey:@"status"]isEqualToString:@"ok"]) {
        return [[dictCollection objectForKey:@"msg"] count];
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*identifier=@"me";
    QQMyselfTableViewCell*cell=[tableViewMe dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"QQMyselfTableViewCell" owner:self options:nil] lastObject];
        
    }
    
    cell.width_distance.constant=SCREEN_W/3;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString*strPic=[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"litpic"];
    [cell.imageViewPic setImageWithURL:[NSURL URLWithString:strPic] placeholderImage:nil];
    cell.labelSee.text=[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row]objectForKey:@"click"];
     cell.labelHeart.text=[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row]objectForKey:@"fav"];
    cell.labelComment.text=[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row]objectForKey:@"commentNum"];
    cell.labelCollection.text=[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row]objectForKey:@"like"];
    NSString*title=[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row]objectForKey:@"title"];
    
    NSArray*arrTemp=[title componentsSeparatedByString:@"."];
    if (arrTemp.count==2) {
        cell.labelTitle.text=[arrTemp objectAtIndex:1];
    }else{
        cell.labelTitle.text=title;
    }
    
    cell.labelBrand.text=[[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"productInfo"] objectForKey:@"typename"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"class"] isEqualToString:@"5"]) {
        YYShowDetailsViewController*showDetails=[[YYShowDetailsViewController alloc]init];
        [self.navigationController pushViewController:showDetails animated:YES];
        showDetails.strID=[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"id"];
        showDetails.typeID=[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"typeid"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Hidden_Tabbar" object:nil userInfo:nil];
    }else{
        YYBrandContentViewController*brandContent=[[YYBrandContentViewController alloc]init];
        [self.navigationController pushViewController:brandContent animated:YES];
        brandContent.strID=[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"id"];
        brandContent.strTitles=[[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"productInfo"] objectForKey:@"typename"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Hidden_Tabbar" object:nil userInfo:nil];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (IBAction)btnCollectionAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
       self.distance_Line.constant=0;
    }];
    [self createRequest];
}

-(void)createRequest{
    
    if ([type isEqualToString:@"1"]||[type isEqualToString:@"2"]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString*body=[NSString stringWithFormat:@"action=v1&page=1&maxsize=10&mid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]];
            NSString*strUrl;
            if ([type isEqualToString:@"1"]) {
                strUrl=@"/document/list_fav.php";
            }else if ([type isEqualToString:@"2"]){
                strUrl=@"/document/list_like.php";;
            }else{
                
            }
            GetData*getData=[GetData getdataWithUrl:strUrl Body:body];
            dictCollection=getData.dict;
            NSLog(@"dict====5555===%@",dictCollection);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [tableViewMe reloadData];
            });
        });
 
    }else{
       dispatch_async(dispatch_get_global_queue(0, 0), ^{
           NSArray*arr= [[NSUserDefaults standardUserDefaults] objectForKey:@"recordArr"];
           NSLog(@"arr-----%@",arr);
           NSString*strTemp=[[NSString alloc]init];
           if (arr.count>=1) {
               strTemp=[arr objectAtIndex:0];
           }
           for (int i=1; i<arr.count; i++) {
               strTemp =[NSString stringWithFormat:@"%@,%@",strTemp ,[arr objectAtIndex:i]];
           }
           NSLog(@"strTemp-----------%@",strTemp);
           
           NSString*strBody=[NSString stringWithFormat:@"action=v1&page=1&maxsize=10&ids=%@",strTemp];
           GetData*getData=[GetData getdataWithUrl:@"/document/list_myview.php" Body:strBody];
           dictCollection=getData.dict;
           
           dispatch_async(dispatch_get_main_queue(), ^{
               [tableViewMe reloadData];
           });
           
       });
    }
}

- (IBAction)btnLoveAction:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
    self.distance_Line.constant=SCREEN_W/3;
    }];
}

- (IBAction)btnSeeAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.distance_Line.constant=SCREEN_W/3*2;
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:@"3"]) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"delete");
        if ([type isEqualToString:@"1"]) {
          dispatch_async(dispatch_get_global_queue(0, 0), ^{
              NSString*strBody=[NSString stringWithFormat:@"action=v1&mid=%@&aid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"id"]];
              GetData*getData=[GetData getdataWithUrl:@"/document/fav_cancel.php" Body:strBody];
            
//              NSLog(@"删除---%@",getData.dict);
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self createRequest];
                  if ([[getData.dict objectForKey:@"status"] isEqualToString:@"success"])   {
                       [ProgressHUD showSuccess:@"删除成功"];
                  }else{
                      [ProgressHUD showError:@"删除失败"];
                  }
              });
          });
        }else if ([type isEqualToString:@"2"]){
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString*strBody=[NSString stringWithFormat:@"action=v1&mid=%@&aid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],[[[dictCollection objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"id"]];
                GetData*getData=[GetData getdataWithUrl:@"/document/like_cancel.php" Body:strBody];
                NSLog(@"getData=%@",getData.dict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self createRequest];
                    if ([[getData.dict objectForKey:@"status"] isEqualToString:@"success"])   {
                        [ProgressHUD showSuccess:@"删除成功"];
                    }else{
                        [ProgressHUD showError:@"删除失败"];
                        
                    }
                });
            });
        }
    }
}

@end
