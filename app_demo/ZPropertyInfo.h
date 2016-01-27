//
//  ZPropertyInfo.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/27.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPropertyInfo : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic) ZPropertyType type;
@property (nonatomic, assign) Class modelSubClass;


+ (NSMutableDictionary*)propertyInfosWithClass:(Class)cls;
+ (NSArray*)propertyNamesWithClass:(Class)cls;
+ (NSMutableDictionary*)objectProperties;
@end
