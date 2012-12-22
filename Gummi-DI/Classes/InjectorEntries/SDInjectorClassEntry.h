//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDInjectorEntry.h"


@interface SDInjectorClassEntry : SDInjectorEntry {
    id _singletonCache;
}

@property(nonatomic) BOOL asSingleton;
@end