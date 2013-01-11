//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "SubObject1.h"

@class Sub2Dependency;

@interface SubObject2 : SubObject1
@property(nonatomic, strong) Sub2Dependency *sub2Dependency;
@end