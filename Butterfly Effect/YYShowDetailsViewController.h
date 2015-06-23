//
//  YYShowDetailsViewController.h
//  Butterfly Effect
//
//  Created by lyan on 15/6/19.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYShowDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webViewShowDetails;
@property (weak, nonatomic) IBOutlet UIButton *btnCollection;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnComments;

@property(nonatomic,retain)NSString*strID;
@property(nonatomic,retain)NSString*typeID;
@property(nonatomic,retain)NSString*isTop;

@end
