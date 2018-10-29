//
//  NSObject+Extension.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/5.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (NSString *)ObjectToJson {
    return [NSObject ObjectToJsonWithObjc:self options:NSJSONWritingPrettyPrinted error:nil];
}
+ (NSString*)ObjectToJsonWithObjc:(id)objc options:(NSJSONWritingOptions)options error:(NSError**)error
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self objectToDictionaryWithObjc:objc] options:options error:error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/**
  通过对象返回一个NSDictionary，键是属性名称，值是属性值

 @param objc objc description
 @return return value description
 */
+ (NSDictionary *)objectToDictionaryWithObjc:(id)objc {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([objc class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [objc valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
    
    
    return nil;
}

/**
 *  获取类的内部对象
 *
 *  @param obj 对象
 *
 *  @return jj
 */
+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self objectToDictionaryWithObjc:obj];
}
@end
