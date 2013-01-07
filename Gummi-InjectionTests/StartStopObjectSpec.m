//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "StartStopObject.h"


SPEC_BEGIN(StartStopObjectSpec)

        describe(@"StartStopObject", ^{

            __block StartStopObject *obj;
            beforeEach(^{
                obj = [[StartStopObject alloc] init];
            });

            it(@"instantiates StartStopObject", ^{
                [[obj should] beKindOfClass:[StartStopObject class]];
            });

            it(@"is not started", ^{
                [[theValue(obj.started) should] beNo];
            });

            it(@"is started", ^{
                [obj start];
                [[theValue(obj.started) should] beYes];
            });

            it(@"is not started", ^{
                [obj stop];
                [[theValue(obj.started) should] beNo];
            });

        });

        SPEC_END
