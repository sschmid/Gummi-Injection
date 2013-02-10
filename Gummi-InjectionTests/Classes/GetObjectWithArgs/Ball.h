//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@interface Ball : NSObject
@property(nonatomic, copy) NSString *color;

- (id)initAlternative;
- (id)initWithColor:(NSString *)color;
@end