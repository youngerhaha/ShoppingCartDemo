//
//  ShoppingCartModel.h
//  
//
//  Created by 李洋 on 16/8/17.
//
//

#import <Foundation/Foundation.h>

//购物车中单个产品--对应单元格
@interface ShoppingCartProduct : NSObject

//是否被选中 -- 默认为NO
@property (nonatomic) BOOL isSelected;
//公司名称
@property (nonatomic, copy) NSString *companyName;
//商品名称
@property (nonatomic, copy) NSString *goodsName;
//商品图片
@property (nonatomic, copy) NSString *imageUrl;
//商品数量
@property (nonatomic, copy) NSString *quantity;
//商品单价
@property (nonatomic, copy) NSString *salesPrice;
//商品库存
@property (nonatomic, copy) NSString *stockQuantity;

@end

//购物车中公司产品列表--对应section
@interface ShoppingCartCompanyProduct : NSObject

//是否被选中 -- 默认为NO
@property (nonatomic) BOOL isSelected;

//选中的商品数量
@property (nonatomic, copy) NSString *selectedGoodsQuantity;
//选中商品金额
@property (nonatomic, copy) NSString *selectedGoodsMoney;

//公司名称
@property (nonatomic, copy) NSString *name;
//购买该公司的产品列表
@property (nonatomic, strong) NSMutableArray *shoppingCartProductMutArr;

// 购物车中公司产品列表的模拟数组
+ (NSMutableArray *)demoShoppingCartCompanyProductMutArr;

@end
