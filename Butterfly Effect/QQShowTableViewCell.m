//
//  QQShowTableViewCell.m
//  Butterfly Effect
//
//  Created by digime on 15/6/15.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQShowTableViewCell.h"

@implementation QQShowTableViewCell
@synthesize line,imaeViewBK;


- (void)awakeFromNib {
    // Initialization code
    line.backgroundColor=[UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:0.3];
    imaeViewBK.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    self.selectionStyle=UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
