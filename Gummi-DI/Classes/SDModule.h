//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDInjectionMapper.h"

@class SDInjector;


@interface SDModule : NSObject <SDInjectionMapper> {
    SDInjector *_injector;
    NSMutableDictionary*_context;
}

- (void)configure:(SDInjector *)injector;
- (void)unload;


@end