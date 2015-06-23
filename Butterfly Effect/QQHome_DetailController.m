//
//  QQHome_DetailController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/12.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQHome_DetailController.h"

@interface QQHome_DetailController ()

@end

@implementation QQHome_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creataNavigation];
}
-(void)creataNavigation{
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:22]};
   
    //返回
    UIButton*btnLeft=[[UIButton alloc]initWithFrame:KRect(0, 0, 20, 20)];
    [btnLeft setImage:KImage(@"返回按钮") forState:0];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barLeft;

    
}
-(void)btnLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"Show_Tabbar" object:nil userInfo:nil];
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
