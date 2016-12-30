//
//  EditPostViewController.m
//  Gogo
//
//  Created by Thuong on 11/11/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "EditPostViewController.h"
#import "TopView.h"
#import "BotView.h"
#import "DetailView.h"
#import "TextViewContent.h"
#import "CollectionView.h"
#import "MyURL.h"
#import "Image_Groups_Post.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "JSONModelLib.h"
#import "JSONModel.h"
#import "PostModel.h"
#import "LoginViewController.h"
#import "CustomIOSAlertView.h"
#import "AlertView.h"
#import "LocationPost.h"
#import "HomeViewController.h"
@interface EditPostViewController ()<CollectionViewDelegate , BotViewDelegate , CustomIOSAlertViewDelegate , UITextFieldDelegate , AlearViewDelegate>{
    NSInteger clickAt;
    CustomIOSAlertView *alertView;
    BOOL check;
    
}
@property UIImagePickerController *imagePickerController;
@property NSString *stringTitle;
@property CGPoint offset;


@end

@implementation EditPostViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    clickAt = 0;
    check = NO;
    self.arrayContentGroup =  [[NSMutableArray alloc] init];
    [self.arrayContentGroup addObject:@""];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapRecognizer];
    [alertView addGestureRecognizer:self.tapRecognizer];
    alertView.closeOnTouchUpOutside = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [[self tableView] setBounces:NO];
    [self setDefinesPresentationContext:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.arrayImage = [[NSMutableArray alloc]init];
    self.arrayInfoImage = [NSMutableArray new];
    self.arrayURL = [[NSMutableArray alloc]init];
    self.arrayCheckUpload = [[NSMutableArray alloc]init];
    self.arrayCheckUploadComplete = [[NSMutableArray alloc]init];
    UIView *firstViewUIView = [[[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil] firstObject];
    [self.postView addSubview:firstViewUIView];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66/255.0f green:100/255.0f blue:50/255.0f alpha:1]];
    [self postDetail];
}
-(void)postDetail{
    NSMutableArray *arrayTitle = [[NSMutableArray alloc]init];
    NSMutableArray *arrayImage = [[NSMutableArray alloc]init];
    NSMutableArray *arrayCheckUpload = [[NSMutableArray alloc]init];
    NSMutableArray *arrayCheckUploadComplete = [[NSMutableArray alloc]init];
    NSMutableArray *arrayUrl = [[NSMutableArray alloc]init];
    NSLog(@"%lu" , (unsigned long)self.detailPost.image_groups.count);
    for(int i = 0 ; i < self.detailPost.image_groups.count;i++){
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                      fromJSONDictionary:self.detailPost.image_groups[i]
                                                   error:nil];
        group.title = [group.title stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        NSLog(@"%@", group.title);
        [arrayTitle addObject:group.title];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSMutableArray *arrayUrlTmp = [[NSMutableArray alloc]init];
        NSMutableArray *arrayCheckUploadTmp = [[NSMutableArray alloc]init];
        NSMutableArray *arrayCheckUploadCompleteTmp = [[NSMutableArray alloc]init];
        for(NSString *urlImage in group.photos){
            [array addObject:urlImage];
            [arrayUrlTmp addObject:urlImage];
            [arrayCheckUploadTmp addObject:@"YES"];
            [arrayCheckUploadCompleteTmp addObject:@"YES"];
        }
        [arrayUrl addObject:arrayUrlTmp];
        [arrayCheckUploadComplete addObject:arrayCheckUploadCompleteTmp];
        [arrayCheckUpload addObject:arrayCheckUploadTmp];
        [arrayImage addObject:array];
        
    }
    self.arrayImage = arrayImage;
    self.arrayCheckUpload = arrayCheckUpload;
    self.arrayCheckUploadComplete = arrayCheckUploadComplete;
    self.arrayURL = arrayUrl;
    self.arrayInfoImage = arrayCheckUploadComplete;
    self.arrayContentGroup = arrayTitle;
    self.numberGroup = arrayImage.count * 2 + 3;
    [self.arrayContentGroup addObject:@""];
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
    [alertView close];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _numberGroup;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        TopView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopView class])];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TopView class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.txtTitle.text = self.detailPost.title;
        cell.txtTitle.delegate = self;
        return cell;
    }else  if (indexPath.row == _numberGroup - 1  ) {
        BotView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BotView class])];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BotView class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.delegate = self;
        return cell;
    }else if((indexPath.row % 2 == 0) && (indexPath.row != _numberGroup-2) && (indexPath.row != 0)){
        CollectionView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollectionView class])];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CollectionView class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        long index = (indexPath.row - 2)/2;
        cell.delegate = self;
        cell.arrayImage = self.arrayImage[index];
        cell.arrayCheckUpload = self.arrayCheckUpload[index];
        cell.arrayCheckUploadComplete = self.arrayCheckUploadComplete[index];
        //        [cell startUpload];
        cell.arrayURL = self.arrayURL[index];
        cell.cellIndex = indexPath.row;
        return cell;
    }
    
    else if((indexPath.row % 2 == 1) && (indexPath.row != _numberGroup-1)){
        TextViewContent *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextViewContent class])];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TextViewContent class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.txtContent.delegate = self;
        long index = (indexPath.row - 1)/2;
        cell.txtContent.text = self.arrayContentGroup[index];
        cell.txtContent.contentInset = UIEdgeInsetsMake(8 , 0 , 0 , 0);
        //        if(indexPath.row == _numberGroup - 2 && indexPath.row != 1 && [self.arrayContentGroup[index]  isEqual: @""]){
        //            [cell.txtContent becomeFirstResponder];
        //        }
        if ([cell.txtContent.text isEqualToString:@"" ]&& indexPath.row == 1) {
            cell.txtContent.text = @"Nhập nội dung...";
            cell.txtContent.textColor = [UIColor lightGrayColor];
        }
        //        if(check == YES && indexPath.row == _numberGroup - 2){
        //            [cell.txtContent becomeFirstResponder];
        ////            check = NO;
        //        }
        //        [cell.txtContent becomeFirstResponder];
        return cell;
    }
    else {
        return [UITableViewCell new];
    }
    
}

