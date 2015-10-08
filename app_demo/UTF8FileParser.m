//
//  UTF8FileParser.m
//  ReadTxtFromFile
//
//  Created by Enzo Yang on 11-8-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UTF8FileParser.h"
//#import "DebugUtil.h"
//在ipod touch 4
//取得文件大小大概5ms
//读200k文件大概20ms
//读3m的文件大概200ms


@implementation FileStringData

@synthesize string = _string;
@synthesize file_pos_from = _file_pos_from;
@synthesize file_pos_to = _file_pos_to;
@synthesize char_indexes = _char_indexes;

- (void)dealloc {
  NSLog(@"FileStringData dealloc");
  self.string = nil;
  self.char_indexes = nil;
//  [super dealloc];
}

@end

//内部的position都是真的position
@interface UTF8FileParser(Private)
-(void) getFileStartPosAndFileLength;
-(void) loadDataAroundPosition:(int)position;
-(void) reloadDataAroundPositionFunc:(NSNumber *)position; //这个函数会事先检查，有没有重新加载的必要
-(BOOL) needToLoadOtherData:(int)from forByteCount:(int)byte_count forward:(BOOL)isForward;
-(int) getStartPointOfTheCharactor:(int)position;
-(FileStringData*) getNChar:(int)char_count fromBytes:(Byte*)bytes maxBytes:(int)total_bytes userStartPosition:(int)user_start_pos;
@end

//离前面只有6k时往回读
#define READ_DATA_BACKWARD_LINE 6000
//离后面只有6k时往前读
#define READ_DATA_FORWARD_LINE 6000
//每重新读一次文件，用户所需要的数据在Data中的大概位置为30k
#define REREAD_DATA_LINE 30000
//每次读取的最大数据量200k
#define MAX_SIZE_READ_A_TIME 100000
//utf8最大的字符占6个字节
#define UTF8_MAX_BYTES 6



@implementation UTF8FileParser

- (id) initWithFilePath:(NSString *)file_path aboutPosition:(int)position lineMaxCharCount:(int)line_max_char_count{
	self = [super init];
  if (self) {
//    _file_path = [file_path retain];
    _line_max_char_count = line_max_char_count;
    [self getFileStartPosAndFileLength];
    NSLog(@"start_pos: %d, oldPosition: %d", _file_start_pos, position);
    NSLog(@"file path %@", file_path);
    position += _file_start_pos;
    //assert(position < _file_length && position >= _file_start_pos);
    if (!(position < _file_length && position >= _file_start_pos)) {
//      [self release];
      return nil;
    }
    [self loadDataAroundPosition:position];
  }
  return self;
}

- (void)dealloc {
  NSLog(@"UTF8FileParser dealloc");
//  [_file_path release];
    _file_path = nil;
//  [_data release];
    _data = nil;
//  [super dealloc];
}

-(void) getFileStartPosAndFileLength {
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:_file_path];
  [fileHandle seekToFileOffset:0];
  int temp_start_pos = 0;
  while (YES) {
    NSData *data = [fileHandle readDataOfLength:3];
    if ([data length] < 3) {
      break;
    }
    Byte utf8Header[3];
    [data getBytes:utf8Header length:3];
    if (utf8Header[0] != 0xef || utf8Header[1] != 0xbb || utf8Header[2] != 0xbf) {
      //_file_start_pos = 0;
      break;
    }
    temp_start_pos += 3;
  }
  _file_start_pos = temp_start_pos;
  _file_length = (int)[fileHandle seekToEndOfFile];
}

- (void)loadDataAroundPosition:(int)position {
  int from = position-REREAD_DATA_LINE;
  from = from<_file_start_pos?_file_start_pos:from;
  int to = from + MAX_SIZE_READ_A_TIME;
  to = to>_file_length?_file_length:to;
  int load_length = to - from;
  if (_data != nil) {
//    [_data release];
      _data = nil;
  }
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:_file_path];
  [fileHandle seekToFileOffset:from];
  _data = [fileHandle readDataOfLength:load_length];
