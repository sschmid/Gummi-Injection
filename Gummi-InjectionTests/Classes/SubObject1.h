//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@class Sub1Dependency;

@interface SubObject1 : BaseObject
@property(nonatomic, strong) Sub1Dependency *sub1Dependency;
@end