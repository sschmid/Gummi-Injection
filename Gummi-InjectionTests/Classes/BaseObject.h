//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class BaseDependency;

@interface BaseObject : NSObject
@property(nonatomic, strong) BaseDependency *baseDependency;
@end