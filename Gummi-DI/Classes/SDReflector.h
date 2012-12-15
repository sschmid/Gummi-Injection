//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>


@interface SDReflector : NSObject
+ (Class)getTypeForProperty:(NSString *)propertyName ofClass:(Class)aClass;

@end