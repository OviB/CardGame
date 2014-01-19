//
//  Deck.m
//  CardGame
//
//  Created by Ovi Bortas on 1/16/14.
//  Copyright (c) 2014 Ovi Bortas. All rights reserved.
//

#import "Deck.h"

@interface Deck ()
@property (nonatomic,strong) NSMutableArray *cards; // array of cards
@end

@implementation Deck


#pragma mark - Card Methods
- (void)addcard:(Card *)card
{
    [self addCard:card atTop:NO];
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

- (Card *)drawRandomCard
{
    Card *randomCard = nil; // Make sure card is nil
    
    if ([self.cards count]) {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}


#pragma mark - Custome Setters/Getters
// Makes sure the array is inited before its used
- (NSMutableArray*)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

@end
