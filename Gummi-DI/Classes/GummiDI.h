//
// Created by sschmid on 14.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>


#define inject(args...) + (NSSet *)desiredProperties {return [NSSet setWithObjects: args, nil];}

@interface GummiDI : NSObject

@end