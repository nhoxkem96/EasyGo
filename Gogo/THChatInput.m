
#import "THChatInput.h"
#import "Utils.h"
@interface NSString (THChatInput)
@end

@implementation NSString (THChatInput)

- (CGSize) sizeForFont:(UIFont *)font
{
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary* attribs = @{NSFontAttributeName:font};
        return ([self sizeWithAttributes:attribs]);
    }
    return ([self sizeWithFont:font]);
}

- (CGSize) sizeForFont:(UIFont*)font
     constrainedToSize:(CGSize)constraint
         lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size;
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary *attributes = @{NSFontAttributeName:font};
        
        CGSize boundingBox = [self boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    else
    {
        size = [self sizeWithFont:font constrainedToSize:constraint lineBreakMode:lineBreakMode];
    }
    
    return size;
}

@end

@implementation THChatInput
@synthesize inputBackgroundView;
@synthesize textViewBackgroundView;
@synthesize textView;
@synthesize lblPlaceholder;
@synthesize avatar;
@synthesize emojiButton;
@synthesize sendButton;

@synthesize keyboardHeight;

static BOOL isIos7;

+ (BOOL)isIOS7
{
    return isIos7;
}

- (void) composeView
{
    isIos7 = [[[UIDevice currentDevice] systemVersion] floatValue]>=7;
    keyboardAnimationDuration = 0.25f;
    self.keyboardHeight = 216;
    topGap = isIos7 ? 8 : 12;
   
    inputHeight = 38.0f;
    inputHeightWithShadow = 44.0f;
    autoResizeOnKeyboardVisibilityChanged = NO;
    
    CGSize size = self.frame.size;
	self.inputBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	inputBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    inputBackgroundView.contentMode = UIViewContentModeScaleToFill;
    inputBackgroundView.backgroundColor = [UIColor clearColor];
	[self addSubview:inputBackgroundView];
   
    self.textViewBackgroundView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    textViewBackgroundView.borderStyle = UITextBorderStyleRoundedRect;
	textViewBackgroundView.autoresizingMask = UIViewAutoresizingNone;
    textViewBackgroundView.userInteractionEnabled = NO;
    textViewBackgroundView.enabled = NO;
	[self addSubview:textViewBackgroundView];
    
	self.textView = [[UITextView alloc] initWithFrame:CGRectMake(70.0f, topGap, 185, [UIScreen mainScreen].bounds.size.width * 27/320)];
    textView.backgroundColor = [UIColor clearColor];
	textView.delegate = self;
    textView.contentInset = UIEdgeInsetsMake(-4, -2, -4, 0);
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.returnKeyType = UIReturnKeySend;
    textView.tag = 991;
	textView.font = [UIFont systemFontOfSize:[Utils fontSizeNormal]];
	[self addSubview:textView];
   
   [self adjustTextInputHeightForText:@"" animated:NO];
   
    self.lblPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(78.0f, topGap+5, 160, [UIScreen mainScreen].bounds.size.width * 27/320)];
    lblPlaceholder.font = [UIFont systemFontOfSize:[Utils fontSizeNormal]];
    lblPlaceholder.text = @"Viết bình luận...";
    lblPlaceholder.textColor = [UIColor lightGrayColor];
    lblPlaceholder.backgroundColor = [UIColor clearColor];
	[self addSubview:lblPlaceholder];
