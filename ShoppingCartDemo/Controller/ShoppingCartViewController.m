//
//  ShoppingCartViewController.m
//  
//
//  Created by 李洋 on 16/8/11.
//
//

#import "ShoppingCartViewController.h"

#import "ShoppingCartModel.h"

#import "ShoppingCartHeaderView.h"
#import "ShoppingCartFooterView.h"

#import "ShoppingCartCell.h"

//通过类对象来生成nib
#define NibWithClass(Class)  [UINib nibWithNibName:NSStringFromClass([Class class]) bundle:nil]

//通过类对象生成string
#define StringWithClass(Class) NSStringFromClass([Class class])

@interface ShoppingCartViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//全选按钮
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
//总金额label
@property (weak, nonatomic) IBOutlet UILabel *sumOfMoneyLabel;
//总数量label
@property (weak, nonatomic) IBOutlet UILabel *sumOfQuantityLabel;

//选中购物车商品总数量
@property (nonatomic, strong) NSDecimalNumber *shoppingCartSumOfQuantity;

//整个购物车商品总价
@property (nonatomic, strong) NSDecimalNumber *shoppingCartSumOfMoney;

//购物车公司产品列表
@property (nonatomic, strong) NSMutableArray *shoppingCartCompanyProductMutArr;

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"购物车";
    
    [self.tableView registerNib:NibWithClass(ShoppingCartCell)  forCellReuseIdentifier:StringWithClass(ShoppingCartCell)];
    [self.tableView registerNib:NibWithClass(ShoppingCartHeaderView) forHeaderFooterViewReuseIdentifier:StringWithClass(ShoppingCartHeaderView)];
    [self.tableView registerNib:NibWithClass(ShoppingCartFooterView) forHeaderFooterViewReuseIdentifier:StringWithClass(ShoppingCartFooterView)];
    self.tableView.rowHeight = 100;
    [self setTableViewSeperaInsetZero];
}

