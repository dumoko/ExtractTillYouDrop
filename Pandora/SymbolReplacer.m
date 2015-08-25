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
@property (nonatomic, copy) NSRegularExpression *regex;

@end

@implementation SymbolReplacer

- (instancetype)initWithStringToReplace:(NSString *)stringToReplace {
    self = [super init];
    if (self) {
        _stringToReplace = stringToReplace;
        _alreadyReplaced = [NSMutableArray array];
        NSString *pattern = @"\\$([a-z]{2})";
        _regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    }

    return self;
}

- (NSString *)replace {
    for (NSString *match in [self findMatchingResults]) {
        if (![self.alreadyReplaced containsObject:match]) {
            [self.alreadyReplaced addObject:match];
            NSString *replaceTarget = [NSString stringWithFormat:@"$%@", match];
            self.stringToReplace = [self.stringToReplace stringByReplacingOccurrencesOfString:replaceTarget withString:[self translate:match]];
        }
    }

    return self.stringToReplace;
}


- (NSArray *)findMatchingResults {
    NSMutableArray *matches = [NSMutableArray array];
    for (NSTextCheckingResult *result in [self findTextCheckingResultsByRegex]) {
        [matches addObject:[self.stringToReplace substringWithRange:[self firstRangeFromTextCheckingResult:result]]];
    }

    return matches;
}


- (NSArray *)findTextCheckingResultsByRegex {
    NSRange fullStringRange = NSMakeRange(0, self.stringToReplace.length);

    return [self.regex matchesInString:self.stringToReplace options:0 range:fullStringRange];
}


- (NSRange)firstRangeFromTextCheckingResult:(NSTextCheckingResult *)result {

    return [result rangeAtIndex:1];
}


- (NSString *)translate:(NSString *)string {

    return [string uppercaseString];
}

@end
