//
//  CLPerson.m
//  Cardman
//
//  Created by Jason Lee on 16/1/25.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import "CLPerson.h"
#import "CLCardman.h"

@implementation CLPerson

+ (CLPerson *)personFromABRecordRef:(ABRecordRef)abRecordRef {
    CLPerson *clPerson = [CLPerson new];
    
    clPerson.recordId = @(ABRecordGetRecordID(abRecordRef));
    
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(abRecordRef, kABPersonImageFormatThumbnail);
    if (data) clPerson.avatar = [UIImage imageWithData:data scale:UIScreen.mainScreen.scale];
    
    [CLPerson extractNameFromABRecordRef:abRecordRef intoCLPerson:clPerson];
    
    [CLPerson extractPhonesFromABRecordRef:abRecordRef intoCLPerson:clPerson];
    
    return clPerson;
}

#pragma mark - getter for lazy load

- (NSArray <CLAddress *> *)addresses {
    if (!_addresses) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractAddressesFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _addresses;
}

- (NSArray <CLEmail *> *)emails {
    if (!_emails) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractEmailsFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _emails;
}

- (NSArray <NSString *> *)websites {
    if (!_websites) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractWebsitesFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _websites;
}

- (NSDate *)birthday {
    if (!_birthday) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        _birthday = [CLPerson readDateProperty:kABPersonBirthdayProperty fromABRecordRef:abRecrodRef];
    }
    return _birthday;
}

- (NSString *)note {
    if (!_note) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        _note = [CLPerson readStringProperty:kABPersonNoteProperty fromABRecordRef:abRecrodRef];
    }
    return _note;
}

- (CLJob *)job {
    if (!_job) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        _job = [CLJob new];
        _job.organization = [CLPerson readStringProperty:kABPersonOrganizationProperty fromABRecordRef:abRecrodRef];
        _job.jobTitle = [CLPerson readStringProperty:kABPersonJobTitleProperty fromABRecordRef:abRecrodRef];
    }
    return _job;
}

#pragma mark - extract properties

+ (void)extractNameFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    clPerson.name = [CLName new];
    
    clPerson.name.firstName = [CLPerson readStringProperty:kABPersonFirstNameProperty fromABRecordRef:abRecordRef];
    clPerson.name.lastName = [CLPerson readStringProperty:kABPersonLastNameProperty fromABRecordRef:abRecordRef];
    clPerson.name.middleName = [CLPerson readStringProperty:kABPersonMiddleNameProperty fromABRecordRef:abRecordRef];
    
    CFStringRef compositeNameRef = ABRecordCopyCompositeName(abRecordRef);
    clPerson.name.compositeName =  (__bridge_transfer NSString *)compositeNameRef;
}

+ (void)extractPhonesFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <CLPhone *> *phones = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonPhoneProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            CLPhone *clPhone = [CLPhone new];
            
            clPhone.number = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
            clPhone.originalLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, i);
            clPhone.localizedLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(clPhone.originalLabel));
            
            [phones addObject:clPhone];
        }
        CFRelease(multiValue);
    }
    
    clPerson.phones = phones.count > 0 ? phones : nil;
}

+ (void)extractAddressesFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <CLAddress *> *addresses = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonPhoneProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            CLAddress *clAddress = [CLAddress new];
            
            clAddress.originalLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, i);
            clAddress.localizedLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(clAddress.originalLabel));
            
            NSDictionary *dict = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(multiValue, i));
            clAddress.street = dict[(__bridge NSString *)kABPersonAddressStreetKey];
            clAddress.city = dict[(__bridge NSString *)kABPersonAddressCityKey];
            clAddress.state = dict[(__bridge NSString *)kABPersonAddressStateKey];
            clAddress.zip = dict[(__bridge NSString *)kABPersonAddressZIPKey];
            clAddress.country = dict[(__bridge NSString *)kABPersonAddressCountryKey];
            clAddress.countryCode = dict[(__bridge NSString *)kABPersonAddressCountryCodeKey];
            
            [addresses addObject:clAddress];
        }
        CFRelease(multiValue);
    }
    
    clPerson.addresses = addresses.count > 0 ? addresses : nil;
}

+ (void)extractEmailsFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <CLEmail *> *emails = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonEmailProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            CLEmail *clEmail = [CLEmail new];
            
            clEmail.address = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
            clEmail.originalLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, i);
            clEmail.localizedLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(clEmail.originalLabel));
            
            [emails addObject:clEmail];
        }
        CFRelease(multiValue);
    }
    
    clPerson.emails = emails.count > 0 ? emails : nil;
}

+ (void)extractWebsitesFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <NSString *> *websites = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonPhoneProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            NSString *website = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
            [websites addObject:website];
        }
        CFRelease(multiValue);
    }
    
    clPerson.websites = websites.count > 0 ? websites : nil;
}

#pragma mark -

+ (NSString *)readStringProperty:(ABPropertyID)propertyId fromABRecordRef:(ABRecordRef)abRecordRef {
    CFTypeRef valueRef = (ABRecordCopyValue(abRecordRef, propertyId));
    return (__bridge_transfer NSString *)valueRef;
}

+ (NSDate *)readDateProperty:(ABPropertyID)propertyId fromABRecordRef:(ABRecordRef)abRecordRef {
    CFDateRef dateRef = ABRecordCopyValue(abRecordRef, propertyId);
    return (__bridge_transfer NSDate *)dateRef;
}

@end
