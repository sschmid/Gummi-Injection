//
// Created by sschmid on 15.12.12.
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