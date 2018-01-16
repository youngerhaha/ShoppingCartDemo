//
//  ShoppingCartHeaderView.h
//  
//
//  Created by 李洋 on 16/8/11.
//
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"

//购物车分区头视图
@interface ShoppingCartHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) ShoppingCartCompanyProduct *shoppingCartCompanyProduct;

//选择按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end
