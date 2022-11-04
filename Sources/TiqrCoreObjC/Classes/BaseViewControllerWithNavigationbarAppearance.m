//
//  BaseViewControllerWithNavigationbarAppearance.m
//  
//
//  Created by Jairo Bambang Oetomo on 04/11/2022.
//

#import "BaseViewControllerWithNavigationbarAppearance.h"
@import TiqrCore;

@interface BaseViewControllerWithNavigationbarAppearance ()

@end

@implementation BaseViewControllerWithNavigationbarAppearance

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationAppearance];
}

- (void)setupNavigationAppearance {
    UIColor *primaryColor = [ThemeService shared].theme.primaryColor;
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *navigationBarAppearance = [UINavigationBarAppearance new];
        [navigationBarAppearance configureWithOpaqueBackground];
        navigationBarAppearance.backgroundColor = primaryColor;
        self.navigationItem.standardAppearance = navigationBarAppearance;
        self.navigationItem.scrollEdgeAppearance = navigationBarAppearance;

        UIToolbarAppearance *toolbarAppearance = [UIToolbarAppearance new];
        [toolbarAppearance configureWithOpaqueBackground];
        toolbarAppearance.backgroundColor = primaryColor;
        self.navigationController.toolbar.standardAppearance = toolbarAppearance;
        if (@available(iOS 15.0, *)) {
            self.navigationController.toolbar.scrollEdgeAppearance = toolbarAppearance;
        }
    } else {
        self.navigationController.navigationBar.barTintColor = primaryColor;
        self.navigationController.navigationBar.tintColor = [ThemeService shared].theme.buttonTintColor;
        self.navigationController.toolbar.barTintColor = primaryColor;
        self.navigationController.toolbar.tintColor = [ThemeService shared].theme.buttonTintColor;
    }
    
    self.navigationController.navigationBar.tintColor = [ThemeService shared].theme.buttonTintColor;
    self.navigationController.toolbar.tintColor = [ThemeService shared].theme.buttonTintColor;
}


@end
