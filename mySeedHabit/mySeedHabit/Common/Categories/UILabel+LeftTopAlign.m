//
//  UILabel+LeftTopAlign.m
//  mySeedHabit
//
//  Created by cjf on 8/12/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UILabel+LeftTopAlign.h"

@implementation UILabel (LeftTopAlign)


/**
 *  文字居左上对齐
 */
- (void) textLeftTopAlign
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.f], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    //    CGRect dateFrame =CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, labelSize.height);
    CGRect dateFrame =CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, labelSize.height);
    self.frame = dateFrame;
    
}


@end
