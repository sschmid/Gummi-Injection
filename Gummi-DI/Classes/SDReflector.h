//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>


// see: https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html

@interface SDReflector : NSObject

+ (id)getTypeForProperty:(NSString *)propertyName ofClass:(Class)aClass;
+ (BOOL)isProtocol:(id)object;
+ (BOOL)isClass:(id)object;
+ (BOOL)isInstance:(id)object;

@end