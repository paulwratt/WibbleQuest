//
//  CommandInterpreter.m
//  MyBoots
//
//  Created by orta therox on 10/07/2011.
//  Copyright 2011 http://ortatherox.com. All rights reserved.
//

#import "CommandInterpreter.h"
#import "PlayerInventory.h"

//private methods
@interface CommandInterpreter()
-(void) getCommand:(NSArray *) params;
-(void) help;
-(void) north;
-(void) west;
-(void) east;
-(void) south;
@end


@implementation CommandInterpreter
@synthesize wq;

-(void)parse:(NSString*) string {
  string = [string lowercaseString];
  NSArray * parameters = [string componentsSeparatedByString:@" "];
  if ([parameters count] > 0) {
    NSString * command = [parameters objectAtIndex:0];
    
    if([@"help" isEqualToString:command]){
      [self help];
      return;
    }
    
    // support 'go north'
    if ([@"go" isEqualToString:command]) {
        command = [parameters objectAtIndex:1];
        
      // support 'go to north'
        if ([@"to" isEqualToString:command]) {
          command = [parameters objectAtIndex:2]; 
        }
      }
    
    
    if([@"north" isEqualToString:command] || [@"n" isEqualToString:command]){
      [self north];
      return;
    }
    
    if([@"west" isEqualToString:command] || [@"w" isEqualToString:command]){
      [self west];
      return;
    }
    
    if([@"east" isEqualToString:command] || [@"e" isEqualToString:command]){
      [self east];
      return;
    }

    if([@"south" isEqualToString:command] || [@"s" isEqualToString:command]){
      [self south];
      return;
    }
    
    if([@"look" isEqualToString:command] || [@"l" isEqualToString:command]){
      [wq describeSurroundings];
      return;
    }
    
    if([@"inventory" isEqualToString:command] || [@"i" isEqualToString:command]){
      [wq.inventory describeInventory];
      return;
    }
    
    if([wq.inventory respondToCommand:parameters]) {
      return;
    }
    
    if([wq.inventory hasItem:command]){
      Item * item = [wq.inventory getItem:command];
      [wq print: item.description];
    }

    if([wq.currentRoom hasItem:command]){
      Item * item = [wq.currentRoom getItem:command];
      [wq print: item.description];
    }
    
    if([@"get" isEqualToString:command] || [@"g" isEqualToString:command]){
      [self getCommand:parameters];
      return;
    }
    
    [wq print:@"Command not recognised"];
  }
}

-(void)north {
  if (wq.currentRoom.north) {
    wq.currentRoom = wq.currentRoom.north;
    [wq describeSurroundings];
    return;
  }else{
    [wq print:@"There is nothing to the north."];
  }
}

-(void)west {
  if (wq.currentRoom.west) {
    wq.currentRoom = wq.currentRoom.west;
    [wq describeSurroundings];
  }else{
    [wq print:@"There is nothing to the west."];
  }
}

-(void)east {
  if (wq.currentRoom.east) {
    wq.currentRoom = wq.currentRoom.east;
    [wq describeSurroundings];
  }else{
    [wq print:@"There is nothing to the east."];
  }

}

-(void)south {
  if (wq.currentRoom.south) {
    wq.currentRoom = wq.currentRoom.south;
    [wq describeSurroundings];
  }else{
    [wq print:@"There is nothing to the south."];
  }
}

-(void)help {
  if([wq.game respondsToSelector:@selector(help)]){
    [wq.game help];
    
  }else{
    [wq title:@"Help File"];
    [wq command:@"most commands work with typing the first letter."];
    [wq command:@""];
    
    [wq print:@"north, east, south, west"];
    [wq command:@"move in a direction"];
    
    [wq print:@"get [item]"];
    [wq command:@"get an item form the current room"];
    
    [wq print: @"examine [item]"];
    [wq command:@"examine an item either in the room, or in your inventory"];

    [wq print: @"inventory"];
    [wq command:@"examine an item either in the room, or in your inventory"];

    [wq print: @"use [item]"];
    [wq command:@"A generic use term for items in room, or in your inventory"];

    
  }
}

-(void)getCommand:(NSArray *) params {
  if( [params count] == 1){
    [wq print:@"Get what?"];
  }else{
    NSString *objectID = [params objectAtIndex:1];
    if([@"all" isEqualToString:objectID]){
      [wq command:@"all is not yet implemented."];
      return;
    }
    
    if([wq.currentRoom hasItem:objectID]){
      Item* item = [wq.currentRoom takeItem:objectID];
      [wq.inventory addItem:item];
      [item onPickup];
      
    }else{
      [wq print:@"Could not find a %@ in the room" , objectID];
    }
  }  
}

@end