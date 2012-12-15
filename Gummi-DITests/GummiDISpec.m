//
// Created by sschmid on 14.12.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "Car.h"

SPEC_BEGIN(GummiDISpec)

        describe(@"GummiDI", ^{

            context(@"GummiDI", ^{

                __block NSSet *desiredProps;
                beforeEach(^{
                    desiredProps = [[Car class] performSelector:@selector(desiredProperties)];
                });

                it(@"responds to selector", ^{
                    BOOL b = [[Car class] respondsToSelector:@selector(desiredProperties)];

                    [[theValue(b) should] beYes];
                });

                it(@"gets desired properties", ^{
                    NSSet *checkSet = [NSSet setWithObjects:@"frontLeftWheel", @"frontRightWheel", @"backLeftWheel", @"backRightWheel", nil];

                    [[theValue([desiredProps isEqualToSet:checkSet]) should] beYes];
                });
            });

        });

        SPEC_END