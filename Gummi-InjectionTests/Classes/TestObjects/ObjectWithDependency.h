//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@class SomeDependency;

@interface ObjectWithDependency : NSObject
@property(nonatomic, strong) SomeDependency *someDependency;
@end