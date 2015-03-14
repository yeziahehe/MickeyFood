//
//  ShoppingCarViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/2/2.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShoppingCarTableViewCell.h"
#import "FoodDetailViewController.h"
#import "ShoppingCar.h"

#define kGetShoppingCarDownloadKey          @"GetShoppingCarDownloadKey"
#define kDeleteShoppingCarDownloadKey       @"DeleteShoppingCarDownloadKey"
#define kEditShoppingCarDownloadKey         @"EditShoppingCarDownloadKey"
#define kDeleteAllShoppingCarDownloadKey     @"DeleteAllShoppingCarDownloadKey"
#define kSelecteButtonClickedNotification   @"SelecteButtonClickedNotification"

@interface ShoppingCarViewController ()
@property (nonatomic, strong) NSMutableArray *shoppingCarArray;
@property (nonatomic, strong) ShoppingCar *shoppingCarInfo;
@property (nonatomic, strong) NSMutableArray *shoppingCarCodeArray;
@property (nonatomic, strong) NSMutableArray *selectStatusArray;//0-未选中，1-选中
@property (nonatomic, strong) NSMutableArray *editStatusArray;//0-未编辑，1-编辑
@property (nonatomic, strong) NSString *tag;//0-未选择，1-全选，2-选择部分
@property (nonatomic, strong) NSString *totalPrice;
@property (strong, nonatomic) IBOutlet UIButton *calculateButton;
@property (strong, nonatomic) IBOutlet UILabel *allLabel;
@property (strong, nonatomic) IBOutlet UILabel *RMBLabel;
@property (strong, nonatomic) NSString *editTag;//0-未编辑，1-编辑
@end

@implementation ShoppingCarViewController
@synthesize shoppingCarTableView;
@synthesize noFoodView,calculateFoodView;
@synthesize totalPriceLabel;
@synthesize shoppingCarArray,shoppingCarInfo,shoppingCarCodeArray,selectStatusArray,editStatusArray,tag,totalPrice,totalPriceButton,editTag;
@synthesize calculateButton,allLabel,RMBLabel;

#pragma mark - Public Methods
- (void)loadSubViews
{
    //初始化界面为购物车中没有商品
    self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
    self.shoppingCarTableView.tableFooterView = self.noFoodView;
    self.shoppingCarTableView.scrollEnabled = NO;
    self.calculateFoodView.hidden = YES;
    [self setNaviTitle:@"购物车"];
    [self setRightNaviItemWithTitle:nil imageName:nil];
    [self.shoppingCarTableView reloadData];
}

- (void)requestForShoppingCar
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetOrderUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kGetShoppingCarDownloadKey];
}

- (void)requestForDelete:(NSString *)orderId
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kDeleteOrderUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:orderId forKey:@"orderId"];
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kDeleteShoppingCarDownloadKey];
}

- (void)requestForEdit:(NSString *)orderId withOrderCount:(NSString *)orderCount
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kEditUserOrderUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:orderId forKey:@"orderId"];
    [dict setObject:orderCount forKey:@"orderCount"];
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kEditShoppingCarDownloadKey];
}

- (void)requestForDeleteAll:(NSString *)orderId
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kDeleteAllUserOrderUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:orderId forKey:@"orderId"];
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kDeleteAllShoppingCarDownloadKey];
}

- (void)refreshShoppingCarInfo
{
    [self requestForShoppingCar];
}

#pragma mark - IBActions Methods
- (IBAction)addFoodButtonClicked:(id)sender
{
    //跳转到商品界面
    self.tabBarController.selectedIndex = 0;
}

