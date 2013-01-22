//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GIInjectorBlockEntry.h"
#import "GIInjector.h"

@implementation GIInjectorBlockEntry

- (id)extractObject {
    id (^factoryBlock)(GIInjector *) = _object;
    return factoryBlock(_injector);
}

@end