//  [_data retain];
  _data_start_pos = from;
  _data_end_pos = to;
}

-(void) reloadDataAroundPositionFunc:(NSNumber *)position {
//  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  @synchronized(self) {
    int pos = [position intValue];
    if ([self needToLoadOtherData:pos forByteCount:READ_DATA_FORWARD_LINE forward:YES] ||
        [self needToLoadOtherData:pos forByteCount:READ_DATA_BACKWARD_LINE forward:NO]) {
      [self loadDataAroundPosition:pos];
    }
  }
//  [pool release];
}

- (BOOL)needToLoadOtherData:(int)from forByteCount:(int)byte_count forward:(BOOL)isForward{
  int to = from;
  if (isForward) {
    if (from - UTF8_MAX_BYTES < _data_start_pos && _data_start_pos > _file_start_pos) {
      return YES; //与前面太接近, 不安全
    }
    if (_data_end_pos == _file_length) {
      return NO; //读到最后了
    }
    to = from + byte_count;
    if (to > _data_end_pos) {
      return YES;
    }
  } else {
    if (from + UTF8_MAX_BYTES*_line_max_char_count > _data_end_pos && _data_end_pos < _file_length) {
      return YES; //与后面太接近, 不安全
    }
    if (_data_start_pos == _file_start_pos) {
      return NO;
    }
    to = from - byte_count;
    if (to < _data_start_pos+UTF8_MAX_BYTES) {
      return YES;
    }
  }
  return NO;
}

-(int) getStartPointOfTheCharactor:(int)position {
  int inner_pos = position - _data_start_pos;
  while (inner_pos > 0) {
    char c = '\0';
    [_data getBytes:&c range:NSMakeRange(inner_pos, sizeof(c))];
    if ((c & 0x40) == 0 && (c & 0x80) != 0) {
      --inner_pos;
    } else {
      return inner_pos + _data_start_pos;
    }
  }
  return _data_start_pos;
}


-(FileStringData*) getNChar:(int)char_count fromBytes:(Byte*)bytes maxBytes:(int)total_bytes userStartPosition:(int)user_start_pos {
  int word_index = 0;
  int temp_count = 0;
    NSMutableArray* vchar_index = [[NSMutableArray alloc] initWithCapacity:char_count];
  while (word_index < char_count && temp_count < total_bytes) {
    Byte b = bytes[temp_count];
    [vchar_index addObject:[NSNumber numberWithInt:(temp_count+user_start_pos)]];
    word_index += 1;
    if ((b & 0x80) == 0) {
      temp_count += 1;
      continue;
    }
    if ((b & 0x20) == 0) {
      temp_count += 2;
      continue;
    }
    if ((b & 0x10) == 0) {
      temp_count += 3;
      continue;
    }
    if ((b & 0x08) == 0) {
      temp_count += 4;
      continue;
    }
    if ((b & 0x04) == 0) {
      temp_count += 5;
      continue;
    }
    if ((b & 0x02) == 0) {
      temp_count += 6;
      continue;
    }
  }
  NSString* string = nil;
  if (temp_count > 0) {
    NSData* stringData = [NSData dataWithBytes:bytes length:temp_count];
    string = [[NSString alloc] initWithData:stringData
                                             encoding:NSUTF8StringEncoding];
  } else {
    string = @"";
  }


  FileStringData* fsd = [[FileStringData alloc] init];
  fsd.string = string;
  fsd.char_indexes = [vchar_index subarrayWithRange:NSMakeRange(0, [vchar_index count])];
  fsd.file_pos_from = user_start_pos;
  fsd.file_pos_to = user_start_pos + temp_count;
  return fsd;
}


