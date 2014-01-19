//
//  CardMatchingGame.m
//  CardGame
//
//  Created by Ovi Bortas on 1/16/14.
//  Copyright (c) 2014 Ovi Bortas. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardMatchingGame ()
@property (nonatomic,readwrite) NSInteger score; // Makes score writeable in private API
@property (nonatomic,strong) NSMutableArray *cards; // Card objects
@property (nonatomic,strong) NSMutableArray *history;
@end

static const int MISMATCH = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

@implementation CardMatchingGame

- (void)chooseCardAtIndex:(NSUInteger)index {
    
    Card *card = [self.cards objectAtIndex:index]; // Get reference to current selected card
    
    // Toggle for selected and un-selected
    if (card.isChosen) {
        card.chosen = NO;
    
    // If card is NOT chosen but was tapped on
    } else {
        //Match against other chosen cards
        // Go thorught the deck and find all the cards that have been marked as chosen
        for (Card *otherCard in self.cards) {
            // Find the cards that are chosen but not macthed
            if (otherCard.isChosen && !otherCard.isMatched) {
                int matchScore = [card match:@[otherCard]];
                // If there is a score that means its a match
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    card.matched = YES;
                    otherCard.matched = YES;
                    NSLog(@"Match! %@ x %@", card.contents, otherCard.contents);
                    
                // If not match do this
                } else {
                    otherCard.chosen = NO;
                    self.score -= MISMATCH;
                    NSLog(@"No match... %@ x %@", card.contents, otherCard.contents);
                }
                break; //Can only choose 2 cards for now
            }
        }
        card.chosen = YES;
        self.score -= COST_TO_CHOOSE; // points deducted when player selec
    }
}


/************************************************************************************************************************/
/******************************** Old method used to match cards is buggy.. Need to fix *********************************/
/************************************************************************************************************************/
//- (void)chooseCardAtIndex:(NSUInteger)index
//{
//    
//    PlayingCard *card = (PlayingCard *)[self cardAtIndex:index]; // Reference to the current slected card
//    
//    if (!card.isMatched) { // If card is NOT macthed
//        // This is like a togle, card is not matched but it is selected, if selected unselect it
//        if (card.isChosen) {
//            card.chosen = NO;
//            
//            // Store the history of the even
//            NSString *feedback = [NSString stringWithFormat:@"Un-selected %@", card.contents];
//            [self.history addObject:@[feedback]];
//        
//        // If card is NOT matched or chosen
//        } else {
//            
//            // Create array to hold the chosen cards
//            NSMutableArray *matchedCards = [[NSMutableArray alloc]init];
//            
//            // Look throught the cards on screen and find out which cards are chosen but not matched
//            // And add them tho the "matchedCards" array
//            for (Card *otherCard in self.cards) {
//                if (otherCard.isChosen && !otherCard.isMatched) {
//                    // Add matched card to array
//                    [matchedCards addObject:otherCard];
//                }
//            }
//            
//            // check if number of cards flipped is enough for this gametype
//            
//            /******************************************/
//            /****/ /**** ERROR MIGHT BE HERE ***/ /****/
//            /******************************************/
//            
//            // Check to see if the "matchedCard" array has enough items for the gametype
//            if ([matchedCards count] == (self.gameType -1)) {
//                // Calculate score for match
//                // Takes the current selected card and matches it againt the other chosen cards
//                int matchScore = [card match:matchedCards];
//                
//                // If #of cards is enough for gametype and they match
//                if (matchScore) {
//                    self.score += matchScore * MATCH_BONUS;
//                    
//                    // Set card and other matched cards as "matched"
//                    card.matched = YES;
//                    for (Card *otherCard in matchedCards) {
//                        otherCard.matched = YES;
//                    }
//                    [self.history addObject:[card matchHistory]];
//                
//                // If #of cards is enough for gametype but they dont match give penalty and un-choose cards
//                } else {
//                    // Calculate mismatch penalty when card does not match
//                    int penalty = (MISMATCH * (int)(self.gameType));
//                    self.score -= penalty;
//                    
//                    for (Card *otherCard in matchedCards) {
//                        otherCard.chosen = NO;
//                    }
//                    
//                    NSString *matchHistory = card.matchHistory.lastObject;
//                    NSString *feedback = [matchHistory stringByAppendingFormat:@" %d point penalty", penalty];
//                    [self.history addObject:@[feedback]];
//                    
//                    }
//                
//                // If #of cars is not enough for gametype
//                } else {
//                    NSString *feedback = [NSString stringWithFormat:@"Picked %@", card.contents];
//                    [self.history addObject:@[feedback]];
//                }
//            
//            self.score -= COST_TO_CHOOSE;
//            card.chosen = YES;
//        }
//    }
//}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#pragma mark Initializers
- (instancetype)initWithCardCount:(NSUInteger)count fromDeck:(Deck *)deck
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
    
    return self;
}

- (instancetype)init
{
    return nil;
}

#pragma mark - Custome Setters/Getters
- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

- (NSMutableArray *)history
{
    if (!_history) {
        _history = [[NSMutableArray alloc]init];
    }
    
    return _history;
}

- (NSArray *)matchHistory
{
    return self.history;
}

- (NSUInteger)gameType
{
    if (!_gameType) {
        _gameType = 2;
    }
    return _gameType;
}


@end
