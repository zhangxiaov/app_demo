//
//  ZPropertyInfo.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/27.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZPropertyInfo.h"
#include <objc/runtime.h>
#import "ZModel.h"

//stack for speed
static NSMutableDictionary* classPropertyInfosDic;
static NSMutableDictionary* classPropertyNameDic;


@implementation ZPropertyInfo

+ (NSMutableDictionary*)objectProperties
{
    static NSMutableDictionary* s_map = nil;
    if (s_map == nil) {
        s_map = [NSMutableDictionary dictionary];
        Protocol* protocol = objc_getProtocol("NSObject");
        unsigned count = 0;
        objc_property_t* properties = protocol_copyPropertyList(protocol, &count);
        for (unsigned i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString* propertyName = [NSString stringWithUTF8String:property_getName(property)];
            [s_map setObject:propertyName forKey:propertyName];
        }
        free(properties);
        
        // IOS7及以前应对
        if (s_map.count == 0) {
            [s_map setObject:@"hash" forKey:@"hash"];
            [s_map setObject:@"superclass" forKey:@"superclass"];
            [s_map setObject:@"description" forKey:@"description"];
            [s_map setObject:@"debugDescription" forKey:@"debugDescription"];
        }
    }
    return s_map;
}

+ (NSMutableDictionary*)propertyInfosWithClass:(Class)cls {
    NSString* className = [NSString stringWithUTF8String:class_getName(cls)];
    if ([classPropertyInfosDic objectForKey:className]) {
        return [classPropertyInfosDic objectForKey:className];
    }else {
        NSMutableDictionary* propertyInfos = [NSMutableDictionary dictionary];
        if ([cls isSubclassOfClass:[ZModel class]]) {
            Class current = cls;
            while (current != [ZModel class]) {
                unsigned int count = 0;
                objc_property_t* properties = class_copyPropertyList(cls, &count);
                for (int i = 0; i < count; i++) {
                    objc_property_t p = properties[i];
                    ZPropertyInfo* pinfo = [ZPropertyInfo attrsWithProperty:&p];
                    if (pinfo != nil) {
                        [propertyInfos setObject:pinfo forKey:pinfo.name];
                    }
                }
                free(properties);
                current = [current superclass];
            }
           
        }
        
        //把结果保存到内存中去
        [classPropertyInfosDic setObject:propertyInfos forKey:className];
        return propertyInfos;
    }
}

+ (ZPropertyInfo*)attrsWithProperty:(objc_property_t*)property {
    ZPropertyInfo* pInfo = [[ZPropertyInfo alloc] init];
    pInfo.name = [NSString stringWithUTF8String:property_getName(*property)];
    
    NSString* attrs = [NSString stringWithUTF8String:property_getAttributes(*property)];
    NSArray* array = [attrs componentsSeparatedByString:@","];
    
    NSString* typeAttr = @"";
    for (NSString* attr in array) {
        if ([attr hasPrefix:@"T"] && attr.length > 1) {
            //类型
            typeAttr = attr;
        }
    }
    if (typeAttr.length > 0) {
        if ([typeAttr hasPrefix:@"Tb"] || [typeAttr hasPrefix:@"TB"] || [typeAttr hasPrefix:@"Tc"] || [typeAttr hasPrefix:@"TC"]) {
            //BOOL
            pInfo.type = ZPropertyTypeBOOL;
        }
        else if ([typeAttr hasPrefix:@"Ti"] || [typeAttr hasPrefix:@"TI"]) {
            //int32
            pInfo.type = ZPropertyTypeInt32;
        }
        else if ([typeAttr hasPrefix:@"Tl"] || [typeAttr hasPrefix:@"TL"]) {
            //int32
            pInfo.type = ZPropertyTypeInt32;
        }
        else if ([typeAttr hasPrefix:@"Tq"] || [typeAttr hasPrefix:@"TQ"]) {
            //int64
            pInfo.type = ZPropertyTypeInt64;
        }
        else if ([typeAttr hasPrefix:@"Ts"] || [typeAttr hasPrefix:@"TS"]) {
            //int16
            pInfo.type = ZPropertyTypeInt16;
        }
        else if ([typeAttr hasPrefix:@"Tf"] || [typeAttr hasPrefix:@"TF"]) {
            //float
            pInfo.type = ZPropertyTypeFloat;
        }
        else if ([typeAttr hasPrefix:@"Td"] || [typeAttr hasPrefix:@"TD"]) {
            //double
            pInfo.type = ZPropertyTypeDouble;
        }
        else if ([typeAttr hasPrefix:@"T@\"NSNumber\""]) {
            //NSNumber
            pInfo.type = ZPropertyTypeNumber;
        }
        else if ([typeAttr hasPrefix:@"T@\"NSDate\""]) {
            //NSDate
            pInfo.type = ZPropertyTypeDate;
        }
        else if ([typeAttr hasPrefix:@"T@\"NSString\""]) {
            //String
            pInfo.type = ZPropertyTypeString;
        }
        else if ([typeAttr hasPrefix:@"T@\"NSMutableString\""]) {
            //MutableString
            pInfo.type = ZPropertyTypeMutableString;
        }
        else if ([typeAttr hasPrefix:@"T@\"NSArray\""]) {
            //Array
            pInfo.type = ZPropertyTypeArray;
        }
        else if ([typeAttr hasPrefix:@"T@\"NSMutableArray\""]) {
            //MutableArray
            pInfo.type = ZPropertyTypeMutableArray;
        }
        else if ([typeAttr hasPrefix:@"T@\"NSDictionary\""]) {
            //Dictionary
            pInfo.type = ZPropertyTypeDictionary;
        }
        else if ([typeAttr hasPrefix:@"T@\"NSMutableDictionary\""]) {
            //MutableDictionary
            pInfo.type = ZPropertyTypeMutableDictionary;
        }
        else if ([typeAttr hasPrefix:@"T@"] && typeAttr.length > 4) {
            //其他对象
            const char* className = [[typeAttr substringWithRange:NSMakeRange(3, typeAttr.length - 4)] cStringUsingEncoding:NSUTF8StringEncoding];
            Class cls = objc_getClass(className);
            if (cls != nil && [cls isSubclassOfClass:[ZModel class]]) {
                //如果是ZModel的子类
                pInfo.type = ZPropertyTypeModel;
                pInfo.modelSubClass = cls;
            }
        }
        
        return pInfo;
    }
    
    return nil;
}

+ (NSArray *)propertyNamesWithClass:(Class)cls {
    NSString* className = [NSString stringWithUTF8String:class_getName(cls)];
    if ([classPropertyInfosDic objectForKey:className]) {
        return [classPropertyInfosDic objectForKey:className];
    }else {
        NSMutableDictionary* mapNSObjectProperties = [ZPropertyInfo objectProperties];
        NSMutableArray* mapPropertyNames = [NSMutableArray array];
        
        if ([cls isSubclassOfClass:[ZModel class]]) {
            Class current = cls;
            while (current != [ZModel class]) {
                unsigned count = 0;
                objc_property_t* properties = class_copyPropertyList(current, &count);
                for (unsigned i = 0; i < count; i++) {
                    objc_property_t property = properties[i];
                    NSString* propertyName = [NSString stringWithUTF8String:property_getName(property)];
                    if ([mapNSObjectProperties objectForKey:propertyName] == nil)
                        [mapPropertyNames addObject:propertyName];
                }
                free(properties);
                current = [current superclass];
            }
        }
        //把结果保存到内存中去
        [classPropertyNameDic setObject:mapPropertyNames forKey:className];
        return mapPropertyNames;
    }
}

@end
