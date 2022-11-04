/*
 * Copyright (c) 2010-2011 SURFnet bv
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of SURFnet bv nor the names of its contributors 
 *    may be used to endorse or promote products derived from this 
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IdentityListViewController.h"
#import "ScanViewController.h"
#import "TiqrCoreManager.h"
#import "Identity.h"
#import "IdentityProvider.h"
#import "IdentityTableViewCell.h"
#import "IdentityEditViewController.h"
#import "ServiceContainer.h"
#import "TiqrConfig.h"
@import TiqrCore;

@interface IdentityListViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) BOOL processingMoveRow;
@property (nonatomic, strong) Identity *selectedIdentity;

@end

@implementation IdentityListViewController

- (instancetype)init {
    self = [super initWithNibName:@"IdentityListView" bundle:SWIFTPM_MODULE_BUNDLE];
    if (self != nil) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationAppearance];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (ServiceContainer.sharedInstance.identityService.identityCount == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)done {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:(BOOL)editing animated:(BOOL)animated];
    self.navigationItem.leftBarButtonItem.enabled = !editing;
}

- (void)configureCell:(IdentityTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Identity *identity = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[cell setIdentity:identity];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [Localization localize:@"identity_title" comment:@"Identity select back button title"];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [ThemeService shared].theme.bodyFont;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    IdentityTableViewCell *cell = (IdentityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[IdentityTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Identity *identity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    IdentityEditViewController *viewController = [[IdentityEditViewController alloc] initWithIdentity:identity];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.selectedIdentity = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSString *title = [Localization localize:@"confirm_delete_title" comment:@"Sure?"];
        NSString *message = [Localization localize:@"confirm_delete" comment:@"Are you sure you want to delete this identity?"];
        NSString *yesTitle = [Localization localize:@"yes_button" comment:@"Yes button title"];
        NSString *noTitle = [Localization localize:@"no_button" comment:@"No button title"];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesButton = [UIAlertAction actionWithTitle:yesTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [self performDeleteIdentity:self.selectedIdentity];
        }];
        
        UIAlertAction *noButton = [UIAlertAction actionWithTitle:noTitle style:UIAlertActionStyleCancel handler:nil];

        [alertController addAction:yesButton];
        [alertController addAction:noButton];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)performDeleteIdentity:(Identity *)identity {
    IdentityService *identityService = ServiceContainer.sharedInstance.identityService;
    IdentityProvider *identityProvider = identity.identityProvider;
    
    NSString *identityIdentifier = identity.identifier;
    NSString *providerIdentifier = identityProvider.identifier;
    
    if (identityProvider != nil) {
        
        [identityProvider removeIdentitiesObject:identity];
        [identityService deleteIdentity:identity];
        if ([identityProvider.identities count] == 0) {
            [identityService deleteIdentityProvider:identityProvider];
        }
    } else {
        [identityService deleteIdentity:identity];
    }
    
    if ([identityService saveIdentities]) {
        [ServiceContainer.sharedInstance.secretService deleteSecretForIdentityIdentifier:identityIdentifier
                                                                      providerIdentifier:providerIdentifier];
        
        if (ServiceContainer.sharedInstance.identityService.identityCount == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        NSString *title = [Localization localize:@"error" comment:@"Alert title for error"];
        NSString *message = [NSString stringWithFormat:[Localization localize:@"error_auth_unknown_error" comment:@"Unknown error message"], TiqrConfig.appName];
        NSString *okTitle = [Localization localize:@"ok_button" comment:@"OK button title"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:okTitle otherButtonTitles:nil];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction: okButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	self.processingMoveRow = YES;
	
	NSMutableArray *fetchedObjects = [NSMutableArray arrayWithArray:[self.fetchedResultsController fetchedObjects]];  	
	id movedObject = fetchedObjects[fromIndexPath.row];
	[fetchedObjects removeObjectAtIndex:fromIndexPath.row];
	[fetchedObjects insertObject:movedObject atIndex:toIndexPath.row];
	
	NSInteger sortIndex = 0;
	for (Identity *identity in fetchedObjects) {
		identity.sortIndex = [NSNumber numberWithInteger:sortIndex];
		sortIndex++;
	}

    if (![ServiceContainer.sharedInstance.identityService saveIdentities]) {
        NSString *title = [Localization localize:@"error" comment:@"Alert title for error"];
        NSString *message = [NSString stringWithFormat:[Localization localize:@"error_auth_unknown_error" comment:@"Unknown error message"], TiqrConfig.appName];
        NSString *okTitle = [Localization localize:@"ok_button" comment:@"OK button title"];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction: okButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }

	self.processingMoveRow = NO;	
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    IdentityService *identityService = ServiceContainer.sharedInstance.identityService;
    self.fetchedResultsController = [identityService createFetchedResultsControllerForIdentities];
    self.fetchedResultsController.delegate = self;
    
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unexpected error: %@", error);
        NSString *title = [Localization localize:@"error" comment:@"Alert title for error"];
        NSString *message = [NSString stringWithFormat:[Localization localize:@"error_auth_unknown_error" comment:@"Unknown error message"], TiqrConfig.appName];
        NSString *okTitle = [Localization localize:@"ok_button" comment:@"OK button title"];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction: okButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    return _fetchedResultsController;
}    

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	if (self.processingMoveRow) {
		return;
	}
	
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
	if (self.processingMoveRow) {
		return;
	}
	
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(IdentityTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			[tableView reloadData];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	if (self.processingMoveRow) {
		return;
	}
	
    [self.tableView endUpdates];
}


@end
