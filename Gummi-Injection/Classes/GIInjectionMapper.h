//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@class GIInjectorEntry;

@protocol GIInjectionMapper <NSObject>

- (void)map:(id)object to:(id)keyObject;
- (void)mapSingleton:(id)object to:(id)keyObject;
- (void)mapEagerSingleton:(id)object to:(id)keyObject;

- (BOOL)isObject:(id)object mappedTo:(id)keyObject;
- (void)unMap:(id)object from:(id)keyObject;

- (GIInjectorEntry *)entryForKeyObject:(id)keyObject;

@end