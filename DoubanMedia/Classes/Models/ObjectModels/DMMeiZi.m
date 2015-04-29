//
//  DMMeiZi.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMeiZi.h"
#import "DMMeiZiConstant.h"

@implementation DMMeiZi


- (void)setPath:(NSString *)path {
    _path = [PIC_HOST stringByAppendingString:path];
}

- (NSAttributedString *)attributedCaptionTitle {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    return [[NSAttributedString alloc] initWithString:_title attributes:attributes];
}
@end
