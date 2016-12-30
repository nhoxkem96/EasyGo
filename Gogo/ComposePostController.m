//
//  ComposePostController.m
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "ComposePostController.h"
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
#import "UserTagViewController.h"
@interface ComposePostController ()<CollectionViewDelegate , BotViewDelegate , CustomIOSAlertViewDelegate , UITextFieldDelegate , AlearViewDelegate,UserTagDelegate>{
    NSInteger clickAt;
    CustomIOSAlertView *alertView;
    BOOL check;
    PostModel *post;
}
@property UIImagePickerController *imagePickerController;
@property NSString *stringTitle;
@property CGPoint offset;
@end
@implementation ComposePostController
- (void)viewDidLoad {
    [super viewDidLoad];
    clickAt = 0;
    check = NO;
    post = [[PostModel alloc]init];
    self.arrayContentGroup =  [[NSMutableArray alloc] init];
    [self.arrayContentGroup addObject:@""];
    self.numberGroup = 3;
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
        cell.txtTitle.text = self.stringTitle;
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
- (IBAction)clickBtnUserTag:(id)sender {
    UserTagViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"UserTagViewController"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}

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
-(void)clickBtnRightBarButton:(NSArray *)arrayTag{
    post.user_tagged = arrayTag;
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
    if(![self.arrayInfoImage[clickAt]  isEqual: @""]){
        myArray = self.arrayImage[clickAt];
        myArrayInfo = [self.arrayInfoImage[clickAt] mutableCopy];
        myArrayURL = [self.arrayURL[clickAt] mutableCopy];
        arrayCheck = [self.arrayCheckUpload[clickAt] mutableCopy];
        arrayCheckUploadComplete = [self.arrayCheckUploadComplete[clickAt] mutableCopy];
    }
    else{
        myArray = [[NSMutableArray alloc]init];
        myArrayInfo = [[NSMutableArray alloc]init];
        myArrayURL = [[NSMutableArray alloc]init];
        arrayCheck = [[NSMutableArray alloc]init];
        arrayCheckUploadComplete = [[NSMutableArray alloc]init];
        tmp = [[NSMutableArray alloc]init];
    }
    MyImage *myImage = [[MyImage alloc]init];
    myImage.filePath = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSLog(@"%@" , [info valueForKey:UIImagePickerControllerReferenceURL]);
    NSLog(@"%lu" , (unsigned long)arrayCheck.count);
    [myArrayInfo addObject:myImage];
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
    self.arrayCheckUploadComplete[clickAt] = arrayCheckUploadComplete;
    self.arrayInfoImage[clickAt] = myArrayInfo;
    self.arrayImage[clickAt] = myArray;
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
    post.title = self.stringTitle;
    post.category = idCategory;
    LocationPost *loca = [[LocationPost alloc]init];
    loca.name = location;
    loca.lat = lat;
    loca.lon = lon;
    post.location = loca;
    NSLog(@"%@" , post.location);
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
        [array removeObjectAtIndex:array.count - 1];
    }
    post.image_groups = array;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:spinner];
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setColor:[UIColor blackColor]];
    [spinner setFrame:CGRectMake((self.view.frame.size.width/2)-(spinner.frame.size.width/2), (self.view.frame.size.height/2)-(spinner.frame.size.height/2), spinner.frame.size.width, spinner.frame.size.height)];
    [spinner startAnimating];
    NSURL * url = [[NSURL alloc]initWithString:@"http:easygo.com.vn/api/newpost"];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSData *requestData = [[post toJSONString] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    if (requestData.length>0) {
        [urlRequest setHTTPMethod:@"POST"];
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
                               [self upPostComplete];
                               [spinner stopAnimating];
                           });
        }
    }];
    [dataTask resume];
    [self resetData];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
}
-(void)upPostComplete{
    UINavigationController *firstTabNC = [[self.tabBarController viewControllers] objectAtIndex:0];
    HomeViewController *vc = (HomeViewController*)[[firstTabNC viewControllers] objectAtIndex:0];
    [vc resetData];
    [self.tabBarController setSelectedIndex:0];
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
-(void)resetData{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.arrayURL removeAllObjects];
    [self.arrayImage removeAllObjects];
    [self.arrayInfoImage removeAllObjects];
    [self.arrayContentGroup removeAllObjects];
    [self.arrayCheckUpload removeAllObjects];
    [self.arrayCheckUploadComplete removeAllObjects];
    self.stringTitle = @"";
    clickAt = 0;
    [alertView close];
    _numberGroup = 3;
    [self.arrayContentGroup addObject:@""];
    self.arrayImage = [[NSMutableArray alloc]init];
    self.arrayInfoImage = [NSMutableArray new];
    self.arrayURL = [NSMutableArray new];
    self.arrayCheckUpload = [[NSMutableArray alloc]init];
    self.arrayCheckUploadComplete = [[NSMutableArray alloc]init];
    [self.tableView reloadData];
}
@end

