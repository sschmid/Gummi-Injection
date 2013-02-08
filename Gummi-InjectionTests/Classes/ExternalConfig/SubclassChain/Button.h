//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "Component.h"

@class Target;

@interface Button : Component
@property(nonatomic, strong) Target *target;
@end