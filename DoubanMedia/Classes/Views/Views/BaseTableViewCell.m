//
//  BaseTableViewCell.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UIImage+DMResizeImage.h"
@implementation BaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //设置背景
        [self setBackgroundColor:[UIColor clearColor]];
        self.backgroundView=[[UIImageView alloc]initWithImage:
                             [UIImage ResizeThePicture:@"cell_bg@2x.png"
                                     WithUIEdgeInserts: UIEdgeInsetsMake(10, 10, 10, 10)
                                          resizingMode:UIImageResizingModeStretch]];

        self.selectedBackgroundView =[[UIImageView alloc]initWithImage:
                                      [UIImage ResizeThePicture:@"cell_bg@2x.png"
                                              WithUIEdgeInserts: UIEdgeInsetsMake(10, 10, 10, 10)
                                                   resizingMode:UIImageResizingModeStretch]];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
