//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class GIInjector;

@interface GIInjectorEntry : NSObject {
    id _whenAskedFor;
    id _use;
    GIInjector *_injector;
}

@property(nonatomic, strong, readonly) id whenAskedFor;
@property(nonatomic, strong, readonly) id use;

- (id)initWithObject:(id)whenAskedFor mappedTo:(id)use injector:(GIInjector *)injector;
- (id)extractObject;

@end