//
	self.avatar = [[UIImageView alloc ]init];
    self.avatar.hidden = NO;
	self.avatar.frame = CGRectMake(6.0f, topGap + 2, [UIScreen mainScreen].bounds.size.width * 25/320, [UIScreen mainScreen].bounds.size.width * 25/320);
	self.avatar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height /2 ;
    self.avatar.layer.masksToBounds = YES;
    self.avatar.tag = 990;
    self.avatar.image = [UIImage imageNamed:@"1"];
	[self addSubview:self.avatar];
	
	self.emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
	emojiButton.frame = CGRectMake(12.0f + self.avatar.frame.size.width, topGap, 26.0f, 27.0f);
    emojiButton.hidden = YES;
	emojiButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [emojiButton addTarget:self action:@selector(showEmojiInput:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:emojiButton];

	self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sendButton.frame = CGRectMake(size.width - [UIScreen mainScreen].bounds.size.width * 40/320 - 10, 12.0f, [UIScreen mainScreen].bounds.size.width * 40/320, [UIScreen mainScreen].bounds.size.width * 27/320);
    sendButton.hidden = NO;
    [sendButton setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
	sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:sendButton];
   [self sendSubviewToBack:inputBackgroundView];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = 70 ;
    CGFloat w = self.frame.size.width - avatar.frame.size.width - emojiButton.frame.size.width - 10 - sendButton.frame.size.width - 15;
    CGFloat d = 0;
    if (avatar.hidden) { d = avatar.frame.size.width; }
    else d = 0;
    x = x - d; w = w + d;
    if (emojiButton.hidden) { d = emojiButton.frame.size.width; }
    else d = 0;
    x = x - d; w = w + d;
    
    if (avatar.hidden && emojiButton.hidden)
        x = 5;
    w = sendButton.frame.origin.x  - 6 - [UIScreen mainScreen].bounds.size.width * 25/320 - 6;
    textView.frame = CGRectMake(6 + [UIScreen mainScreen].bounds.size.width * 25/320 + 6, textView.frame.origin.y, w, textView.frame.size.height);
    CGRect f = textView.frame;
    f.size.height = f.size.height+(isIos7?3:0);
    textViewBackgroundView.frame = f;
    lblPlaceholder.frame = CGRectMake(6 + [UIScreen mainScreen].bounds.size.width * 25/320 + 6 +8, topGap+5, w, 20);
    avatar.frame = CGRectMake(avatar.frame.origin.x,topGap,avatar.frame.size.width,avatar.frame.size.height);
    sendButton.frame = CGRectMake(sendButton.frame.origin.x,topGap,sendButton.frame.size.width,sendButton.frame.size.height);
}


- (void) awakeFromNib
{
    [self composeView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil)
    {
        [self listenForKeyboardNotifications:NO];
    }
    else
    {
        [self listenForKeyboardNotifications:YES];
    }
}

- (void) adjustTextInputHeightForText:(NSString*)text animated:(BOOL)animated
{
    int h1 = [text sizeForFont:textView.font].height;
    int h2 = [text sizeForFont:textView.font constrainedToSize:CGSizeMake(textView.frame.size.width - 16, 170.0f) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    [UIView animateWithDuration:(animated ? .1f : 0) animations:^
     {
         int h = h2 == h1 ? inputHeightWithShadow : h2 + 24;
         int delta = h - self.frame.size.height;
         CGRect r2 = CGRectMake(0, self.frame.origin.y - delta, self.frame.size.width, h);
         self.frame = r2;
         inputBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width, h);
         
         CGRect r = textView.frame;
         r.origin.y = topGap;
         r.size.height = h - 18;
         textView.frame = r;
         
     } completion:^(BOOL finished){ }];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self composeView];
    }
    return self;
}

- (void) fitText
{
    [self adjustTextInputHeightForText:textView.text animated:YES];
}

- (BOOL)resignFirstResponder
{
    if (super.isFirstResponder)
        return [super resignFirstResponder];
    else if ([textView isFirstResponder])
        return [textView resignFirstResponder];
    return NO;
}
#pragma mark - Public Methods

- (NSString*)text
{
    return textView.text;
}

- (void) setText:(NSString*)text
{
    textView.text = text;
    lblPlaceholder.hidden = text.length > 0;
    [self fitText];
}

- (void) setPlaceholder:(NSString*)text
{
    lblPlaceholder.text = text;
}
#pragma mark - Display

- (void)beganEditing
{
    if (autoResizeOnKeyboardVisibilityChanged)
    {
        UIViewAnimationOptions opt = animationOptionsWithCurve(keyboardAnimationCurve);

        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:opt animations:^
         {
             UITabBarController *tabBarController = [UITabBarController new];
             CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
             self.transform = CGAffineTransformMakeTranslation(0, -self.keyboardHeight + tabBarHeight);
        } completion:^(BOOL fin){}];
        [self fitText];
    }
}

- (void)endedEditing
{
    if (autoResizeOnKeyboardVisibilityChanged)
    {
        UIViewAnimationOptions opt = animationOptionsWithCurve(keyboardAnimationCurve);
        
        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:opt animations:^
         {
             self.transform = CGAffineTransformIdentity;
         } completion:^(BOOL fin){}];
        
        [self fitText];
    }
    
    lblPlaceholder.hidden = textView.text.length > 0;
}

#pragma mark - Keyboard Notifications

