//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "SingletonFooModule.h"
#import "GIInjector.h"
#import "SingletonFoo.h"

@implementation SingletonFooModule

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    [self mapSingleton:[SingletonFoo class] to:[SingletonFoo class]];
}

@end