#pragma mark - TableView Delegate

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        return [UIScreen mainScreen].bounds.size.width / 4;
    }else if (indexPath.row == _numberGroup - 1) {
        return [UIScreen mainScreen].bounds.size.width *5/16;
    }else if((indexPath.row % 2 == 0) && (indexPath.row != _numberGroup-2) && (indexPath.row != 0)){
        return [UIScreen mainScreen].bounds.size.width / 3;
    }
    else{
        long index = (indexPath.row - 1)/2;
        
        UIFont *font = [UIFont systemFontOfSize:[Utils fontSizeBig]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.arrayContentGroup[index] attributes:attrsDictionary];
        if(_numberGroup > 3){
            return [self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30] + 20;
        }
        else if([self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30] > [UIScreen mainScreen].bounds.size.height * 250/568){
            return [self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30] + 20;
        }
        else return [UIScreen mainScreen].bounds.size.height * 250/568;
    }
}

#pragma mark - textview delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil] lastObject];
    textView.inputAccessoryView = containerView;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    UITableViewCell *textFieldRowCell;
    textFieldRowCell = (UITableViewCell *) textView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldRowCell];
    long index = (indexPath.row - 1)/2;
    NSString *string = textView.text;
    NSString *tmp = self.arrayContentGroup[index];
    UIFont *font = [UIFont systemFontOfSize:[Utils fontSizeBig]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:tmp attributes:attrsDictionary];
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:string attributes:attrsDictionary];
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"a" attributes:attrsDictionary];
    
    if([self textViewHeightForAttributedText:attrString1  andWidth:CGRectGetWidth(self.tableView.bounds)-30]> [self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30] && [self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30]> [self textViewHeightForAttributedText:attrString2  andWidth:CGRectGetWidth(self.tableView.bounds)-30]){
        [UIView setAnimationsEnabled:NO];
        self.offset = self.tableView.contentOffset;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self.tableView.layer removeAllAnimations];
        self.tableView.contentOffset = self.offset;
        [UIView setAnimationsEnabled:YES];
    }
    self.arrayContentGroup[index] = string;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:[UIPasteboard generalPasteboard].string]) {
        UITableViewCell *textFieldRowCell;
        textFieldRowCell = (UITableViewCell *) textView.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldRowCell];
        long index = (indexPath.row - 1)/2;
        NSString *tmp = self.arrayContentGroup[index];
        NSString *text1 = [NSString stringWithFormat:@"%@ %@" , tmp , text];
        NSLog(@"%@" , text1);
        UIFont *font = [UIFont systemFontOfSize:[Utils fontSizeBig]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:text1 attributes:attrsDictionary];
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:tmp attributes:attrsDictionary];
        NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"a" attributes:attrsDictionary];
        self.arrayContentGroup[index] = text1;
        if([self textViewHeightForAttributedText:attrString1  andWidth:CGRectGetWidth(self.tableView.bounds)-30]> [self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30] && [self textViewHeightForAttributedText:attrString1  andWidth:CGRectGetWidth(self.tableView.bounds)-30]> [self textViewHeightForAttributedText:attrString2  andWidth:CGRectGetWidth(self.tableView.bounds)-30]){
            [UIView setAnimationsEnabled:NO];
            self.offset = self.tableView.contentOffset;
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            [self.tableView.layer removeAllAnimations];
            self.tableView.contentOffset = self.offset;
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            [UIView setAnimationsEnabled:YES];
        }
    }
    return YES;
}
- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}
- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    UITableViewCell *textFieldRowCell;
    textFieldRowCell = (UITableViewCell *) textView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldRowCell];
    if ([textView.text isEqualToString:@"Nhập nội dung..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    textView.textColor = [UIColor blackColor];
    self.activeTextView = textView;
    self.offset = self.tableView.contentOffset;
    if(indexPath.row != 1){
        [UIView setAnimationsEnabled:NO];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    //    [self.tableView.layer removeAllAnimations];
    //    [self.tableView setContentOffset:CGPointMake(self.offset.x,self.offset.y) animated:NO];
    //    [self scrollToCursorForTextView:textView];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    UITableViewCell *textFieldRowCell;
    textFieldRowCell = (UITableViewCell *) textView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldRowCell];
    [UIView setAnimationsEnabled:NO];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    self.offset = self.tableView.contentOffset;
    [UIView setAnimationsEnabled:YES];
    //    if ([textView.text isEqualToString:@""]) {
    //        textView.text = @"Nhập nội dung...";
    //        textView.textColor = [UIColor lightGrayColor];
    //    }
    [textView resignFirstResponder];
    self.activeTextView = nil;
}
#pragma mark - textfield
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil] lastObject];
    textField.inputAccessoryView = containerView;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.stringTitle = textField.text;
}
#pragma mark -
- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [self.tableView reloadData];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}
- (void)scrollToCursorForTextView:(UITextView *)textView {
    CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    cursorRect = [self.tableView convertRect:cursorRect fromView:textView];
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 20;
        [self.tableView scrollRectToVisible:cursorRect animated:YES];
    }
}

