//
//  ZUtil.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZUtil.h"
#import "AppConfig.h"
#import "ZDBManager.h"

@implementation ZUtil

+ (CGFloat)heightForText:(NSString *)text attr:(NSDictionary *)dict {
    return [text boundingRectWithSize:CGSizeMake(CONTENT_WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size.height;
}

//据字长 分页 存入db
+ (void)paging:(NSString *)bookID fontSize:(int)fontSize {
    NSString* document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* path = [[document stringByAppendingPathComponent:bookID] stringByAppendingPathExtension:@"txt"];
    
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;
    paragraphStyle.paragraphSpacing = 10.0;
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle,
                           NSForegroundColorAttributeName:[UIColor blackColor],
                           NSStrokeWidthAttributeName:[NSNumber numberWithFloat:0.0f]};
    
    CGFloat height = [ZUtil heightForText:content attr:dict];
    NSInteger pages = ceil(height); //计算pages
    
    [[ZDBManager manager] updatefield:@"book_pages" val:[NSString stringWithFormat:@"%ld", pages] bookID:bookID];//存 pages
    [[ZDBManager manager] updatefield:@"book_charCount" val:[NSString stringWithFormat:@"%ld", content.length] bookID:bookID]; //存 字数
}

@end
