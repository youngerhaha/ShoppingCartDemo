//
//  ShoppingCartFooterView.m
//  
//
//  Created by 李洋 on 16/8/11.
//
//

#import "ShoppingCartFooterView.h"

@interface ShoppingCartFooterView ()

//数量label
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
//总金额label
@property (weak, nonatomic) IBOutlet UILabel *sumOfMoneyLabel;

@end

@implementation ShoppingCartFooterView

- (void)setShoppingCartCompanyProduct:(ShoppingCartCompanyProduct *)shoppingCartCompanyProduct {
    _shoppingCartCompanyProduct = shoppingCartCompanyProduct;
    self.quantityLabel.text = [NSString stringWithFormat:@"已选择%@件商品",shoppingCartCompanyProduct.selectedGoodsQuantity];
    self.sumOfMoneyLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCartCompanyProduct.selectedGoodsMoney];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
