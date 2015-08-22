//
//  SymbolReplacer.h
//  Pandora
//
//  Created by Olegas on 22/08/2015.
//  Copyright (c) 2015 SkyOffice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SymbolReplacer : NSObject

- (instancetype)initWithStringToReplace:(NSString *)stringToReplace;
- (NSString *)replace;

@end
