//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@class GIInjector;

@interface GIInjectorEntry : NSObject {
    id _object;
    id _keyObject;
    GIInjector *_injector;
}

@property(nonatomic, strong, readonly) id object;
@property(nonatomic, strong, readonly) id keyObject;

- (id)initWithObject:(id)object mappedTo:(id)keyObject injector:(GIInjector *)injector;

- (id)extractObjectWithArgs:(NSArray *)args;

@end
