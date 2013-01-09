//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class GIInjector;
@class GIInjectorEntry;

@interface GIInjectorEntryFactory : NSObject
- (id)initWithInjector:(GIInjector *)injector;
- (GIInjectorEntry *)createEntryForObject:(id)object mappedTo:(id)keyObject asSingleton:(BOOL)asSingleton;
@end