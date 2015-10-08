//
//  UTF8FileParser.h
//  ReadTxtFromFile
//
//  Created by Enzo Yang on 11-8-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//前缀 EF BB BF

@interface FileStringData : NSObject
{
  NSString *_string;
  NSArray* _char_indexes;
  int _file_pos_from; //包含
  int _file_pos_to; //不包含
}

@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) NSArray* char_indexes;
@property int file_pos_from;
@property int file_pos_to;

@end


@interface UTF8FileParser : NSObject {
	int _file_start_pos; //在文件中内容开始的位置, 有前缀就是3, 没有前缀就是0
  int _file_length; //文件总长度, 使用者得到的长度是 _file_length-_file_start_pos
  int _data_start_pos;
  int _data_end_pos; //不包含
  int _line_max_char_count;
  NSData *_data; //
  NSString *_file_path;
}
// 外部的position都是减去了_file_start_pos的
// 提供文件的路径， 以及大概开始阅读的位置
- (id) initWithFilePath:(NSString *)file_path aboutPosition:(int)position lineMaxCharCount:(int)line_max_char_count;
// 从某个位置开始，取包含最多char_count个字符的字符串， isSure是问，某个位置是否一定是一个字符的起点
- (FileStringData*) readForwardFrom:(int)from forCharCount:(int)char_count Sure:(BOOL)isSure;
// 从某个位置开始(不包括那个位置), 向回读取char_count个以上字符（如果没读到最前面）, 还向前读大约占一行空间的字符（遇到换行就不读了）
- (FileStringData*) readBackwardBefore:(int)before forCharCount:(int)char_count;
// 取得某个位置的的字符的开头位置
- (int)getCharactorStartPointOfPosition:(int)position;
// 取得文件大小(不包括utf8前缀的)
- (int)getFileLength;
// 设置每行最大字符数
- (void)setLineMaxCharCount:(int)line_max_char_count;
// 从某个位置开始找， 不循环
- (int)findString:(NSString*)string fromPosition:(int)position;
// 取得utf8前缀的长度 用于文件合并(2011-10-21)
- (int)getFileStartPosition;
@end
