//
//  Bridge.h
//  Spotnotify
//
//  Created by Chris Cho on 4/13/16.
//  Copyright © 2016 Chris Cho. All rights reserved.
//

#ifndef Bridge_h
#define Bridge_h

#import <Foundation/Foundation.h>
@interface NSUserNotification (INDPrivate)

+ (void)_closestDatesForStartDate:(id)arg1 earliestDate:(id)arg2 timeZone:(id)arg3 deliveryRepeatInterval:(id)arg4 returnDateBefore:(id *)arg5 returnDateAfter:(id *)arg6;
+ (id)allocWithZone:(struct _NSZone *)arg1;
+ (id)alloc;
@property(readonly, nonatomic) NSData *_identityImageData;
- (void)_setIdentityImage:(id)arg1 withIdentifier:(id)arg2;
@property(readonly, nonatomic) BOOL _hasContentImage;
@property(copy) NSImage *contentImage; // @dynamic contentImage;
- (BOOL)_areIdentifiersEqual:(id)arg1;
- (void)_setActivationType:(long long)arg1;
- (void)_setSnoozedDate:(double)arg1;
- (void)_setSnoozeInterval:(double)arg1;
- (void)_setSnoozed:(BOOL)arg1;
- (void)_setRemote:(BOOL)arg1;
@property(readonly) NSDate *_nextFireDate;
- (void)_setPresented:(BOOL)arg1;
- (void)_setActualDeliveryDate:(id)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)init;

// Remaining properties
@property BOOL _actionButtonIsSnooze; // @dynamic _actionButtonIsSnooze;
@property(getter=_isAllDayEvent) BOOL _allDayEvent; // @dynamic _allDayEvent;
@property(copy) NSArray *_alternateActionButtonTitles; // @dynamic _alternateActionButtonTitles;
@property(readonly) unsigned long long _alternateActionIndex; // @dynamic _alternateActionIndex;
@property BOOL _alwaysShowAlternateActionMenu; // @dynamic _alwaysShowAlternateActionMenu;
@property unsigned long long _badgeCount; // @dynamic _badgeCount;
@property BOOL _clearable; // @dynamic _clearable;
@property(copy) NSString *_dateString; // @dynamic _dateString;
@property(copy) NSDateComponents *_deliveryExpiration; // @dynamic _deliveryExpiration;
@property BOOL _dismissAfterDuration; // @dynamic _dismissAfterDuration;
@property unsigned long long _displayStyle; // @dynamic _displayStyle;
@property(copy) NSDate *_eventDate; // @dynamic _eventDate;
@property(copy) NSImage *_identityImage; // @dynamic _identityImage;
@property BOOL _identityImageHasBorder; // @dynamic _identityImageHasBorder;
@property BOOL _ignoresDoNotDisturb; // @dynamic _ignoresDoNotDisturb;
@property(copy) NSURL *_imageURL; // @dynamic _imageURL;
@property BOOL _lockscreenOnly; // @dynamic _lockscreenOnly;
@property BOOL _persistent; // @dynamic _persistent;
@property BOOL _poofsOnCancel; // @dynamic _poofsOnCancel;
@property(readonly, getter=_isRemote) BOOL _remote; // @dynamic _remote;
@property BOOL _showsButtons; // @dynamic _showsButtons;
@property(readonly) double _snoozeInterval; // @dynamic _snoozeInterval;
@property(readonly) BOOL _snoozed; // @dynamic _snoozed;
@property(readonly) double _snoozedDate; // @dynamic _snoozedDate;
@property(retain) id _storageID; // @dynamic _storageID;
@property unsigned long long _style; // @dynamic _style;
@property BOOL _substitutesEmojiInResponse; // @dynamic _substitutesEmojiInResponse;
@property(copy) NSString *actionButtonTitle; // @dynamic actionButtonTitle;
@property(readonly) long long activationType; // @dynamic activationType;
@property(readonly) NSDate *actualDeliveryDate; // @dynamic actualDeliveryDate;
@property(copy) NSDate *deliveryDate; // @dynamic deliveryDate;
@property(copy) NSDateComponents *deliveryRepeatInterval; // @dynamic deliveryRepeatInterval;
@property(copy) NSTimeZone *deliveryTimeZone; // @dynamic deliveryTimeZone;
@property(copy) NSDateComponents *duration; // @dynamic duration;
@property BOOL hasActionButton; // @dynamic hasActionButton;
@property BOOL hasReplyButton; // @dynamic hasReplyButton;
@property(copy) NSString *identifier; // @dynamic identifier;
@property(copy) NSString *informativeText; // @dynamic informativeText;
@property(copy) NSString *otherButtonTitle; // @dynamic otherButtonTitle;
@property(readonly, getter=isPresented) BOOL presented; // @dynamic presented;
@property(readonly, getter=isRemote) BOOL remote; // @dynamic remote;
@property(readonly) NSAttributedString *response; // @dynamic response;
@property(copy) NSString *responsePlaceholder; // @dynamic responsePlaceholder;
@property(copy) NSString *soundName; // @dynamic soundName;
@property(copy) NSString *subtitle; // @dynamic subtitle;
@property(copy) NSString *title; // @dynamic title;
@property(copy) NSDictionary *userInfo; // @dynamic userInfo;

@end

#endif /* Bridge_h */
