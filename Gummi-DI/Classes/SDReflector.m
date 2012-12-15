//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <objc/runtime.h>
#import "SDReflector.h"

static NSString *const SDReflectorException = @"SDReflectorException";

@implementation SDReflector

// see: https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
+ (Class)getTypeForProperty:(NSString *)propertyName ofClass:(Class)aClass {
    objc_property_t property = class_getProperty(aClass, [propertyName UTF8String]);
    if (!property)
        @throw [NSException exceptionWithName:SDReflectorException reason:[NSString stringWithFormat:@"Property declaration for propertyName: '%@' does not exist", propertyName] userInfo:nil];

    NSString *attributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];

    NSRange startRange = [attributes rangeOfString:@"T@\""];
    if (startRange.location == NSNotFound)
        @throw [NSException exceptionWithName:SDReflectorException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'. Did you type your property properly?", propertyName] userInfo:nil];

    NSString *startOfClassName = [attributes substringFromIndex:startRange.length];

    NSRange endRange = [startOfClassName rangeOfString:@"\""];
    if (endRange.location == NSNotFound)
        @throw [NSException exceptionWithName:SDReflectorException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'. Did you type the property properly?", propertyName] userInfo:nil];

    return NSClassFromString([startOfClassName substringToIndex:endRange.location]);
}

@end