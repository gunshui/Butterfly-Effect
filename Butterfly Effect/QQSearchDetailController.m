//
//  QQSearchDetailController.m
//  Butterfly Effect
//
//  Created by digime on 15/7/1.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQSearchDetailController.h"

#import "YYShowDetailsViewController.h"
#import "YYBrandContentViewController.h"

@interface QQSearchDetailController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSDictionary*dictSearch;
    int numSearch;
}
@end

@implementation QQSearchDetailController
@synthesize tableViewSearch;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    
    [self createRequest];
    
    //右拉手势
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
}
-(void)createRequest{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString*strBody=[NSString stringWithFormat:@"action=v2&maxsize=10&page=1&keyword=%@&classid=",self.keyword];
        GetData*getData=[GetData getdataWithUrl:@"/document/list_search.php" Body:strBody];
        NSLog(@"search====%@",getData.dict);
        dictSearch=getData.dict;
        if ([[dictSearch objectForKey:@"status"]isEqualToString:@"ok"]) {
            numSearch=(int)[[dictSearch objectForKey:@"msg"] count];
        }else{
            numSearch=0;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableViewSearch reloadData];
        });
        
    });

}
-(void)createNavigation{
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    self.title=self.keyword;
    //返回
    UIButton*btnLeft=[[UIButton alloc]initWithFrame:KRect(0, 0, 20, 20)];
    [btnLeft setImage:KImage(@"返回按钮") forState:0];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barLeft;


}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return numSearch;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*identifier=@"detailSearch";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.font=[UIFont fontWithName:FONTNAME size:13];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"class"] isEqualToString:@"5"]) {
        YYShowDetailsViewController*showDetails=[[YYShowDetailsViewController alloc]init];
        [self.navigationController pushViewController:showDetails animated:YES];
        showDetails.strID=[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"id"];
        showDetails.typeID=[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"typeid"];
        
    }else{
        YYBrandContentViewController*brandContent=[[YYBrandContentViewController alloc]init];
        [self.navigationController pushViewController:brandContent animated:YES];
        brandContent.strID=[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"id"];
        brandContent.strTitles=[[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"productInfo"] objectForKey:@"typename"];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(void)btnLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
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
