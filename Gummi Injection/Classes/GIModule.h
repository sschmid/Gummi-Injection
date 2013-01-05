//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "GIInjectionMapper.h"

@class GIInjector;

@interface GIModule : NSObject <GIInjectionMapper> {
    GIInjector *_injector;
    NSMutableDictionary*_context;
}

- (void)configure:(GIInjector *)injector;
- (void)unload;

@end