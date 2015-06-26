//
//  QQHomeTableViewCell.h
//  Butterfly Effect
//
//  Created by digime on 15/6/10.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageBrand;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;
@property (weak, nonatomic) IBOutlet UILabel *labelHeart;
@property (weak, nonatomic) IBOutlet UILabel *labelCollection;

@end
