//
//  ViewController.m
//  CardGame
//
//  Created by Ovi Bortas on 1/15/14.
//  Copyright (c) 2014 Ovi Bortas. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController () <UIAlertViewDelegate>
@property (nonatomic,strong) Deck *theDeck;
@property (nonatomic,strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UITextView *lastMatchLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *nCardMatchSegment;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@end

@implementation ViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    for (UIButton *button in self.cardButtons) {
        button.layer.cornerRadius = 4.0f;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    [self updateHistorySlider];
    [self newGame];
    [self updateUI];
}

#pragma mark - UI Actions
- (IBAction)cardButtonTouched:(UIButton *)sender
{
    // Disable gametype segment
    self.nCardMatchSegment.enabled = NO;
    
    // find out which card was tapped
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void)updateHistorySlider
{
    int count = (int) [[self.game matchHistory]count] -1;
    
    self.historySlider.maximumValue = count;
    self.historySlider.value = self.historySlider.maximumValue;
    self.historySlider.enabled = (count >1) ? YES : NO;
}
- (IBAction)historySliderChanged:(UISlider *)sender
{
    int element = (int) round(self.historySlider.value);
    if (element < 0) element = 0;
    
    // Set label to display history
    NSArray *history = [self.game matchHistory][element];
    self.lastMatchLabel.text = [history componentsJoinedByString:@"\n"];
    
    // Change text color when looking at past actions
    if (element == self.historySlider.maximumValue) {
        self.lastMatchLabel.textColor  = [UIColor blackColor];
    } else {
        self.lastMatchLabel.textColor = [UIColor whiteColor];
    }
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        cardButton.backgroundColor = [self backgroundColorForCard:card];
        cardButton.enabled = !card.isMatched;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}
// Update the Card details when tapped
- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"Flip";
}

- (UIColor *)backgroundColorForCard:(Card *)card
{
    return card.isChosen ? [UIColor whiteColor] : [UIColor blueColor];
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc]init];
}

#pragma mark - Segment
- (IBAction)segmentChanged:(UISegmentedControl*)sender
{
    self.game.gameType = (sender.selectedSegmentIndex) ? 3 : 2;
    // If selectedSegmentIndex = 1 set title to "three"
    NSString *cardsToMatch = (sender.selectedSegmentIndex) ? @"three" : @"two";
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Gametype Changed"
                                                   message:[NSString stringWithFormat:@"You how need to match %@cards.", cardsToMatch]
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil, nil];
    [alert show];
    [self newGame];
}


#pragma mark - New Game
- (IBAction)newGameButton:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"New Game"
                                                   message:@"Score and cards will be reset. Are you sure you want to start a new game?"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"New Game", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"New Game"]) {
        [self newGame];
    }
}

- (void)newGame
{
    // Enable gamytype segment
    self.nCardMatchSegment.enabled = YES;
    
    self.game = nil; // Setting to nill will re-init it - causing random cards to be set
    self.game.gameType = self.nCardMatchSegment.selectedSegmentIndex;
    [self updateUI];
}

#pragma mark - Custome Setters/Getters

- (Deck *)theDeck
{
    if (!_theDeck) _theDeck = [self createDeck];
    
    return _theDeck;
}

- (CardMatchingGame *)game

{
    if (!_game) _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] fromDeck:[self createDeck]];
    return _game;
}

@end