// 从某个位置开始，取包含最多char_count个字符的字符串， isSure是问，某个位置是否一定是一个字符的起点
- (FileStringData*) readForwardFrom:(int)from forCharCount:(int)char_count Sure:(BOOL)isSure {
  FileStringData* file_string_data = nil;
  @synchronized(self) {
    from += _file_start_pos;
    assert(from < _file_length && from >= _file_start_pos);
    if ([self needToLoadOtherData:from forByteCount:char_count*UTF8_MAX_BYTES forward:YES]) {
      [self loadDataAroundPosition:from];
    }
    //if (!isSure) {
      //不肯定是一个字符的起点, 取得字符的起点
      from = [self getStartPointOfTheCharactor:from];
      NSLog(@"from %d", from);
    //}
    int read_end_pos = from+char_count*UTF8_MAX_BYTES;
    int total_bytes = read_end_pos>_data_end_pos?(_data_end_pos-from):(read_end_pos-from);
    Byte *bytes = (Byte*)malloc(total_bytes);
    [_data getBytes:bytes range:NSMakeRange(from-_data_start_pos, total_bytes)];
    //分析出最多char_count个字符并且返回.
    file_string_data = [self getNChar:char_count 
                            fromBytes:(Byte*)bytes 
                             maxBytes:total_bytes 
                    userStartPosition:(from-_file_start_pos)];
    free(bytes);
  }
  [self performSelectorInBackground:@selector(reloadDataAroundPositionFunc:) 
                         withObject:[NSNumber numberWithInt:file_string_data.file_pos_to]];
  return file_string_data;
}


// 从某个位置开始(不包括那个位置), 向前读取char_count个以上字符
- (FileStringData*) readBackwardBefore:(int)before forCharCount:(int)char_count{
  FileStringData *file_string_data = nil;
  @synchronized(self) {
    before += _file_start_pos;
    before = [self getStartPointOfTheCharactor:before];
    
    assert(before < _file_length && before >= _file_start_pos);
    if ([self needToLoadOtherData:before forByteCount:char_count*UTF8_MAX_BYTES forward:NO]) {
      [self loadDataAroundPosition:before];
    }
    //往前读一点，因为可能会用到 
    int read_end_pos = before+_line_max_char_count*UTF8_MAX_BYTES;
    int forward_byte_count = read_end_pos>_data_end_pos?(_data_end_pos-before):(read_end_pos-before);
    Byte *bytes = (Byte *)malloc(forward_byte_count);
    [_data getBytes:bytes range:NSMakeRange(before-_data_start_pos, forward_byte_count)];
    int real_forward_byte_count = 0;
    while ((bytes[real_forward_byte_count] != '\r' && 
            bytes[real_forward_byte_count] != '\n')
           && (real_forward_byte_count < forward_byte_count)){
      ++real_forward_byte_count;
    }
    FileStringData *forward_data = [self getNChar:_line_max_char_count
                                        fromBytes:bytes
                                         maxBytes:real_forward_byte_count
                                userStartPosition:(before-_file_start_pos)];
    
    free(bytes);

    //往回读, 读够那么多个字符， 或者读到尽头
    int read_begin_pos = before-char_count*UTF8_MAX_BYTES;
    read_begin_pos = read_begin_pos<_data_start_pos?_data_start_pos:read_begin_pos;
    read_begin_pos = [self getStartPointOfTheCharactor:read_begin_pos];
    int backward_byte_count = before - read_begin_pos;
    bytes = (Byte *)malloc(backward_byte_count);
    [_data getBytes:bytes range:NSMakeRange(read_begin_pos-_data_start_pos, backward_byte_count)];
    FileStringData *backward_data = [self getNChar:INT_MAX
                                         fromBytes:bytes
                                          maxBytes:backward_byte_count
                                 userStartPosition:(read_begin_pos-_file_start_pos)];
    free(bytes);
    
    //合并前后的内容, ipod touch release 上用时0ms
    int backward_string_length = [backward_data.string length];
    backward_string_length = backward_string_length<char_count?backward_string_length:char_count;
    NSString *backward_string = [backward_data.string substringWithRange:NSMakeRange([backward_data.string length]-backward_string_length, backward_string_length)];
    NSArray *backward_indexes = [backward_data.char_indexes subarrayWithRange:NSMakeRange([backward_data.char_indexes count]-backward_string_length, backward_string_length)];
    
    NSString *result_string = [NSString stringWithFormat:@"%@%@", backward_string, forward_data.string];
    NSMutableArray *result_indexes = [[NSMutableArray alloc] init];
    [result_indexes addObjectsFromArray:backward_indexes];
    [result_indexes addObjectsFromArray:forward_data.char_indexes];
    file_string_data = [[FileStringData alloc] init];
    file_string_data.string = result_string;
    file_string_data.char_indexes = [result_indexes subarrayWithRange:NSMakeRange(0, [result_indexes count])];
    file_string_data.file_pos_from = [(NSNumber*)[result_indexes objectAtIndex:0] intValue];
    file_string_data.file_pos_to = forward_data.file_pos_to==0?backward_data.file_pos_to:forward_data.file_pos_to;
    // 6句NSLog要用20ms
    /*just = [NSDate date];
    NSLog(@"char count getted: %d", [file_string_data.string length]);
    NSLog(@"index count is: %d", [file_string_data.char_indexes count]);
    NSLog(@"index from is : %@", [file_string_data.char_indexes objectAtIndex:0]);
    NSLog(@"index to is : %d", file_string_data.file_pos_to);
    NSLog(@"index of second: %@", [file_string_data.char_indexes objectAtIndex:1]);
    NSLog(@"index of last char: %@", [file_string_data.char_indexes objectAtIndex:([file_string_data.char_indexes count]-1)]);
    now = [NSDate date];
    ti = [now timeIntervalSinceDate:just];
    elapse = (int)(ti * 1000) % 10000;
    NSLog(@"nslog use %dms", elapse);*/
  }
  [self performSelectorInBackground:@selector(reloadDataAroundPositionFunc:) 
                         withObject:[NSNumber numberWithInt:file_string_data.file_pos_from]];
  return file_string_data;
}

