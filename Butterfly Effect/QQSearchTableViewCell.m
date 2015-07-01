//
//  QQSearchTableViewCell.m
//  Butterfly Effect
//
//  Created by digime on 15/6/30.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQSearchTableViewCell.h"

@implementation QQSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.labelTitle.textColor=[UIColor colorWithRed:88.0/255.0 green:85.0/255.0 blue:182.0/255.0 alpha:1];
    self.labelTitle.font=[UIFont fontWithName:FONTNAME size:14];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