- (void)listenForKeyboardNotifications:(BOOL)listen
{
    if (listen)
    {
        [self listenForKeyboardNotifications:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    }
}

- (void)updateKeyboardProperties:(NSNotification*)n
{
    NSNumber *d = [[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    if (d!=nil && [d isKindOfClass:[NSNumber class]])
        keyboardAnimationDuration = [d floatValue];
    d = [[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    if (d!=nil && [d isKindOfClass:[NSNumber class]])
        keyboardAnimationCurve = [d integerValue];
    NSValue *v = [[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    if ([v isKindOfClass:[NSValue class]])
    {
        CGRect r = [v CGRectValue];
        r = [self.window convertRect:r toView:self];
        self.keyboardHeight = r.size.height;
    }
    if ([_delegate respondsToSelector:@selector(chatUpdatedKeyboardProperties:)])
        [_delegate performSelector:@selector(chatUpdatedKeyboardProperties:) withObject:self];
}

- (void)keyboardWillShow:(NSNotification*)n
{
    //NSLog(@"keyboardWillShow %@",[n description]);
    autoResizeOnKeyboardVisibilityChanged = YES;
    [self updateKeyboardProperties:n];
    if ([_delegate respondsToSelector:@selector(chatKeyboardWillShow:)])
        [_delegate performSelector:@selector(chatKeyboardWillShow:) withObject:self];
}

- (void)keyboardWillHide:(NSNotification*)n
{
    //NSLog(@"keyboardWillHide %@",[n description]);
    [self updateKeyboardProperties:n];
    if ([_delegate respondsToSelector:@selector(chatKeyboardWillHide:)])
        [_delegate performSelector:@selector(chatKeyboardWillHide:) withObject:self];
}

- (void)keyboardDidHide:(NSNotification*)n
{
    //NSLog(@"keyboardDidHide %@",[n description]);
    if ([_delegate respondsToSelector:@selector(chatKeyboardDidHide:)])
        [_delegate performSelector:@selector(chatKeyboardDidHide:) withObject:self];
}

- (void)keyboardDidShow:(NSNotification*)n
{
    //NSLog(@"keyboardDidShow %@",[n description]);
    if ([textView isFirstResponder])
    {
        [self beganEditing];
    }
    if ([_delegate respondsToSelector:@selector(chatKeyboardDidShow:)])
        [_delegate performSelector:@selector(chatKeyboardDidShow:) withObject:self];
}

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve)
{
    UIViewAnimationOptions opt = (UIViewAnimationOptions)curve;
    return opt << 16;
}

#pragma mark - UITextFieldDelegate Delegate

- (void) textViewDidBeginEditing:(UITextView*)textview
{
    [self beganEditing];
    
    if ([_delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
        [_delegate performSelector:@selector(textViewDidBeginEditing:) withObject:textview];
}

- (void) textViewDidEndEditing:(UITextView*)textview
{
    [self endedEditing];
    
    autoResizeOnKeyboardVisibilityChanged = NO;
    
    if ([_delegate respondsToSelector:@selector(textViewDidEndEditing:)])
        [_delegate performSelector:@selector(textViewDidEndEditing:) withObject:textview];
}

- (BOOL) textView:(UITextView*)textview shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self performSelector:@selector(returnButtonPressed:) withObject:nil afterDelay:.1];
        return NO;
    }
    else if (text.length > 0)
    {
        [self adjustTextInputHeightForText:[NSString stringWithFormat:@"%@%@", textview.text, text] animated:YES];
    }
    return YES;
}

- (void) textViewDidChange:(UITextView*)textview
{
    lblPlaceholder.hidden = textview.text.length > 0;
    
    [self fitText];
    
    if ([_delegate respondsToSelector:@selector(textViewDidChange:)])
        [_delegate performSelector:@selector(textViewDidChange:) withObject:textview];
}

#pragma mark THChatInput Delegate

- (void) sendButtonPressed:(id)sender
{
    [_delegate chat:self sendWasPressed:self.text];
}

- (void) showAttachInput:(id)sender
{
    if ([_delegate respondsToSelector:@selector(chatShowAttachInput:)])
        [_delegate performSelector:@selector(chatShowAttachInput:) withObject:self];
}

- (void) showEmojiInput:(id)sender
{
    if ([_delegate respondsToSelector:@selector(chatShowEmojiInput:)])
    {
        if ([textView isFirstResponder] == NO) [textView becomeFirstResponder];
        
        [_delegate performSelector:@selector(chatShowEmojiInput:) withObject:self];
    }
}

- (void)returnButtonPressed:(id)sender
{
    [self sendButtonPressed:sender];
}
@end
