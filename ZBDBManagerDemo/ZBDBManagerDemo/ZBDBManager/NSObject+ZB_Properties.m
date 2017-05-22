//
//  NSObject+ZB_Properties.m
//  ZBDBManager
//
//  Created by 瞄财网 on 2017/5/18.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import "NSObject+ZB_Properties.h"

@implementation NSObject (ZB_Properties)


+ (NSDictionary *)ZB_allProperties
{
    unsigned int zb_count = 0;
    NSMutableDictionary *dicM = @{}.mutableCopy;
    objc_property_t *properties = class_copyPropertyList([self class], &zb_count);
    for (NSUInteger i = 0; i < zb_count; i ++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [self valueForKey:name];
        if (propertyValue) {
            dicM[name] = propertyValue;
        } else {
            dicM[name] = @"";
        }
    }
    free(properties);
    return dicM;
}

- (NSDictionary *)getPropertiesDict
{
    unsigned int zb_count = 0;
    NSMutableDictionary *dictM = @{}.mutableCopy;
    objc_property_t *properties = class_copyPropertyList([self class], &zb_count);
    NSArray *allowDBProperties = nil;
    if ([[self class] respondsToSelector:@selector(ZB_allowedDBPropertyNames)]){
        allowDBProperties = [[self class] ZB_allowedDBPropertyNames];
    }
    NSArray *ignoreDBPropertyNames = nil;
    if ([[self class] respondsToSelector:@selector(ZB_ignoredDBPropertyNames)]){
        ignoreDBPropertyNames = [[self class] ZB_ignoredDBPropertyNames];
    }
    
    if (allowDBProperties.count) {
        for (NSUInteger i = 0; i < zb_count; i ++) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            if ([allowDBProperties containsObject:name]) {
                id value = [self valueForKey:name];
                value = value ?: [NSNull null];
                [dictM setValue:value forKey:name];
            }
        }
        free(properties);
        return dictM;
    }
    
    for (NSUInteger i = 0; i < zb_count; i ++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        if (![ignoreDBPropertyNames containsObject:name]) {
            id value = [self valueForKey:name];
            value = value ?: [NSNull null];
            [dictM setValue:value forKey:name];
        }
    }
    free(properties);
    return dictM;

}

+ (instancetype)getPropertiesAndTypeDict
{
    
    return [[self alloc] init];
//    unsigned int zb_count = 0;
//    Ivar *ivars = class_copyIvarList(self, &zb_count);
//    for (int i = 0; i < zb_count; i ++) {
//        Ivar ivar = ivars[i];
//        const char *name = ivar_getName(ivar);
//        const char *type = ivar_getTypeEncoding(ivar);
//        NSString *propertyName = [[NSString stringWithUTF8String:name] stringByReplacingOccurrencesOfString:@"_" withString:@""];
//        
//        
//    }
    
}

@end