- (BOOL)rectVisible:(CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.tableView.contentOffset;
    visibleRect.origin.y += self.tableView.contentInset.top;
    visibleRect.size = self.tableView.bounds.size;
    visibleRect.size.height -= self.tableView.contentInset.top + self.tableView.contentInset.bottom;
    
    return CGRectContainsRect(visibleRect, rect);
}
#pragma  mark -
- (IBAction)clickBtnAddPhotoGroup:(id)sender {
    
    _numberGroup += 2;
    [self.arrayContentGroup addObject:@""];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [self.arrayImage addObject:array];
    [self.arrayCheckUpload addObject:array];
    [self.arrayCheckUploadComplete addObject:array];
    [self.arrayInfoImage addObject:array];
    [self.arrayURL addObject:array];
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    [self presentViewController:elcPicker animated:YES completion:nil];
    if(_numberGroup == 5){
        clickAt = 0;
    }
    else{
        clickAt = (_numberGroup - 5)/2;
    }
    [UIView setAnimationsEnabled:NO];
    check = YES;
    [self.tableView.layer removeAllAnimations];
    //    [self.tableView setContentOffset:CGPointMake(self.offset.x,self.offset.y + [UIScreen mainScreen].bounds.size.width / 3) animated:NO];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_numberGroup-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [UIView setAnimationsEnabled:YES];
    
    
}

- (IBAction)clickBtnHideKeyboard:(id)sender {
    [self.view endEditing:YES];
}
-(void)clickBtnAddImage{
    
    
}
#pragma mark ELCImagePickerControllerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSLog(@"Done");
    [self dismissViewControllerAnimated:YES completion:nil];
    NSMutableArray *myArray;
    NSMutableArray *myArrayInfo ;
    NSMutableArray *myArrayURL ;
    NSMutableArray *arrayCheck;
    NSMutableArray *arrayCheckUploadComplete;
    NSMutableArray *tmp;
    myArray = self.arrayImage[clickAt];
    myArrayInfo = [self.arrayInfoImage[clickAt] mutableCopy];
    myArrayURL = [self.arrayURL[clickAt] mutableCopy];
    arrayCheck = [self.arrayCheckUpload[clickAt] mutableCopy];
    arrayCheckUploadComplete = [self.arrayCheckUploadComplete[clickAt] mutableCopy];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage *image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [arrayCheck addObject:@"NO"];
                [arrayCheckUploadComplete addObject:@"NO"];
                [myArrayURL addObject:@""];
                [myArray addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
    }
    self.arrayURL[clickAt] = myArrayURL;
    self.arrayCheckUpload[clickAt] = arrayCheck;
    
    self.arrayInfoImage[clickAt] = myArrayInfo;
    self.arrayImage[clickAt] = myArray;
    self.arrayCheckUploadComplete[clickAt] = arrayCheckUploadComplete;
    [self.tableView reloadData];
    
    //    [self upload];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - collectionView delegate
