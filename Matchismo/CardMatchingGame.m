//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Matthew Rawding on 4/14/13.
//  Copyright (c) 2013 Matthew Rawding. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString *status;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    
    self.status = @"New game started";
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (card && !card.isUnplayable) {
        
        // only look for a match when we are flipping the card to face up
        if (!card.isFaceUp) {
            
            // loop through all other cards looking for any others that are
            // face up and still playable
            BOOL otherCardsFlipped = NO;
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    otherCardsFlipped = YES;
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.status = [@[@"Matched", card.contents, @"&", otherCard.contents, @"for", [NSString stringWithFormat:@"%i", matchScore * MATCH_BONUS], @"points"] componentsJoinedByString:@" "];
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.status = [@[card.contents, @"and", otherCard.contents, @"don't match!", [NSString stringWithFormat:@"%i", MISMATCH_PENALTY], @"point penalty!"] componentsJoinedByString:@" "];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
            if (!otherCardsFlipped){
                self.status = [@"Flipped up " stringByAppendingString:card.contents];
            }
        } else {
            // we are turning the card face down
            self.status = [@"Flipped down " stringByAppendingString:card.contents];
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

@end
