//
//  EditCardViewController.m
//  GuidePost
//
//  Created by Vitaly Chupryk on 22.10.14.
//  Copyright (c) 2014 SoftMax SG. All rights reserved.
//

#import <libextobjc/EXTScope.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EditCardViewController.h"
#import "UIView+ActivityIndicator.h"
#import "NSObject+BKBlockExecution.h"
#import "NSString+Validators.h"
#import "UIView+SubviewsTraverser.h"
#import "Card.h"
#import "CardService.h"
#import "UIView+CaptureImage.h"
#import "UIAlertView+BlocksKit.h"
#import "UIImagePickerController+BlocksKit.h"

@interface EditCardViewController ()

@property (nonatomic) IBOutlet UIView *cardContentView;

@property (nonatomic) IBOutlet UITextView *cardUrlTextView;
@property (nonatomic) IBOutlet UITextView *cardTitleTextView;
@property (nonatomic) IBOutlet UITextView *cardDescriptionTextView;

@property (nonatomic) IBOutlet UIImageView *cardImageView;

@property (nonatomic) IBOutlet UIButton *retrieveInfoButton;
@property (nonatomic) IBOutlet UIButton *commitCardButton;

@property (nonatomic) Card *cardModel;

- (void)updateRetrieveButtonEnabledState;
- (void)updateCommitButtonEnabledState;

- (UIImageView *)createViewImageClone:(UIView *)sourceView;

- (void)updateCardContent;
- (void)showCardContent;
- (void)hideCardContent;

- (void)cardUrlTextDidChange:(NSNotification *)notification;
- (void)cardContentTextDidChange:(NSNotification *)notification;

- (IBAction)retrieveInfoButtonTapped;
- (IBAction)commitCardButtonTapped;
- (IBAction)addCardImageButtonTapped;

@end

@implementation EditCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.cardModel = [[Card alloc] init];

    self.retrieveInfoButton.layer.cornerRadius = CGRectGetHeight(self.retrieveInfoButton.bounds) / 2.0f;
    self.commitCardButton.layer.cornerRadius = CGRectGetHeight(self.commitCardButton.bounds) / 2.0f;

    self.cardUrlTextView.delegate = self;
    self.cardTitleTextView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cardUrlTextDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.cardUrlTextView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cardContentTextDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.cardTitleTextView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cardContentTextDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.cardDescriptionTextView];

    [self updateRetrieveButtonEnabledState];

    self.cardContentView.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.cardUrlTextView || textView == self.cardTitleTextView)
    {
        return [text rangeOfString:@"\n"].length == 0;
    }

    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateCardContent
{
    self.cardTitleTextView.text = self.cardModel.title;
    self.cardDescriptionTextView.text = self.cardModel.desc;
    self.cardImageView.image = self.cardModel.image;

    [self updateCommitButtonEnabledState];
}

- (void)updateRetrieveButtonEnabledState
{
    self.retrieveInfoButton.enabled = self.cardModel.isValidUrl;
}

- (void)updateCommitButtonEnabledState
{
    self.commitCardButton.enabled = self.cardModel.isValid;
}

- (UIImageView *)createViewImageClone:(UIView *)sourceView
{
    UIImageView *cloneImageView = [[UIImageView alloc] initWithImage:sourceView.captureImage];
    cloneImageView.frame = sourceView.frame;
    [sourceView.superview addSubview:cloneImageView];

    return cloneImageView;
}

- (void)showCardContent
{
    UIImageView *retrieveInfoButtonImageView = [self createViewImageClone:self.retrieveInfoButton];

    self.retrieveInfoButton.hidden = YES;
    [self.retrieveInfoButton hideActivityIndicator];

    self.cardContentView.alpha = 0;
    self.cardContentView.hidden = NO;

    CGRect destinationInfoButtonFrame = CGRectOffset(retrieveInfoButtonImageView.frame, 0, CGRectGetHeight(retrieveInfoButtonImageView.superview.bounds));

    [UIView animateWithDuration:0.3 animations:^
    {
        self.cardContentView.alpha = 1;
        retrieveInfoButtonImageView.frame = destinationInfoButtonFrame;
    } completion:^(BOOL finished)
    {
        [retrieveInfoButtonImageView removeFromSuperview];
    }];
}

- (void)hideCardContent
{
    [self updateRetrieveButtonEnabledState];

    UIImageView *retrieveInfoButtonImageView = [self createViewImageClone:self.retrieveInfoButton];

    CGRect destinationInfoButtonFrame = retrieveInfoButtonImageView.frame;
    retrieveInfoButtonImageView.frame = CGRectOffset(retrieveInfoButtonImageView.frame, 0, CGRectGetHeight(retrieveInfoButtonImageView.superview.bounds));

    [UIView animateWithDuration:0.3 animations:^
    {
        self.cardContentView.alpha = 0;
        retrieveInfoButtonImageView.frame = destinationInfoButtonFrame;
    } completion:^(BOOL finished)
    {
        self.cardContentView.hidden = YES;
        self.retrieveInfoButton.hidden = NO;

        [retrieveInfoButtonImageView removeFromSuperview];
    }];
}

- (void)cardUrlTextDidChange:(NSNotification *)notification
{
    self.cardModel.urlString = self.cardUrlTextView.text;

    [self updateRetrieveButtonEnabledState];

    if (!self.cardContentView.hidden)
    {
        [self hideCardContent];
    }
}

- (void)cardContentTextDidChange:(NSNotification *)notification
{
    self.cardModel.title = self.cardTitleTextView.text;
    self.cardModel.desc = self.cardDescriptionTextView.text;

    [self updateCommitButtonEnabledState];
}

- (IBAction)retrieveInfoButtonTapped
{
    [self.view.firstResponderSubView resignFirstResponder];

    self.cardUrlTextView.editable = NO;

    self.retrieveInfoButton.enabled = NO;
    [self.retrieveInfoButton showActivityIndicator];

    @weakify(self);
    [CardService retrieveCardDetails:self.cardModel successBlock:^(Card *card)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            @strongify(self);

            self.cardUrlTextView.editable = YES;

            [self updateCardContent];
            [self showCardContent];
        }];
    } failureBlock:^(NSError *error)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            [self.retrieveInfoButton hideActivityIndicator];
            [self updateRetrieveButtonEnabledState];

            self.cardUrlTextView.editable = YES;

            [UIAlertView bk_showAlertViewWithTitle:@"Error"
                                           message:@"Cannot retrieve metadata for provided link."
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil
                                           handler:nil];
        }];
    }];
}

- (IBAction)commitCardButtonTapped
{
    [self performSegueWithIdentifier:@"unwindSegue" sender:self];
}

- (IBAction)addCardImageButtonTapped
{
    @weakify(self);

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
    imagePickerController.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *pickerController, NSDictionary *info)
    {
        if ([info[UIImagePickerControllerMediaType] isEqual:(__bridge NSString *)kUTTypeImage])
        {
            @strongify(self);

            self.cardModel.image = info[UIImagePickerControllerOriginalImage];
            [self updateCardContent];
        }

        [pickerController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    };

    [self presentViewController:imagePickerController animated:YES completion:nil];
}

@end