// cell的分割线顶格
- (void)setTableViewSeperaInsetZero{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.shoppingCartCompanyProductMutArr = [ShoppingCartCompanyProduct demoShoppingCartCompanyProductMutArr];
    [self calculateAndUpdateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.shoppingCartCompanyProductMutArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[section];
    return sccp.shoppingCartProductMutArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[section];
    ShoppingCartHeaderView *shoppingCartHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:StringWithClass(ShoppingCartHeaderView)];
    shoppingCartHeaderView.shoppingCartCompanyProduct = sccp;
    
    //这个tag记录分区
    shoppingCartHeaderView.selectButton.tag = section;
    [shoppingCartHeaderView.selectButton addTarget:self action:@selector(selectSectionGoodsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return shoppingCartHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[section];
    ShoppingCartFooterView *shoppingCartFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:StringWithClass(ShoppingCartFooterView)];
    shoppingCartFooterView.shoppingCartCompanyProduct = sccp;
    return shoppingCartFooterView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:StringWithClass(ShoppingCartCell)];
    [cell.selectButton addTarget:self action:@selector(selectOneGoodsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.reduceButton addTarget:self action:@selector(changeQuantityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addButton addTarget:self action:@selector(changeQuantityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[indexPath.section];
    cell.shoppingCartProduct = sccp.shoppingCartProductMutArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//编辑列表
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[indexPath.section];
    ShoppingCartProduct *shoppingCartProduct = sccp.shoppingCartProductMutArr[indexPath.row];
    
    if (sccp.shoppingCartProductMutArr.count == 1) {
        [self.shoppingCartCompanyProductMutArr removeObject:sccp];
    } else {
        [sccp.shoppingCartProductMutArr removeObject:shoppingCartProduct];
    }
    [self calculateAndUpdateUI];
}

//修改左滑删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - Button Actions

//cell中改变数量（加／减）按钮点击
- (void)changeQuantityButtonClicked:(UIButton *)sender {
    ShoppingCartCell *shoppingCartCell = (ShoppingCartCell *)[[[sender superview]superview] superview];
    ShoppingCartProduct *scp = shoppingCartCell.shoppingCartProduct;
    
    //商品数量
    int currentQuantity = scp.quantity.intValue;
    //库存数量
    int stockQuantity = scp.stockQuantity.intValue;
    
    //减号按钮
    if (sender.tag == 0 && currentQuantity == 1) {
        [self alertText:@"商品数量不能低于1"];
        return;
    //加号按钮
    } else if (sender.tag == 1 && currentQuantity >= stockQuantity) {
        [self alertText:@"商品数量不能高于库存数量"];
        return;
    }
    
    //目标商品数量
    NSString *targetGoodsNum = sender.tag == 0 ? [NSString stringWithFormat:@"%d", currentQuantity - 1] : [NSString stringWithFormat:@"%d", currentQuantity + 1];
    
    //增加／减少请求成功时，才会更新数据源与页面显示
    scp.quantity = targetGoodsNum;
    [self calculateAndUpdateUI];
}

//选中列表中所有商品按钮点击
- (IBAction)selectAllGoodsButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    //每个分区的选中按钮
    for (int i = 0; i < self.shoppingCartCompanyProductMutArr.count; i++) {
        ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[i];
        sccp.isSelected = sender.selected;
        //每一行的选中按钮
        for (int j = 0; j < sccp.shoppingCartProductMutArr.count; j++) {
            ShoppingCartProduct *scp = sccp.shoppingCartProductMutArr[j];
            scp.isSelected = sender.selected;
        }
        
    }
    
    //计算选中的商品数和金额（section以及整个列表）
    [self calculateAndUpdateUI];
}

//选中分区内所有商品按钮点击
- (void)selectSectionGoodsButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;

    //sender的tag纪录了section
    ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[sender.tag];
    sccp.isSelected = sender.selected;
    //该分区中每一行的选中按钮
    for (int i = 0; i < sccp.shoppingCartProductMutArr.count; i++) {
        ShoppingCartProduct *scp = sccp.shoppingCartProductMutArr[i];
        scp.isSelected = sender.selected;
    }
    
    //根据每个分区的选中按钮，得出是佛要选中全选按钮
    for (int j = 0; j < self.shoppingCartCompanyProductMutArr.count; j++) {
        ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[j];
        //只要有一个分区未选中，那么购物车全选按钮才选中
        if (sccp.isSelected == NO) {
            self.selectAllButton.selected = NO;
            break;
        }
        //如果每个分区都被选中了，那么购物车全选按钮才被选中
        if (j == self.shoppingCartCompanyProductMutArr.count - 1) {
            self.selectAllButton.selected = YES;
        }
    }
    
    //计算选中的商品数和金额（section以及整个列表）
    [self calculateAndUpdateUI];
}

//选中一件商品按钮点击
- (void)selectOneGoodsButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;

    //该行的选中按钮
    ShoppingCartCell *shoppingCartCell = (ShoppingCartCell *)[[sender superview]superview];
    NSIndexPath *indexPathForCell = [self.tableView indexPathForCell:shoppingCartCell];
    ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[indexPathForCell.section];
    ShoppingCartProduct *currentScp = sccp.shoppingCartProductMutArr[indexPathForCell.row];
    currentScp.isSelected = sender.selected;
    
    //根据该分区中每一行的选中按钮，得出是否要选中该分区
    for (int i = 0; i < sccp.shoppingCartProductMutArr.count; i++) {
        ShoppingCartProduct *scp = sccp.shoppingCartProductMutArr[i];
        if (scp.isSelected == NO) {
            sccp.isSelected = NO;
            break;
        }
        //如果分区中每行都被选中了，那么该分区才被选中
        if (i == sccp.shoppingCartProductMutArr.count - 1) {
            sccp.isSelected = YES;
        }
    }
    
    //根据每个分区的选中按钮，得出是佛要选中全选按钮
    for (int j = 0; j < self.shoppingCartCompanyProductMutArr.count; j++) {
        ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[j];
        if (sccp.isSelected == NO) {
            self.selectAllButton.selected = NO;
            break;
        }
        //如果每个分区都被选中了，那么整个购物车选中按钮才被选中
        if (j == self.shoppingCartCompanyProductMutArr.count - 1) {
            self.selectAllButton.selected = YES;
        }
    }
    
    //计算选中的商品数和金额（section以及整个列表）
    [self calculateAndUpdateUI];
}

//计算选中的商品数和金额（section以及整个列表）
- (void)calculateAndUpdateUI {
    //整个购物车商品数量
    NSDecimalNumber *shoppingCartSumOfQuantity = [NSDecimalNumber decimalNumberWithString:@"0"];
    //整个购物车商品总价
    NSDecimalNumber *shoppingCartSumOfMoney = [NSDecimalNumber decimalNumberWithString:@"0"];

    for (int i = 0; i < self.shoppingCartCompanyProductMutArr.count; i++) {
        ShoppingCartCompanyProduct *sccp = self.shoppingCartCompanyProductMutArr[i];
        
        //分区商品数量
        NSDecimalNumber *sectionSumOfQuantity = [NSDecimalNumber decimalNumberWithString:@"0"];
        //分区商品总价
        NSDecimalNumber *sectionSumOfMoney = [NSDecimalNumber decimalNumberWithString:@"0"];
        for (int j = 0; j < sccp.shoppingCartProductMutArr.count; j++) {
            ShoppingCartProduct *scp = sccp.shoppingCartProductMutArr[j];
            //商品必须要选中
            if (scp.isSelected) {
                //单个商品数量
                NSDecimalNumber *goodsQuantity = [NSDecimalNumber decimalNumberWithString:scp.quantity];
                //单个商品总价
                NSDecimalNumber *goodsMoney = [[NSDecimalNumber decimalNumberWithString:scp.salesPrice] decimalNumberByMultiplyingBy:goodsQuantity];

                sectionSumOfQuantity = [sectionSumOfQuantity decimalNumberByAdding:goodsQuantity];
                sectionSumOfMoney = [sectionSumOfMoney decimalNumberByAdding:goodsMoney];
            }
        }
        sccp.selectedGoodsQuantity = [NSString stringWithFormat:@"%@",sectionSumOfQuantity];
        sccp.selectedGoodsMoney = [NSString stringWithFormat:@"%@",sectionSumOfMoney];
        
        shoppingCartSumOfQuantity = [shoppingCartSumOfQuantity decimalNumberByAdding:sectionSumOfQuantity];
        shoppingCartSumOfMoney = [shoppingCartSumOfMoney decimalNumberByAdding:sectionSumOfMoney];
    }
    
    //刷新底部
    self.sumOfQuantityLabel.text = [NSString stringWithFormat:@"共选择%@件商品",shoppingCartSumOfQuantity];
    self.sumOfMoneyLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCartSumOfMoney];
    
    self.shoppingCartSumOfQuantity = shoppingCartSumOfQuantity;
    self.shoppingCartSumOfMoney = shoppingCartSumOfMoney;
    
    //刷新列表
    [self.tableView reloadData];
}

//去结算按钮点击
- (IBAction)confirmOrderButtonClicked:(UIButton *)sender {
    if ([self.shoppingCartSumOfQuantity isEqualToNumber:@(0)]) {
        [self alertText:@"您尚未选择购买的商品"];
        return;
    }
    
    NSLog(@"结算...");
}

#pragma mark - Accessory functions

- (void)alertText:(NSString *)text {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
