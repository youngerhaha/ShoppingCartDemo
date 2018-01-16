//
//  ShoppingCartModel.m
//  
//
//  Created by 李洋 on 16/8/17.
//
//

#import "ShoppingCartModel.h"

@implementation ShoppingCartProduct

@end

@implementation ShoppingCartCompanyProduct

// 购物车中公司产品列表的模拟数组
+ (NSMutableArray *)demoShoppingCartCompanyProductMutArr {
    // 第一个ShoppingCartCompanyProduct
    ShoppingCartProduct *scp11 = [[ShoppingCartProduct alloc]init];
    scp11.goodsName = @"酥糖";
    scp11.quantity = @"6";
    scp11.salesPrice = @"0.68";
    scp11.stockQuantity = @"10";
    
    ShoppingCartProduct *scp12 = [[ShoppingCartProduct alloc]init];
    scp12.goodsName = @"酸奶棒棒糖";
    scp12.quantity = @"1";
    scp12.salesPrice = @"1.88";
    scp12.stockQuantity = @"2";
    
    ShoppingCartProduct *scp13 = [[ShoppingCartProduct alloc]init];
    scp13.goodsName = @"青苹果棒棒糖";
    scp13.quantity = @"2";
    scp13.salesPrice = @"1.28";
    scp13.stockQuantity = @"100";
    
    ShoppingCartCompanyProduct *sccp1 = [[ShoppingCartCompanyProduct alloc]init];
    sccp1.name = @"徐福记";
    sccp1.shoppingCartProductMutArr = [NSMutableArray arrayWithObjects:scp11, scp12, scp13, nil];
    
    // 第二个ShoppingCartCompanyProduct
    ShoppingCartProduct *scp21 = [[ShoppingCartProduct alloc]init];
    scp21.goodsName = @"iPhone 7";
    scp21.quantity = @"2";
    scp21.salesPrice = @"4888";
    scp21.stockQuantity = @"30";
    
    ShoppingCartProduct *scp22 = [[ShoppingCartProduct alloc]init];
    scp22.goodsName = @"iPhone X";
    scp22.quantity = @"1";
    scp22.salesPrice = @"8088";
    scp22.stockQuantity = @"20";
    
    ShoppingCartCompanyProduct *sccp2 = [[ShoppingCartCompanyProduct alloc]init];
    sccp2.name = @"苹果";
    sccp2.shoppingCartProductMutArr = [NSMutableArray arrayWithObjects:scp21, scp22, nil];
    
    // 第三个ShoppingCartCompanyProduct
    ShoppingCartProduct *scp31 = [[ShoppingCartProduct alloc]init];
    scp31.goodsName = @"南孚5号电池";
    scp31.quantity = @"4";
    scp31.salesPrice = @"4.88";
    scp31.stockQuantity = @"1000";
    
    ShoppingCartCompanyProduct *sccp3 = [[ShoppingCartCompanyProduct alloc]init];
    sccp3.name = @"南孚";
    sccp3.shoppingCartProductMutArr = [NSMutableArray arrayWithObjects:scp31, nil];
    
    NSMutableArray *sccpMutArr = [NSMutableArray arrayWithObjects:sccp1,sccp2,sccp3, nil];
    return sccpMutArr;
}

@end

