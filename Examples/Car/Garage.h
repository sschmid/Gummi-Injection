//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class Car;

@interface Garage : NSObject
@property(nonatomic, strong) Car *audi;
@property(nonatomic, strong) Car *bmw;
@property(nonatomic, strong) Car *mercedes;

@property(nonatomic, readonly) BOOL isFull;

@end