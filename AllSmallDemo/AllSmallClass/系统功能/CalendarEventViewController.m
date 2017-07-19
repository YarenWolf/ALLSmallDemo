//
//  CalendarEventViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/7/19.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "CalendarEventViewController.h"

@import EventKit;
@import EventKitUI;
@interface CalendarEventViewController () <EKEventEditViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

// Used to add events to Calendar
@property (strong, nonatomic) UIBarButtonItem *addButton;
@end


@implementation CalendarEventViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, APPW, APPH-TopHeight) style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    // Initialize the event store
    self.eventStore = [[EKEventStore alloc] init];
    // Initialize the events list
    self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];
    _addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = _addButton;
    // The Add button is initially disabled
    self.addButton.enabled = NO;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Check whether we are authorized to access Calendar
    [self checkEventStoreAccessForCalendar];
}



#pragma mark -
#pragma mark Table View
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Configure the destination event view controller
    EKEventViewController* eventViewController = [[EKEventViewController alloc]init];
    // Set the view controller to display the selected event
    eventViewController.event = self.eventsList[indexPath.row];
    
    // Allow event editing
    eventViewController.allowsEditing = YES;
    [self.navigationController pushViewController:eventViewController animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCell"];
    }
    
    // Get the event at the row selected and display its title
    cell.textLabel.text = [(self.eventsList)[indexPath.row] title];
    return cell;
}


#pragma mark -
#pragma mark Access Calendar

// Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             CalendarEventViewController * __weak weakSelf = self;
             // Let's ensure that our code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
                 // The user has granted access to their Calendar; let's populate our UI with all events occuring in the next 24 hours.
                 [weakSelf accessGrantedForCalendar];
             });
         }
     }];
}


// This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
    // Let's get the default calendar associated with our event store
    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
    // Enable the Add button
    self.addButton.enabled = YES;
    // Fetch all events happening in the next 24 hours and put them into eventsList
    self.eventsList = [self fetchEvents];
    // Update the UI with the above events
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Fetch events

// Fetch all events happening in the next 24 hours
- (NSMutableArray *)fetchEvents
{
    NSDate *startDate = [NSDate date];
    
    //Create the end date components
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 1;
    
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
    // We will only search the default calendar for our events
    NSArray *calendarArray = @[self.defaultCalendar];
    
    // Create the predicate
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:calendarArray];
    
    // Fetch all events that match the predicate
    NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    
    return events;
}


#pragma mark -
#pragma mark Add a new event

// Display an event edit view controller when the user taps the "+" button.
// A new event is added to Calendar when the user taps the "Done" button in the above view controller.
- (IBAction)addEvent:(id)sender
{
    // Create an instance of EKEventEditViewController
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
    
    // Set addController's event store to the current event store
    addController.eventStore = self.eventStore;
    addController.editViewDelegate = self;
    [self presentViewController:addController animated:YES completion:nil];
}


#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action{
    CalendarEventViewController * __weak weakSelf = self;
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (action != EKEventEditViewActionCanceled)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 // Re-fetch all events happening in the next 24 hours
                 weakSelf.eventsList = [self fetchEvents];
                 // Update the UI with the above events
                 [weakSelf.tableView reloadData];
             });
         }
     }];
}
// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller{
    return self.defaultCalendar;
}

@end
