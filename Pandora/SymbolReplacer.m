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

#pragma mark - Public Methods

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
    [self replaceAllOccurrences];
    return self.stringToReplace;
}


#pragma mark - Private Methods

- (void)replaceAllOccurrences {
    for (NSString *match in [self findMatchingResults]) {
        [self replaceAllinstancesForMatch:match];
    }
}


- (void)replaceAllinstancesForMatch:(NSString *)match {
    if ([self shouldReplaceMatch:match]) {
        [self replaceMatch:match];
    }
}


- (NSArray *)findMatchingResults {
    NSMutableArray *matches = [NSMutableArray array];
    for (NSTextCheckingResult *result in [self findTextCheckingResultsByRegex]) {
        [matches addObject:[self.stringToReplace substringWithRange:[self firstRangeFromTextCheckingResult:result]]];
    }

    return matches;
}


- (BOOL)shouldReplaceMatch:(NSString *)match {

    return ![self.alreadyReplaced containsObject:match];
}


- (void)replaceMatch:(NSString *)match {
    [self.alreadyReplaced addObject:match];
    self.stringToReplace = [self.stringToReplace stringByReplacingOccurrencesOfString:[self replaceTargetForMatch:match] withString:[self translate:match]];
}


- (NSString *)replaceTargetForMatch:(NSString *)match {

    return [NSString stringWithFormat:@"$%@", match];
}

- (NSArray *)findTextCheckingResultsByRegex {

    return [self.regex matchesInString:self.stringToReplace options:0 range:[self calculateRangeOfStringToReplace]];
}


- (NSRange)firstRangeFromTextCheckingResult:(NSTextCheckingResult *)result {

    return [result rangeAtIndex:1];
}


- (NSRange)calculateRangeOfStringToReplace {

    return NSMakeRange(0, self.stringToReplace.length);
}


- (NSString *)translate:(NSString *)string {

    return [string uppercaseString];
}

@end