- (void)selectButtonClicked:(UIButton *)button
{
    button.selected = !button.selected;
    //ShoppingCarTableViewCell *cell = (ShoppingCarTableViewCell *)[[[button superview]superview]superview];
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.shoppingCarTableView];
    NSIndexPath *indexPath = [self.shoppingCarTableView indexPathForRowAtPoint:buttonPosition];
    ShoppingCarTableViewCell *cell = (ShoppingCarTableViewCell *)[self.shoppingCarTableView cellForRowAtIndexPath:indexPath];
    ShoppingCar *sc = [self.shoppingCarArray objectAtIndex:indexPath.row];
    if (button.selected) {
        [self.shoppingCarCodeArray addObject:sc.orderId];
        self.totalPrice = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]+[cell.priceLabel.text floatValue]*[sc.orderCount intValue]];
        [self.selectStatusArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    } else {
        [self.shoppingCarCodeArray removeObject:sc.orderId];
        self.totalPrice = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]-[cell.priceLabel.text floatValue]*[sc.orderCount intValue]];
        [self.selectStatusArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    if (self.shoppingCarCodeArray.count == self.shoppingCarArray.count) {
        self.tag = @"1";
    } else if (self.shoppingCarCodeArray.count == 0) {
        self.tag = @"0";
    } else {
        self.tag = @"2";
    }
    [self.shoppingCarTableView reloadData];
    [self.shoppingCarTableView layoutIfNeeded];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelecteButtonClickedNotification object:nil];
}

- (void)editButtonClicked:(UIButton *)button
{
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.shoppingCarTableView];
    NSIndexPath *indexPath = [self.shoppingCarTableView indexPathForRowAtPoint:buttonPosition];
    [self.editStatusArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [self.shoppingCarTableView reloadData];
}

- (void)confirmNumButtonClicked:(UIButton *)button
{
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.shoppingCarTableView];
    NSIndexPath *indexPath = [self.shoppingCarTableView indexPathForRowAtPoint:buttonPosition];
    [self.editStatusArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    [self.shoppingCarTableView reloadData];
}

- (void)minusButtonClicked:(UIButton *)button
{
    //oedercount change
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.shoppingCarTableView];
    NSIndexPath *indexPath = [self.shoppingCarTableView indexPathForRowAtPoint:buttonPosition];
    ShoppingCar *sc = [self.shoppingCarArray objectAtIndex:indexPath.row];
    if ([sc.orderCount isEqualToString:@"1"]) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"已减少到最小数量" customView:nil hideDelay:2.f];
    } else {
        sc.orderCount = [NSString stringWithFormat:@"%d",[sc.orderCount intValue]-1];
        [self.shoppingCarTableView reloadData];
        //request for change
        [self requestForEdit:sc.orderId withOrderCount:sc.orderCount];
    }
}

- (void)plusButtonClicked:(UIButton *)button
{
    //oedercount change
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.shoppingCarTableView];
    NSIndexPath *indexPath = [self.shoppingCarTableView indexPathForRowAtPoint:buttonPosition];
    ShoppingCar *sc = [self.shoppingCarArray objectAtIndex:indexPath.row];
    if ([sc.orderCount intValue] > [sc.foodCount intValue]) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"已增加到最大库存" customView:nil hideDelay:2.f];
    } else {
        sc.orderCount = [NSString stringWithFormat:@"%d",[sc.orderCount intValue]+1];
        [self.shoppingCarTableView reloadData];
        //request for change
        [self requestForEdit:sc.orderId withOrderCount:sc.orderCount];
    }
}

- (IBAction)allSelectButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.tag = @"1";
        [self.shoppingCarCodeArray removeAllObjects];
        [self.selectStatusArray removeAllObjects];
        self.totalPrice = @"0.00";
        for (int i = 0; i < self.shoppingCarArray.count; i++) {
            ShoppingCar *sc = [self.shoppingCarArray objectAtIndex:i];
            [self.shoppingCarCodeArray addObject:sc.orderId];
            [self.selectStatusArray addObject:@"1"];
            if ([sc.isDiscount isEqualToString:@"1"]) {
                self.totalPrice = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]+[sc.discountPrice floatValue]*[sc.orderCount intValue]];
            } else {
                self.totalPrice = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]+[sc.price floatValue]*[sc.orderCount intValue]];
            }
        }
    } else {
        self.tag = @"0";
        [self.shoppingCarCodeArray removeAllObjects];
        [self.selectStatusArray removeAllObjects];
        for (int i = 0; i < self.shoppingCarArray.count; i++) {
            [self.selectStatusArray addObject:@"0"];
        }
        self.totalPrice = @"0.00";
    }
    [self.shoppingCarTableView reloadData];
    [self.shoppingCarTableView layoutIfNeeded];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelecteButtonClickedNotification object:nil];
}

