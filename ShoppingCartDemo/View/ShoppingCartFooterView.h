//
//  ShoppingCartFooterView.h
//  
//
//  Created by 李洋 on 16/8/11.
//
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"

//购物车分区头视图
@interface ShoppingCartFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) ShoppingCartCompanyProduct *shoppingCartCompanyProduct;

@end
