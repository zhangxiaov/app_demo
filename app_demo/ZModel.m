//
//  ZModel.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZModel.h"
#import "ZPropertyInfo.h"

@implementation ZModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if ([coder isKindOfClass:[NSKeyedUnarchiver class]]) {
        NSArray* array = [ZPropertyInfo propertyNamesWithClass:[self class]];
        for (NSString* property in array) {
            id value = [coder decodeObjectForKey:property];
            if (value) {
                [self setValue:value forKey:property];
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    NSArray* propertyNames = [ZPropertyInfo propertyNamesWithClass:[self class]];
    for (NSString* propertyName in propertyNames) {
        id value = [self valueForKey:propertyName];
        if (value != nil && [value conformsToProtocol:@protocol(NSCoding)]) {
            [aCoder encodeObject:value forKey:propertyName];
        }
    }
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (![self jsonKeyAndClassPropertyMap]) {
            [self setPropertiesWithReflect:dict];
        }else {
            [self setPropertiesWithMap:dict];
        }
    }
    return self;
}

- (NSDictionary *)jsonKeyAndClassPropertyMap {
    return nil;
}

- (void)setPropertiesWithReflect:(NSDictionary*)data {
    if (!data) {
        return;
    }
    
    NSArray* keys = [data allKeys];
    for (NSString* key in keys) {
        ZPropertyInfo* propertyInfo = [ZPropertyInfo propertyInfosWithClass:[self class]][key];
        id value = data[key];
        
        if (propertyInfo) {
            switch (propertyInfo.type) {
                case ZPropertyTypeNone:
                    [self setValue:value forKey:propertyInfo.name];
                    break;
                case ZPropertyTypeBOOL:
                    [self setValue:[NSNumber numberWithBool:[ZModel boolWithValue:value]] forKey:propertyInfo.name];
                    break;
                case ZPropertyTypeDouble:
                    [self setValue:[NSNumber numberWithDouble:[ZModel doubleWithValue:value]] forKey:propertyInfo.name];
                    break;
                case ZPropertyTypeFloat:
                    [self setValue:[NSNumber numberWithFloat:[ZModel floatWithValue:value]] forKey:propertyInfo.name];
                    break;
                case ZPropertyTypeInt16:
                    [self setValue:[NSNumber numberWithShort:[ZModel int16WithValue:value]] forKey:propertyInfo.name];
                    break;
                case ZPropertyTypeInt32:
                    [self setValue:[NSNumber numberWithInt:[ZModel int32WithValue:value]] forKey:propertyInfo.name];
                    break;
                case ZPropertyTypeInt64:
                    [self setValue:[NSNumber numberWithLongLong:[ZModel int64WithValue:value]] forKey:propertyInfo.name];
                    break;
                case ZPropertyTypeNumber:
                    [self setValue:[ZModel numberWithValue:value] forKey:propertyInfo.name];
                    break;
                case ZPropertyTypeDate:
                    [self setValue:[ZModel dateWithValue:value] forKey:propertyInfo.name];
                    break;
                case ZPropertyTypeModel: {
                    NSDictionary* dict = [ZModel dictionaryWithValue:value];
                    if (dict != nil) {
                        ZModel* model = [[propertyInfo.modelSubClass alloc] init];
                        [model setPropertiesWithReflect:dict];
                        [self setValue:model forKey:propertyInfo.name];
                    }
                    else
                        [self setValue:nil forKey:propertyInfo.name];
                    
                } break;
                case ZPropertyTypeArray:
                case ZPropertyTypeMutableArray: {
                    NSArray* array = [ZModel arrayWithValue:value];
                    if (array != nil) {
                        NSMutableArray* models = [NSMutableArray array];
                        for (NSInteger i = 0; i < array.count; i++) {
                            NSDictionary* dict = [ZModel dictionaryWithValue:array[i]];
                            if (dict != nil) {
                                if (propertyInfo.modelSubClass) {
                                    ZModel* model = [[propertyInfo.modelSubClass alloc] init];
                                    [model setPropertiesWithReflect:dict];
                                    [models addObject:model];
                                }
                                else {
                                    [models addObject:dict];
                                }
                            }
                        }
                        
                        [self setValue:models forKey:propertyInfo.name];
                    }
                    else
                        [self setValue:nil forKey:propertyInfo.name];
                } break;
                case ZPropertyTypeDictionary: {
                    [self setValue:[ZModel dictionaryWithValue:value] forKey:propertyInfo.name];
                } break;
                case ZPropertyTypeMutableDictionary: {
                    NSDictionary* dictValue = [ZModel dictionaryWithValue:value];
                    if (dictValue != nil)
                        [self setValue:[ZModel deepMutableCopyWithValue:dictValue] forKey:propertyInfo.name];
                    else
                        [self setValue:nil forKey:propertyInfo.name];
                } break;
                case ZPropertyTypeString:
                    [self setValue:[ZModel stringWithValue:value] forKey:propertyInfo.name];
                    break;
                case ZPropertyTypeMutableString: {
                    NSString* strValue = [ZModel stringWithValue:value];
                    if (value != nil)
                        [self setValue:[ZModel deepMutableCopyWithValue:strValue] forKey:propertyInfo.name];
                    else
                        [self setValue:nil forKey:propertyInfo.name];
                } break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)setPropertiesWithMap:(NSDictionary*)data {
    NSDictionary* jpmap = [self jsonKeyAndClassPropertyMap];
    NSArray* jsonKeys = [jpmap allKeys];
    NSMutableDictionary* tempDic = [[NSMutableDictionary alloc] initWithCapacity:jsonKeys.count];
    for (NSString* jsonkey in jsonKeys) {
        id propertyName = jpmap[jsonkey];
        if (propertyName) {
            [tempDic setObject:data[jsonkey] forKey:propertyName];
        }
    }
    
    [self setPropertiesWithReflect:tempDic];
    
    //得到属性对应的Setter方法
//    SEL setSel = [self createSetterWithPropertyName:propertyName];
//    [self performSelectorOnMainThread:setSel withObject:data[jsonkey] waitUntilDone:[NSThread isMainThread]];
}

- (SEL)createSetterWithPropertyName:(NSString*)propertyName
{
    //首字母大写
    NSString* firstStr = [propertyName substringToIndex:1];
    firstStr = firstStr.capitalizedString;
    NSString* otherStr = [propertyName substringFromIndex:1];
    propertyName = [NSString stringWithFormat:@"%@%@", firstStr, otherStr];
    
    //拼接set
    propertyName = [NSString stringWithFormat:@"set%@:", propertyName];
    
    return NSSelectorFromString(propertyName);
}

+ (NSString*)stringWithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}


+ (NSInteger)integerWithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}


+ (BOOL)boolWithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}


+ (int16_t)int16WithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}


+ (int32_t)int32WithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}


+ (int64_t)int64WithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    }
    return 0;
}


+ (short)shortWithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}


+ (float)floatWithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    }
    return 0;
}


+ (double)doubleWithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    return 0;
}


+ (NSNumber*)numberWithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return @(0);
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithInt:((NSString*)value).intValue];
    }
    return @(0);
}


+ (NSDate*)dateWithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSDate class]]) {
        return (NSDate*)value;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[value longLongValue] / 1000];
    }
    return nil;
}


+ (id)arrayWithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}


+ (id)dictionaryWithValue:(id)value
{
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

+ (id)deepMutableCopyWithValue:(id)value
{
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        return [NSMutableString stringWithFormat:@""];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return [NSMutableString stringWithFormat:@"%@", value];
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (id value in value) {
            [array addObject:[ZModel deepMutableCopyWithValue:value]];
        }
        return array;
    }
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        for (NSString* key in value) {
            id theValue = [ZModel deepMutableCopyWithValue:value[key]];
            [dict setObject:theValue forKey:key];
        }
        return dict;
    }
    
    return value;
}

@end