- (void)editForDeleteButtonClicked:(UIButton *)button
{
    //删除按钮
    if (self.shoppingCarCodeArray.count == 0) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"请选择要删除的购物车商品" customView:nil hideDelay:2.f];
    } else {
        if (IsIos8) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:@"确认删除？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        NSString *orderIdString = [self.shoppingCarCodeArray componentsJoinedByString:@","];
                                                        NSArray *array = [NSArray arrayWithArray:self.shoppingCarArray];
                                                        for (int i = 0; i < self.shoppingCarCodeArray.count; i++) {
                                                            for (ShoppingCar *sc in array) {
                                                                if ([sc.orderId isEqualToString:[self.shoppingCarCodeArray objectAtIndex:i]]) {
                                                                    [self.selectStatusArray removeObjectAtIndex:[self.shoppingCarArray indexOfObject:sc]];
                                                                    [self.editStatusArray removeObjectAtIndex:[self.shoppingCarArray indexOfObject:sc]];
                                                                    [self.shoppingCarArray removeObject:sc];
                                                                }
                                                            }
                                                        }
                                                        [self.shoppingCarCodeArray removeAllObjects];
                                                        [self setNaviTitle:[NSString stringWithFormat:@"购物车(%lu)",(unsigned long)self.shoppingCarArray.count]];
                                                        [self requestForDeleteAll:orderIdString];
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            NSString *orderIdString = [self.shoppingCarCodeArray componentsJoinedByString:@","];
            NSArray *array = [NSArray arrayWithArray:self.shoppingCarArray];
            for (int i = 0; i < self.shoppingCarCodeArray.count; i++) {
                for (ShoppingCar *sc in array) {
                    if ([sc.orderId isEqualToString:[self.shoppingCarCodeArray objectAtIndex:i]]) {
                        [self.selectStatusArray removeObjectAtIndex:[self.shoppingCarArray indexOfObject:sc]];
                        [self.editStatusArray removeObjectAtIndex:[self.shoppingCarArray indexOfObject:sc]];
                        [self.shoppingCarArray removeObject:sc];
                    }
                }
            }
            [self.shoppingCarCodeArray removeAllObjects];
            [self setNaviTitle:[NSString stringWithFormat:@"购物车(%lu)",(unsigned long)self.shoppingCarArray.count]];
            [self requestForDeleteAll:orderIdString];
        }
    }
}

- (void)calculateButtonClicked:(UIButton *)button
{
    //结算按钮
    if (self.shoppingCarCodeArray.count == 0) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"请选择要结算的购物车商品" customView:nil hideDelay:2.f];
    } else {
        //下单请求
    }
}

#pragma mark - Notification Methods
- (void)refreshShoppingCarWithNotification:(NSNotification *)notification
{
    [self requestForShoppingCar];
}

- (void)selectedState
{
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]];
}

