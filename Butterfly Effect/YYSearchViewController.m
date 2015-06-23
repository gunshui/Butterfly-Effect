//
//  YYSearchViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/23.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "YYSearchViewController.h"

@interface YYSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UITableView*searchTableView;
    UISearchBar*aSearchBar;
    UISearchDisplayController*searchDisplay;
}
@end

@implementation YYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creataTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)creataTableView{
    searchTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
    searchTableView.delegate=self;
    searchTableView.dataSource=self;
    //    searchTableView.backgroundColor=[UIColor redColor];
    [self.view addSubview:searchTableView];
    //    searchTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    UILabel*hotLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 30)];
    hotLable.textColor=[UIColor colorWithRed:88.0/255.0 green:85.0/255.0 blue:182.0/255.0 alpha:1];
    hotLable.text=@"热门搜索:";
    hotLable.font=[UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:15];
    [searchTableView addSubview:hotLable];
    
    aSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    aSearchBar.placeholder=@"请输入歌曲名";
    //拿到textField
    UITextField*textField=[[[[aSearchBar subviews]objectAtIndex:0] subviews] lastObject];
    NSMutableAttributedString*attStr=[[NSMutableAttributedString alloc]initWithString:@"请输入歌曲名" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:14]}];
    
    //    NSLog(@"class===%@",[[[[[aSearchBar subviews] objectAtIndex:0] subviews] lastObject] class]);
    textField.attributedPlaceholder=attStr;
    
    
    searchTableView.tableHeaderView=aSearchBar;
    aSearchBar.delegate=self;
    searchDisplay=[[UISearchDisplayController alloc]initWithSearchBar:aSearchBar contentsController:self];
    //    searchDisplay.searchResultsTableView.separatorStyle=UITableViewce
    searchDisplay.searchResultsDataSource=self;
    searchDisplay.searchResultsDelegate=self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //搜索页面
    if (tableView==searchDisplay.searchResultsTableView)
    {
        return 10;
    }
    //    return 10;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==searchDisplay.searchResultsTableView) {
        return 0.0001;
    }
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==searchDisplay.searchResultsTableView) {
        return 50;
    }
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //搜索页面
//    if(tableView==searchDisplay.searchResultsTableView){
//        
//       
//        return nil;
//    }
//    return nil;
        static NSString*ident=@"CELL";
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
    
    
        cell.textLabel.font=[UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:15];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    
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
