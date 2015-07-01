//
//  QQSearchDetailController.h
//  Butterfly Effect
//
//  Created by digime on 15/7/1.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQSearchDetailController : UIViewController
@property(nonatomic,retain)NSString*keyword;

@property (weak, nonatomic) IBOutlet UITableView *tableViewSearch;

@end
