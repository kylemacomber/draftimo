//
//  KTTabViewController.h
//  KTUIKit
//
//  Created by Cathy on 18/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTMacros.h"
#import "KTViewController.h"

@class KTTabViewController;
@class KTTabItem;
@protocol KTTabViewControllerDelegate <NSObject>
@optional
- (void)tabViewController:(KTTabViewController *)theTabViewController willSelectTabItem:(KTTabItem *)theTabItem;
- (void)tabViewController:(KTTabViewController *)theTabViewController didSelectTabItem:(KTTabItem *)theTabItem;

- (void)tabViewController:(KTTabViewController *)theTabViewController willRemoveTabItem:(KTTabItem *)theTabItem;
- (void)tabViewController:(KTTabViewController *)theTabViewController didRemoveTabItem:(KTTabItem *)theTabItem;

// TODO: Neither of these are called yet. To implement these properly, we need to enusure there's also a single order of callbacks for will/DidSelect:. At the moment -addTabItem: will always result in selection. Depending whether you call -addTabItem: or -addTabItem:select: the -didAdd and -will/DidSelect: callbacks will be recieved in a different order.
//- (void)tabViewController:(KTTabViewController *)theTabViewController willAddTabItem:(KTTabItem *)theTabItem;
//- (void)tabViewController:(KTTabViewController *)theTabViewController didAddTabItem:(KTTabItem *)theTabItem;

@end

@class KTView;
@class KTTabItem;

@interface KTTabViewController : KTViewController <NSFastEnumeration> {
	@private
	NSArrayController					*mTabItemArrayController;
	KTTabItem							*wCurrentSelectedTab;
	BOOL								mReleaseViewControllersWhenNotSeletcted;
	BOOL								mShouldResizeTabViews;
	id <KTTabViewControllerDelegate>	wDelegate;
}

@property (nonatomic, readonly) NSArrayController * tabItemArrayController;
@property (nonatomic, readwrite, assign) BOOL releaseViewControllersWhenNotSeletcted;
@property (nonatomic, readwrite, assign) BOOL shouldResizeTabViews;
@property (nonatomic, readwrite, assign) id <KTTabViewControllerDelegate> delegate;


// adding/removing/getting tabs
- (void)addTabItem:(KTTabItem*)theTabItem;
- (void)addTabItem:(KTTabItem *)theTabItem select:(BOOL)theBool;
- (void)removeTabItem:(KTTabItem*)theTabItem;
- (void)insertTabItem:(KTTabItem*)theTabItem atIndex:(NSInteger)theIndex;
- (NSArray*)tabItems;
- (KTTabItem*)tabItemForIdentifier:(id)theIdentifier;
- (KTTabItem*)tabItemForViewController:(KTViewController*)theViewController;
- (KTTabItem*)tabItemForIndex:(NSInteger)theIndex;

// selection
- (KTTabItem*)selectedTabItem;
- (NSInteger)selectedTabIndex;
- (void)selectTabAtIndex:(NSInteger)theTabIndex;
- (void)selectTabItem:(KTTabItem*)theTabItem;
- (BOOL)canSelectNextTabItem;
- (BOOL)canSelectPreviousTabItem;
- (void)selectNextTabItem;
- (void)selectPreviousTabItem;
@end