-(void)clickBtnAddImage:(NSInteger)cellIndex{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    clickAt = (cellIndex - 2) / 2;
}
-(void)uploadCompleteAImage:(NSInteger)cellIndex{
    [UIView setAnimationsEnabled:NO];
    self.offset = self.tableView.contentOffset;
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    [self.tableView.layer removeAllAnimations];
    self.tableView.contentOffset = self.offset;
    [UIView setAnimationsEnabled:YES];
}
#pragma mark - alearview
-(void)clickBtnPost:(NSString *)idCategory location:(NSString *)location lat:(float)lat lon:(float)lon{
    NSArray *user_tagged = [[NSArray alloc]initWithObjects: nil];
    PostModel *post = [[PostModel alloc]init];
    post.title = self.stringTitle;
    post.category = idCategory;
    LocationPost *loca = [[LocationPost alloc]init];
    
    loca.name = location;
    loca.lat = lat;
    loca.lon = lon;
    if(loca.lat == 0 && loca.lon == 0){
        loca.lat = self.detailPost.lat;
        loca.lon = self.detailPost.lon;
    }
    post.location = loca;
    NSLog(@"%@" , post.location);
    post.user_tagged = user_tagged;
    post.image_groups = [[NSMutableArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for(int i = 0 ; i < self.arrayContentGroup.count ; i++){
        Image_Groups_Post *imageGroup = [[Image_Groups_Post alloc]init];
        NSString *tmp = [self.arrayContentGroup[i] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        imageGroup.title = tmp;
        if(i != self.arrayContentGroup.count - 1){
            imageGroup.photos = self.arrayURL[i];
        }
        
        [array addObject:imageGroup];
    }
    Image_Groups_Post *imageGroup = array[array.count - 1];
    if([imageGroup.title caseInsensitiveCompare:@""] == NSOrderedSame){
        [array removeLastObject];
    }
    post.image_groups = array;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:spinner];
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setColor:[UIColor blackColor]];
    [spinner setFrame:CGRectMake((self.view.frame.size.width/2)-(spinner.frame.size.width/2), (self.view.frame.size.height/2)-(spinner.frame.size.height/2), spinner.frame.size.width, spinner.frame.size.height)];
    [spinner startAnimating];
    NSString *tmp = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@",self.detailPost.idPost];
    NSURL * url = [[NSURL alloc]initWithString:tmp];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSData *requestData = [[post toJSONString] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    if (requestData.length>0) {
        [urlRequest setHTTPMethod:@"PUT"];
        [urlRequest setValue:string forHTTPHeaderField:@"Authorization"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody: requestData];
    }
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data.length>0 && error==nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"Dict=%@",dict);
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [self updateComplete];
                               [spinner stopAnimating];
                           });
        }
    }];
    [dataTask resume];
    [alertView close];
    
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
}
-(void)updateComplete{
    if ([self.delegate respondsToSelector:@selector(updateComplete)]) {
        [self.delegate updateComplete];
    }
    [[self navigationController] popViewControllerAnimated:NO];
}
-(void)clickBtnDangBaiViet{
    
    BOOL checkUpload = YES;
    for(NSArray *array in self.arrayCheckUploadComplete){
        for(NSString *url in array){
            if([url caseInsensitiveCompare:@"NO"] == NSOrderedSame){
                checkUpload = NO;
            }
        }
    }
    if(checkUpload){
        AlertView *detailView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AlertView class]) owner:nil options:nil] objectAtIndex:0];
        detailView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2 /5);
        detailView.delegate = self;
        detailView.lblLocation.text = self.detailPost.location;
        detailView.lat = self.detailPost.lat;
        detailView.lon = self.detailPost.lon;
        alertView = [[CustomIOSAlertView alloc] init];
        
        [alertView setContainerView:detailView];
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
        [alertView setTintColor:[UIColor whiteColor]];
        [alertView setBackgroundColor:[UIColor colorWithRed:31 green:137 blue:255 alpha:1]];
        [alertView setDelegate:self];
        
        // You may use a Block, rather than a delegate.
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
            [alertView close];
        }];
        alertView.parentView.userInteractionEnabled = YES;
        [alertView setUseMotionEffects:true];
        [alertView show];
        [alertView bringSubviewToFront:self.view];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quá trình tải ảnh chưa xong , đợi trong giây lát!"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Đồng ý"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
