//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "GIInjectionMapper.h"

@class GIModule;
@class GIInjectorEntryFactory;

#define inject(args...) +(NSSet *)desiredProperties {return [NSSet setWithObjects: args, nil];}

@interface GIInjector : NSObject <GIInjectionMapper>

+ (GIInjector *)sharedInjector;

- (id)getObject:(id)type;

- (void)injectIntoObject:(id)object;

- (void)addModule:(GIModule *)module;
- (void)removeModule:(GIModule *)module;
- (void)removeModuleClass:(Class)moduleClass;

- (BOOL)hasModule:(GIModule *)module;
- (BOOL)hasModuleClass:(Class)moduleClass;

- (void)reset;
@end