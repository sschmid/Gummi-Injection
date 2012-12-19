//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDInjectionMapper.h"

@class SDModule;

#define inject(args...) +(NSSet *)desiredProperties {return [NSSet setWithObjects: args, nil];}

@interface SDInjector : NSObject <SDInjectionMapper>

+ (SDInjector *)sharedInjector;

- (id)getObject:(id)type;
- (void)injectIntoObject:(id)object;

- (void)addModule:(SDModule *)module;

@end