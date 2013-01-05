//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "MyModule.h"
#import "GIInjector.h"
#import "SingletonFoo.h"


@implementation MyModule

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    [self mapSingleton:[SingletonFoo class] to:[SingletonFoo class] lazy:YES];
}

@end