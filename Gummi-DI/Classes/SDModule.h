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
    NSMutableArray *_context;
}

@property(nonatomic, strong, readonly) NSArray *context;

- (void)configure:(SDInjector *)injector;

@end