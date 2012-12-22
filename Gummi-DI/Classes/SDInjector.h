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
- (void)removeModule:(SDModule *)module;
- (void)removeModuleClass:(Class)moduleClass;

- (BOOL)hasModule:(SDModule *)module;
- (BOOL)hasModuleClass:(Class)moduleClass;

@end