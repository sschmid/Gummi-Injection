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

#define inject(args...) + (void)requiredProperties:(GIInjector *)injector \
{[injector addDependencies:[NSArray arrayWithObjects:args, nil] forClass:self];}

#define injection_defaultInitializer(selector) + (void)defaultInitializer:(GIInjector *)injector \
                                        {[injector setDefaultInitializer:selector forClass:self];}

#define injection_complete(selector) + (NSString *)injectionCompleteSelector \
                                      {return NSStringFromSelector(selector);}

#define getObject(keyObject) [[GIInjector sharedInjector] getObject:keyObject]
#define getObjectWithArgs(keyObject, args) [[GIInjector sharedInjector] getObject:keyObject withArgs:args]
#define GIFactoryBlock(name) id (^name)(GIInjector *, NSArray *)

@interface GIInjector : NSObject <GIInjectionMapper>

+ (GIInjector *)sharedInjector;

- (GIInjector *)createChildInjector;

- (void)addDependencies:(NSArray *)propertyNames forClass:(id)aClass;
- (void)setDefaultInitializer:(SEL)selector forClass:(Class)aClass;

- (id)getObject:(id)keyObject withArgs:(NSArray *)args;
- (id)getObject:(id)keyObject;

- (id)instantiateClass:(Class)aClass withArgs:(NSArray *)args;
- (void)injectIntoObject:(id)object;

- (void)addModule:(GIModule *)module;
- (void)removeModule:(GIModule *)module;
- (void)removeModuleClass:(Class)moduleClass;

- (BOOL)hasModule:(GIModule *)module;
- (BOOL)hasModuleClass:(Class)moduleClass;

- (void)reset;

@end