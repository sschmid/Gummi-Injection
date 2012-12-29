//
// Created by sschmid on 16.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class SingletonFoo;


@interface SingletonBar : NSObject
@property(nonatomic, strong) SingletonFoo *foo;

@end