//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GIInjectorEntry.h"

@interface GIInjectorClassEntry : GIInjectorEntry {
    id _singletonCache;
}

@property(nonatomic) BOOL asSingleton;
@end