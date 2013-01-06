//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <objc/runtime.h>
#import "GIReflector.h"

static NSString *const GIReflectorException = @"GIReflectorException";

@implementation GIReflector

+ (id)getTypeForProperty:(NSString *)propertyName ofClass:(Class)aClass {
    objc_property_t property = class_getProperty(aClass, [propertyName UTF8String]);
    if (!property)
        @throw [NSException exceptionWithName:GIReflectorException reason:[NSString stringWithFormat:@"Property declaration for propertyName: '%@' does not exist", propertyName] userInfo:nil];

    NSString *attributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];

    NSRange startRange = [attributes rangeOfString:@"T@\""];
    if (startRange.location == NSNotFound)
        @throw [NSException exceptionWithName:GIReflectorException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];

    NSString *startOfClassName = [attributes substringFromIndex:startRange.length];

    NSRange endRange = [startOfClassName rangeOfString:@"\""];
    if (endRange.location == NSNotFound)
        @throw [NSException exceptionWithName:GIReflectorException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];

    if ([[startOfClassName substringToIndex:1] isEqualToString:@"<"])
        return NSProtocolFromString([[startOfClassName substringFromIndex:1] substringToIndex:endRange.location - 2]);
    else
        return NSClassFromString([startOfClassName substringToIndex:endRange.location]);
}

+ (BOOL)isProtocol:(id)object {
    if (!object)
        return NO;

    return [object_getClass(object) isEqual:object_getClass(@protocol(NSObject))];
}

+ (BOOL)isClass:(id)object {
    if (!object)
        return NO;

    return class_isMetaClass(object_getClass(object));
}

+ (BOOL)isInstance:(id)object {
    if (!object)
        return NO;

    return ![self isClass:object] && ![self isProtocol:object];
}

@end