//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "SingletonModule.h"
#import "GIInjector.h"
#import "SingletonFoo.h"


@implementation SingletonModule

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    [self mapSingleton:[SingletonFoo class] to:[SingletonFoo class]];
}

@end