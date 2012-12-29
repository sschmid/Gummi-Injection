//
// Created by sschmid on 16.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class SingletonBar;


@interface SingletonFoo : NSObject
@property(nonatomic, strong) SingletonBar *bar;

+ (BOOL)isInitialized;


@end