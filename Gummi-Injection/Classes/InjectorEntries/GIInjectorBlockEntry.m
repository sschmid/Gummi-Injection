//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GIInjectorBlockEntry.h"
#import "GIInjector.h"

@implementation GIInjectorBlockEntry

- (id)extractObjectWithArgs:(NSArray *)args {
    GIFactoryBlock(factoryBlock) = _object;
    return factoryBlock(_injector, args);
}

@end