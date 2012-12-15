//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "SDReflector.h"
#import "Car.h"
#import "Wheel.h"

SPEC_BEGIN(SDReflectorSpec)

        describe(@"SDReflector", ^{

            it(@"gets the class of a property", ^{
                id wheelClass = [SDReflector getTypeForProperty:@"frontLeftWheel" ofClass:[Car class]];

                [[wheelClass should] equal:[Wheel class]];
            });

            it(@"raises exeption for unknown property names", ^{
                [[theBlock(^{
                    [SDReflector getTypeForProperty:@"iDoNotExist" ofClass:[Car class]];
                }) should] raiseWithName:(NSString *) @"SDReflectorException"];
            });

        });

        SPEC_END