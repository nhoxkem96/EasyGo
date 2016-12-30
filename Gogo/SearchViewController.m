#import "SearchViewController.h"
#import "Utils.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Object.h"
#import "SearchModel.h"
#import "SearchTableViewCell.h"
#import "Utils.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "Forecast.h"
#import "WeatherCollectionViewCell.h"
#import "SearchHotelTableViewCell.h"
#import "SearchHotelModel.h"
#import "FlightViewController.h"
@interface SearchViewController ()<UITabBarDelegate>{
    int check ;
}

@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    check = 0;
    // Do any additional setup after loading the view.
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapRecognizer];
    self.results = [[NSMutableArray alloc]init];
    self.arrayHotel = [[NSMutableArray alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSearchBar];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66/255.0f green:100/255.0f blue:50/255.0f alpha:1]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WeatherCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WeatherCollectionViewCell class])];
    [self setFont];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
-(void)setFont{
    [_lblWeatherTemp setFont: [_lblWeatherTemp.font fontWithSize:[Utils fontSizeBig] * 3]];
    [_lblWeatherTime setFont: [_lblWeatherTemp.font fontWithSize:[Utils fontSizeBig] ]];
    [_lblWeatherLocation setFont: [_lblWeatherTemp.font fontWithSize:[Utils fontSizeBig] * 2]];
}
#pragma  mark - edit keyboard
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}
- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton = false;
    self.searchBar.placeholder = @"Tìm kiếm";
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = self.searchBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - show bai viet
- (IBAction)changeSegment:(id)sender {
    switch (self.segment.selectedSegmentIndex)
    {
        case 0:{
            check = 0;
            self.tableView.hidden = NO;
            _vWeather.hidden = YES;
            [self.arrayHotel removeAllObjects];
            NSString *loadNew = [NSString stringWithFormat:@"http:easygo.com.vn/api/search/post?keyword=%@&page=1" , self.searchBar.text];
            NSLog(@"%@" , loadNew);
            NSURL *URL = [NSURL URLWithString:[loadNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                           fromJSONDictionary:responseObject
                                                        error:nil];
                if(object.code == 1){
                    NSArray *results = [MTLJSONAdapter modelsOfClass:[SearchModel class] fromJSONArray:object.result error:nil];
                    self.results = results;
                    [self.tableView reloadData];
                    NSLog(@"%@" , object.result);
                }
                else NSLog(@"%@" , object.message);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            break;
        }
        case 1:{
            self.tableView.hidden = NO;
            check = 1;
            _vWeather.hidden = YES;
            [self.arrayHotel removeAllObjects];
            NSString *loadNew = [NSString stringWithFormat:@"http:easygo.com.vn/api/search/post?keyword=%@&page=1&category=57e77bbd1a7160bc7a758e85" , self.searchBar.text];
            NSLog(@"%@" , loadNew);
            NSURL *URL = [NSURL URLWithString:[loadNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                           fromJSONDictionary:responseObject
                                                        error:nil];
                if(object.code == 1){
                    NSArray *results = [MTLJSONAdapter modelsOfClass:[SearchModel class] fromJSONArray:object.result error:nil];
                    
                    self.results = results;
                    [self.tableView reloadData];
                    NSLog(@"success");
                }
                else NSLog(@"%@" , object.message);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            break;
        }
        case 2:{
            check = 2;
            self.tableView.hidden = NO;
            _vWeather.hidden = YES;
            [self.results removeAllObjects];
            [self.tableView reloadData];
            NSString *loadNew = [NSString stringWithFormat:@"http:easygo.com.vn:6996/api/hotel?q=%@&p=1" , self.searchBar.text];
            NSLog(@"%@" , loadNew);
            NSURL *URL = [NSURL URLWithString:[loadNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    NSArray *results = [MTLJSONAdapter modelsOfClass:[SearchHotelModel class] fromJSONArray:responseObject error:nil];
                    
                    self.arrayHotel = results;
                    [self.tableView reloadData];
                    NSLog(@"success");
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            break;
        }
            
        case 3:{
            check = 3;
            [self.arrayHotel removeAllObjects];
            self.tableView.hidden = YES;
            _vWeather.hidden = NO;
            NSString *loadNew = [NSString stringWithFormat:@"http:easygo.com.vn/api/weather?keyword=%@" , self.searchBar.text];
            NSLog(@"%@" , loadNew);
            NSURL *URL = [NSURL URLWithString:[loadNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSArray *dic = [[responseObject objectForKey:@"result"]objectForKey:@"forecast"];
                NSLog(@"abc %@" , dic);
                NSLog(@"count: %lu ", (unsigned long)dic.count);
                NSMutableArray *array = [[NSMutableArray alloc]init];
                for(int i = 0 ; i < dic.count;i++){
                    Forecast *forecast = [[Forecast alloc]init];
                    forecast.code = [[dic objectAtIndex:i]objectForKey:@"code"];
                    forecast.date = [[dic objectAtIndex:i]objectForKey:@"date"];
                    forecast.day = [[dic objectAtIndex:i]objectForKey:@"day"];
                    forecast.high = [[dic objectAtIndex:i]objectForKey:@"high"];
                    forecast.low = [[dic objectAtIndex:i]objectForKey:@"low"];
                    forecast.text = [[dic objectAtIndex:i]objectForKey:@"text"];
                    [array addObject:forecast];
                }
                self.results = array;
                if(dic.count > 0){
                    _lblWeatherLocation.text = [[[responseObject objectForKey:@"result"]objectForKey:@"location"] objectForKey:@"city"];
                    _lblWeatherTime.text = [[responseObject objectForKey:@"result"]objectForKey:@"pubDate"];
                    NSString *tmp = [[responseObject objectForKey:@"result"]objectForKey:@"pubDate"];
                    int temp = (int)[[[[responseObject objectForKey:@"result"]objectForKey:@"condition"] objectForKey:@"temp"] integerValue];
                    _lblWeatherTemp.text = [NSString stringWithFormat:@"%d°C" ,(int)((temp - 32)/1.8) ];
                }
                else{
                    _lblWeatherTime.text = @"Không tìm thấy địa điểm.";
                    _lblWeatherLocation.text = @"";
                    _lblWeatherTemp.text = @"";
                }
                [self.collectionView reloadData];
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            break;
        }
        case 4:{
            FlightViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"FlightViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break; 
    }
}

#pragma mark - searchBar delegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:NO animated:NO];
    if(check == 2){
        
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(![searchText  isEqual: @""]){
        if(check == 0){
            
            NSString *loadNew = [NSString stringWithFormat:@"http:easygo.com.vn/api/search/post?keyword=%@&page=1" , searchText];
            NSLog(@"%@" , loadNew);
            NSURL *URL = [NSURL URLWithString:[loadNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                           fromJSONDictionary:responseObject
                                                        error:nil];
                if(object.code == 1){
                    NSArray *results = [MTLJSONAdapter modelsOfClass:[SearchModel class] fromJSONArray:object.result error:nil];
                    self.results = results;
                    [self.tableView reloadData];
                    NSLog(@"success");
                }
                else NSLog(@"%@" , object.message);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
        if(check ==1){
            NSString *loadNew = [NSString stringWithFormat:@"http:easygo.com.vn/api/search/post?keyword=%@&page=1&category=57e77bbd1a7160bc7a758e85" , self.searchBar.text];
            NSLog(@"%@" , loadNew);
            NSURL *URL = [NSURL URLWithString:[loadNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                           fromJSONDictionary:responseObject
                                                        error:nil];
                if(object.code == 1){
                    NSArray *results = [MTLJSONAdapter modelsOfClass:[SearchModel class] fromJSONArray:object.result error:nil];
                    self.results = results;
                    [self.tableView reloadData];
                    NSLog(@"success");
                }
                else NSLog(@"%@" , object.message);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];

        }
        if(check == 2){
            NSString *loadNew = [NSString stringWithFormat:@"http:easygo.com.vn:6996/api/hotel?q=%@&p=1" , self.searchBar.text];
            NSLog(@"%@" , loadNew);
            NSURL *URL = [NSURL URLWithString:[loadNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSArray *results = [MTLJSONAdapter modelsOfClass:[SearchHotelModel class] fromJSONArray:responseObject error:nil];
                
                self.arrayHotel = results;
                [self.tableView reloadData];
                NSLog(@"success");
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];

        }
        if(check == 3){
            _vWeather.hidden = NO;
            NSString *loadNew = [NSString stringWithFormat:@"http:easygo.com.vn/api/weather?keyword=%@" , self.searchBar.text];
            NSLog(@"%@" , loadNew);
            NSURL *URL = [NSURL URLWithString:[loadNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSArray *dic = [[responseObject objectForKey:@"result"]objectForKey:@"forecast"];
                NSLog(@"abc %@" , dic);
                NSLog(@"count: %lu ", (unsigned long)dic.count);
                NSMutableArray *array = [[NSMutableArray alloc]init];
                for(int i = 0 ; i < dic.count;i++){
                    Forecast *forecast = [[Forecast alloc]init];
                    forecast.code = [[dic objectAtIndex:i]objectForKey:@"code"];
                    forecast.date = [[dic objectAtIndex:i]objectForKey:@"date"];
                    forecast.day = [[dic objectAtIndex:i]objectForKey:@"day"];
                    forecast.high = [[dic objectAtIndex:i]objectForKey:@"high"];
                    forecast.low = [[dic objectAtIndex:i]objectForKey:@"low"];
                    forecast.text = [[dic objectAtIndex:i]objectForKey:@"text"];
                    [array addObject:forecast];
                }
                self.results = array;
                if(dic.count > 0){
                    _lblWeatherLocation.text = [[[responseObject objectForKey:@"result"]objectForKey:@"location"] objectForKey:@"city"];
                    _lblWeatherTime.text = [[responseObject objectForKey:@"result"]objectForKey:@"pubDate"];
                    NSString *tmp = [[responseObject objectForKey:@"result"]objectForKey:@"pubDate"];
                    NSInteger temp = [[[[responseObject objectForKey:@"result"]objectForKey:@"condition"] objectForKey:@"temp"] integerValue];
                    _lblWeatherTemp.text = [NSString stringWithFormat:@"%d°C" , (int)((temp - 32)/1.8)];
                }
                else{
                    _lblWeatherTime.text = @"Không tìm thấy địa điểm.";
                    _lblWeatherLocation.text = @"";
                    _lblWeatherTemp.text = @"";
                }
                [self.collectionView reloadData];
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];

        }

    }
    if([searchText  isEqual: @""]){
        [searchBar resignFirstResponder];
        [self.results removeAllObjects];
        NSLog(@"%@" , self.results);
        [self.tableView reloadData];
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:NO];
    for (UIView *view in searchBar.subviews)
    {
        for (id subview in view.subviews)
        {
            if ( [subview isKindOfClass:[UIButton class]] )
            {
                [subview setEnabled:YES];
                UIButton *cancelButton = (UIButton*)subview;
                [cancelButton setTitle:@"Hủy" forState:UIControlStateNormal];
                
                
                NSLog(@"enableCancelButton");
                return;
            }
        }
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.results removeAllObjects];
    [self.tableView reloadData];
}

#pragma  mark - tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(check == 2){
        SearchHotelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHotelTableViewCell"];
        SearchHotelModel *hotel = self.arrayHotel[indexPath.row];
        cell.lblHotelName.text = hotel.name;
        NSString *price = [NSString stringWithFormat:@"Giá: %@",hotel.price];
        cell.lblHotelPrice.text = price;
        cell.lblHotelAddress.text = hotel.address;
        NSString *linkImage = [NSString stringWithFormat:@"%@" , hotel.image];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[linkImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                          placeholderImage:[UIImage imageNamed:@"1"]];
        return cell;
    }
    else{
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
        SearchModel *search = self.results[indexPath.row];
        NSString *linkAvatar = [NSString stringWithFormat:@"%@" , search.avatar];
        
        [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                          placeholderImage:[UIImage imageNamed:@"1"]];
        cell.lblTitle.text = search.title;
        cell.lblNamePost.text = search.author_name;
        NSString *number_like = [NSString stringWithFormat:@"%@" , search.numberLike];
        cell.lblNumberLike.text = number_like;
        NSString *number_comment = [NSString stringWithFormat:@"%@" , search.numberComment];
        cell.lblNumberComment.text = number_comment;
        return cell;

    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(check == 2){
        return self.arrayHotel.count;
    }
    else return self.results.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(check == 2){
        return UITableViewAutomaticDimension;
    }
    else return [UIScreen mainScreen].bounds.size.height * 35 / 284;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(check != 2){
        SearchModel *search = self.results[indexPath.row];
        ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
        vc.idPost = search.postID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)setEditSearchBar{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.view endEditing:YES];
                       [self.searchBar becomeFirstResponder];
                   });
}

#pragma mark - collection view
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.results.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WeatherCollectionViewCell class]) forIndexPath:indexPath];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([WeatherCollectionViewCell class]) owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Forecast *forecast = self.results[indexPath.row];
    cell.lblDay.text = forecast.day;
    cell.lblHighTemperature.text = [NSString stringWithFormat:@"%d°C" , (int)(([forecast.high integerValue] - 32)/1.8) ];
    cell.lblLowTemperature.text = [NSString stringWithFormat:@"%d°C" , (int)(([forecast.low integerValue] - 32)/1.8)];
    NSLog(@"%@" , forecast);
    [cell.iconWeather setFont:[UIFont fontWithName:@"WeatherIcons-Regular" size:28]];
    cell.iconWeather.text =  [Utils weatherIcon:[forecast.code integerValue]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/ 4 ,[UIScreen mainScreen].bounds.size.height/3);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
@end