// 取得某个位置的的字符的开头位置
- (int)getCharactorStartPointOfPosition:(int)position {
  int start_position = position;
  @synchronized(self) {
    position += _file_start_pos;
    if (position == _file_length) {
      position -= 1;
    }
    assert(position < _file_length && position >= _file_start_pos);
    if ([self needToLoadOtherData:position forByteCount:1*UTF8_MAX_BYTES forward:NO]) {
      [self loadDataAroundPosition:position];
    }
    start_position = [self getStartPointOfTheCharactor:position];
  }
  return start_position - _file_start_pos;
}

- (int)getFileLength {
  return _file_length - _file_start_pos;
}

- (void)setLineMaxCharCount:(int)line_max_char_count {
  @synchronized(self) {
    _line_max_char_count = line_max_char_count;
  }
}

// 从某个位置开始找， 不循环
- (int)findString:(NSString*)string fromPosition:(int)position {
  assert(position >= 0);
  position += _file_start_pos;
  if (position >= _file_length) {
    return NSNotFound;
  }
  const char* utf8str = [string UTF8String];
  int stringlen = strlen(utf8str);
  NSData* dataToFind = [NSData dataWithBytes:utf8str length:stringlen];
  int from = position;
  int to = position;
  while (to < _file_length) {
    NSRange range;
    //每用完一次nsdata就销毁一次
//    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    to = from + MAX_SIZE_READ_A_TIME;
    to = to>_file_length?_file_length:to;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:_file_path];
    [fileHandle seekToFileOffset:from];
    NSData *data = [fileHandle readDataOfLength:(to-from)];
    range = [data rangeOfData:dataToFind
                      options:0
                        range:NSMakeRange(0, [data length])];
//    [pool release];
    if (range.location != NSNotFound) {
      return range.location + from - _file_start_pos;
    } else {
      from = to - 1000;
    }
  }
  return NSNotFound;
}

- (int)getFileStartPosition {
  return _file_start_pos;
}

@end