//
//  ShoppingCartHeaderView.m
//  
//
//  Created by 李洋 on 16/8/11.
//
//

#import "ShoppingCartHeaderView.h"

@interface ShoppingCartHeaderView ()

//公司名称label
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;

@end

@implementation ShoppingCartHeaderView

- (void)setShoppingCartCompanyProduct:(ShoppingCartCompanyProduct *)shoppingCartCompanyProduct {
    _shoppingCartCompanyProduct = shoppingCartCompanyProduct;
    
    self.selectButton.selected = shoppingCartCompanyProduct.isSelected;
    self.companyNameLabel.text = shoppingCartCompanyProduct.name;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
