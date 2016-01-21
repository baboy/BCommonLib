//
//  UITabBarController+x.m
//  Pods
//
//  Created by baboy on 1/21/16.
//
//

#import "UITabBarController+x.h"
#import "Utils.h"

@implementation UITabBarController(x)
- (NSArray *) loadViewControllersFromFile:(NSString *)plist{
    NSArray *menus = [NSArray arrayWithContentsOfFile:getBundleFile(plist)];
    NSMutableArray *vcs = [NSMutableArray array];
    for (NSInteger i=0, n = menus.count; i < n; i++) {
        NSDictionary *item = [menus objectAtIndex:i];
        BOOL enable = [[item objectForKey:@"enable"] boolValue];
        if(!enable)
            continue;
        NSString *name = NSLocalizedString([item valueForKey:@"name"], nil);
        NSString *title = [item valueForKey:@"title"];
        title = title? NSLocalizedString(title, nil) : name;
        
        NSString *icon = [item valueForKey:@"icon"];
        NSString *iconSelected = [item valueForKey:@"icon_selected"];
        if (!iconSelected)
            iconSelected = icon;
        Class c = NSClassFromString([item valueForKey:@"controller"]);
        if(!c)
            continue;
        UIViewController *vc = [[c alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem.image = [[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:iconSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
        if (title && title.length) {
            [vc setTitle:title];
        }
        [vcs addObject:nav];
    }
    return vcs;
}
@end
