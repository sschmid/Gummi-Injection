//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "GIInjectionMapper.h"

@class GIModule;
@class GIInjectorEntryFactory;

#define inject(args...) + (NSSet *)requiredProperties {return [NSSet setWithObjects:args, nil];}
#define injection_complete(selector) + (NSString *)injectionCompleteSelector {return NSStringFromSelector(selector);}

@interface GIInjector : NSObject <GIInjectionMapper>

+ (GIInjector *)sharedInjector;

- (GIInjector *)createChildInjector;

- (void)setDependencies:(NSArray *)propertyNames forClass:(id)aClass;

- (id)getObject:(id)keyObject;

- (void)injectIntoObject:(id)object;

- (void)addModule:(GIModule *)module;
- (void)removeModule:(GIModule *)module;
- (void)removeModuleClass:(Class)moduleClass;

- (BOOL)hasModule:(GIModule *)module;
- (BOOL)hasModuleClass:(Class)moduleClass;

- (void)reset;

@end