#pragma mark - BaseViewController methods
- (void)rightItemTapped
{
    if ([self.editTag isEqualToString:@"0"]) {
        [self setRightNaviItemWithTitle:@"完成" imageName:nil];
        //do edit
        self.editTag = @"1";
        for (int i = 0; i < self.shoppingCarArray.count; i++) {
            [self.editStatusArray replaceObjectAtIndex:i withObject:@"1"];
        }
        [self.calculateButton setTitle:@"删除" forState:UIControlStateNormal];
        self.allLabel.hidden = YES;
        self.totalPriceLabel.hidden = YES;
        self.RMBLabel.hidden = YES;
        [self.calculateButton addTarget:self action:@selector(editForDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.shoppingCarTableView reloadData];
    } else if ([self.editTag isEqualToString:@"1"]){
        [self setRightNaviItemWithTitle:@"编辑全部" imageName:nil];
        //do edit finish
        self.editTag = @"0";
        for (int i = 0; i < self.shoppingCarArray.count; i++) {
            [self.editStatusArray replaceObjectAtIndex:i withObject:@"0"];
        }
        [self.calculateButton setTitle:@"结算" forState:UIControlStateNormal];
        self.allLabel.hidden = NO;
        self.totalPriceLabel.hidden = NO;
        self.RMBLabel.hidden = NO;
        [self.calculateButton addTarget:self action:@selector(calculateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.shoppingCarTableView reloadData];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"购物车"];
    self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
    self.shoppingCarTableView.tableFooterView = [UIView new];
    [self.shoppingCarTableView addHeaderWithTarget:self action:@selector(refreshShoppingCarInfo) dateKey:@"shoppingCarTableView"];
    if ([[MemberDataManager sharedManager] isLogin]) {
        [self requestForShoppingCar];
    } else {
        [self.shoppingCarTableView removeHeader];
        [self loadSubViews];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShoppingCarWithNotification:) name:kRefreshShoppingCarNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedState) name:kSelecteButtonClickedNotification object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shoppingCarArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"ShoppingCarTableViewCell";
    ShoppingCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ShoppingCarTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }

    self.shoppingCarInfo = [self.shoppingCarArray objectAtIndex:indexPath.row];
    if ([self.shoppingCarInfo.isDiscount isEqualToString:@"1"]) {
        //无折扣
        cell.discountLine.hidden = NO;
        cell.discountPriceLabel.hidden = NO;
        cell.discountPriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.shoppingCarInfo.price floatValue]];
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[self.shoppingCarInfo.discountPrice floatValue]];
    } else {
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[self.shoppingCarInfo.price floatValue]];
    }
    cell.foodImageView.cacheDir = kUserIconCacheDir;
    [cell.foodImageView aysnLoadImageWithUrl:self.shoppingCarInfo.imageUrl placeHolder:@"loading_square.png"];
    cell.foodNameLabel.text = self.shoppingCarInfo.name;
    cell.foodSpecalLabel.text = self.shoppingCarInfo.specialName;
    cell.orderId = self.shoppingCarInfo.orderId;
    cell.numberLabel.text = [NSString stringWithFormat:@"x%@",self.shoppingCarInfo.orderCount];
    if ([self.shoppingCarInfo.foodCount isEqualToString:@"0"]) {
        cell.countStatusLabel.hidden = NO;
        cell.countStatusLabel.text = @"暂时缺货";
    }
    else if ([self.shoppingCarInfo.foodCount intValue] <= 10)
    {
        cell.countStatusLabel.hidden = NO;
        cell.countStatusLabel.text = @"库存紧张";
    } else {
        cell.countStatusLabel.hidden = YES;
        cell.countStatusLabel.text = @"";
    }
    //判断购物车中数据是否被选中
    if ([self.tag isEqualToString:@"1"]) {
        cell.selectButton.selected = YES;
        self.totalPriceButton.selected = YES;
    } else if ([self.tag isEqualToString:@"0"]) {
        cell.selectButton.selected = NO;
        self.totalPriceButton.selected = NO;
    } else if ([self.tag isEqualToString:@"2"]) {
        self.totalPriceButton.selected = NO;
        if ([[self.selectStatusArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
            cell.selectButton.selected = YES;
        } else {
            cell.selectButton.selected = NO;
        }
    }
    //判断购物车中的数据是否在编辑
    if ([[self.editStatusArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        cell.foodSpecalLabel.hidden = YES;
        cell.numberLabel.hidden = YES;
        cell.editButton.hidden = YES;
        cell.minusButton.hidden = NO;
        cell.numberTextField.hidden = NO;
        cell.plusButton.hidden = NO;
        cell.confirmNumButton.hidden = NO;
        cell.numberTextField.text = self.shoppingCarInfo.orderCount;
        cell.countStatusLabel.hidden = YES;
        if ([self.editTag isEqualToString:@"1"]) {
            cell.confirmNumButton.hidden = YES;
        } else {
            cell.confirmNumButton.hidden = NO;
        }
    } else {
        cell.foodSpecalLabel.hidden = NO;
        cell.numberLabel.hidden = NO;
        cell.editButton.hidden = NO;
        cell.minusButton.hidden = YES;
        cell.numberTextField.hidden = YES;
        cell.plusButton.hidden = YES;
        cell.confirmNumButton.hidden = YES;
        cell.countStatusLabel.hidden = NO;
    }
    
    [cell.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.confirmNumButton addTarget:self action:@selector(confirmNumButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.minusButton addTarget:self action:@selector(minusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.plusButton addTarget:self action:@selector(plusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.numberTextField.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FoodDetailViewController *foodDetailViewController = [[FoodDetailViewController alloc] initWithNibName:@"FoodDetailViewController" bundle:nil];
    ShoppingCar *shoppingCar = [self.shoppingCarArray objectAtIndex:indexPath.row];
    foodDetailViewController.foodId = shoppingCar.foodId;
    [self.navigationController pushViewController:foodDetailViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (IsIos8) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:@"确认删除？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        ShoppingCarTableViewCell *cell = (ShoppingCarTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                                                        [self requestForDelete:cell.orderId];
                                                        [self.shoppingCarArray removeObjectAtIndex:indexPath.row];
                                                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            ShoppingCarTableViewCell *cell = (ShoppingCarTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [self requestForDelete:cell.orderId];
            [self.shoppingCarArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - UITextFieldDelegate methods
- (void)resignAllField
{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGPoint buttonPosition = [textField convertPoint:CGPointZero toView:self.shoppingCarTableView];
    NSIndexPath *indexPath = [self.shoppingCarTableView indexPathForRowAtPoint:buttonPosition];
    ShoppingCar *sc = [self.shoppingCarArray objectAtIndex:indexPath.row];
    if ([sc.orderCount isEqualToString:@"1"]) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"已减少到最小数量" customView:nil hideDelay:2.f];
    } else if ([sc.orderCount intValue] > [sc.foodCount intValue]) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"已增加到最大库存" customView:nil hideDelay:2.f];
    } else {
        sc.orderCount = textField.text;
        [self.shoppingCarTableView reloadData];
        //request for change
        [self requestForEdit:sc.orderId withOrderCount:sc.orderCount];
    }
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kGetShoppingCarDownloadKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            [self.shoppingCarTableView headerEndRefreshing];
            self.tag = @"0";
            self.editTag = @"0";
            self.totalPrice = @"0.00";
            self.totalPriceLabel.text = @"0.00";
            self.totalPriceButton.selected = NO;
            self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
            self.shoppingCarCodeArray = [NSMutableArray arrayWithCapacity:0];
            self.selectStatusArray = [NSMutableArray arrayWithCapacity:0];
            self.editStatusArray = [NSMutableArray arrayWithCapacity:0];
            [self.calculateButton setTitle:@"结算" forState:UIControlStateNormal];
            self.allLabel.hidden = NO;
            self.totalPriceLabel.hidden = NO;
            self.RMBLabel.hidden = NO;
            [self.calculateButton addTarget:self action:@selector(calculateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self setRightNaviItemWithTitle:@"编辑全部" imageName:nil];
            NSArray *valueArray = [dict objectForKey:@"orderList"];
            for(NSDictionary *valueDict in valueArray)
            {
                ShoppingCar *shoppingCar = [[ShoppingCar alloc] initWithDict:valueDict];
                [self.shoppingCarArray addObject:shoppingCar];
                [self.selectStatusArray addObject:@"0"];
                [self.editStatusArray addObject:@"0"];
            }
            if ([self.shoppingCarArray count] != 0) {
                self.shoppingCarTableView.tableFooterView = [UIView new];
                self.calculateFoodView.hidden = NO;
                self.shoppingCarTableView.scrollEnabled = YES;
                [self setNaviTitle:[NSString stringWithFormat:@"购物车(%lu)",(unsigned long)self.shoppingCarArray.count]];
                [self.shoppingCarTableView reloadData];
            } else {
                [self loadSubViews];
            }
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"购物车信息获取失败";
            [self loadSubViews];
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
    else if ([downloader.purpose isEqualToString:kDeleteShoppingCarDownloadKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [self.shoppingCarTableView reloadData];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"删除失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
    else if ([downloader.purpose isEqualToString:kEditShoppingCarDownloadKey])
    {
        if ([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode]) {
            //成功
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"修改数量失败";
        }
    }
    else if ([downloader.purpose isEqualToString:kDeleteAllShoppingCarDownloadKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [self.shoppingCarTableView reloadData];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"删除失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [self loadSubViews];
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
