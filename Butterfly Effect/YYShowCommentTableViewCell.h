//
//  YYShowCommentTableViewCell.h
//  Butterfly Effect
//
//  Created by lyan on 15/6/24.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYShowCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserPic;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelNumber;

@end
