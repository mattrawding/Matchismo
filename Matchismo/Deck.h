//
//  Deck.h
//  Matchismo
//
//  Created by Matthew Rawding on 4/11/13.
//  Copyright (c) 2013 Matthew Rawding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end
