//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@class SingletonFoo;

@interface SingletonBar : NSObject
@property(nonatomic, strong) SingletonFoo *foo;

@end