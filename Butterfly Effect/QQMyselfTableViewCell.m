//
//  QQMyselfTableViewCell.m
//  Butterfly Effect
//
//  Created by digime on 15/6/17.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQMyselfTableViewCell.h"

@implementation QQMyselfTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.labelBrand.adjustsFontSizeToFitWidth=YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.width_distance.constant=SCREEN_W/3-7;
        });

//    self.width_distance.constant=50;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
