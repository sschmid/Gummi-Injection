//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "SubObjectWithDependency1.h"

@class Sub2Dependency;

@interface SubObjectWithDependency2 : SubObjectWithDependency1
@property(nonatomic, strong) Sub2Dependency *sub2Dependency;
@end