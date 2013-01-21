//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "ObjectWithDependency.h"

@class Sub1Dependency;

@interface SubObjectWithDependency1 : ObjectWithDependency
@property(nonatomic, strong) Sub1Dependency *sub1Dependency;
@end