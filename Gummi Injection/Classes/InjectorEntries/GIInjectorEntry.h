//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class GIInjector;

@interface GIInjectorEntry : NSObject {
    id _object;
    id _whenAskedFor;
    GIInjector *_injector;
}

@property(nonatomic, strong, readonly) id object;
@property(nonatomic, strong, readonly) id whenAskedFor;

- (id)initWithObject:(id)object mappedTo:(id)whenAskedFor injector:(GIInjector *)injector;
- (id)extractObject;

@end
