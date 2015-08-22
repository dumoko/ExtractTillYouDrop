//
//  SymbolReplacer.m
//  Pandora
//
//  Created by Olegas on 22/08/2015.
//  Copyright (c) 2015 SkyOffice. All rights reserved.
//

#import "SymbolReplacer.h"

@interface SymbolReplacer ()

@property (nonatomic, copy) NSString *stringToReplace;
@property (nonatomic, copy) NSMutableArray *alreadyReplaced;

@end

@implementation SymbolReplacer

- (instancetype)initWithStringToReplace:(NSString *)stringToReplace {
    self = [super init];
    if (self) {
        _stringToReplace = stringToReplace;
        _alreadyReplaced = [NSMutableArray array];
    }

    return self;
}

- (NSString *)replace {
    NSString *pattern = @"\\$([a-z]{2})";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSRange fullStringRange = NSMakeRange(0, self.stringToReplace.length);
    NSArray *results = [regex matchesInString:self.stringToReplace options:0 range:fullStringRange];
    NSMutableArray *matches = [NSMutableArray arrayWithCapacity:results.count];
    for (NSTextCheckingResult *result in results) {
        NSRange matchRange = [result rangeAtIndex:1];
        [matches addObject:[self.stringToReplace substringWithRange:matchRange]];
    }

    for (NSString *match in matches) {
        if (![self.alreadyReplaced containsObject:match]) {
            [self.alreadyReplaced addObject:match];
            NSString *replaceTarget = [NSString stringWithFormat:@"$%@", match];
            NSRange firstOccurence = [self.stringToReplace rangeOfString:replaceTarget];
            self.stringToReplace = [self.stringToReplace stringByReplacingOccurrencesOfString:replaceTarget
                                                                                   withString:[self translate:match]
                                                                                      options:0
                                                                                        range:firstOccurence];
        }
    }


    return self.stringToReplace;
}


- (NSString *)translate:(NSString *)string {
    return [string uppercaseString];
}

@end
