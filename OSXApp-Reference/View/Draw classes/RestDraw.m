//
//  RestDraw.m
//  Señor Staff
//
//  Created by Konstantine Prevas on 7/26/06.
//  Copyright 2006 Konstantine Prevas. All rights reserved.
//

#import "RestDraw.h"
#import "NoteController.h"
#import "StaffController.h"
#import "MeasureController.h"
#import "NoteBase.h"

@implementation RestDraw

+(void)draw:(NoteBase *)rest inMeasure:(Measure *)measure atIndex:(float)index target:(id)target selection:(id)selection{
	BOOL highlighted = ((target == rest) || [[rest getControllerClass] isSelected:rest inSelection:selection]);
	float x = [NoteController xOf:rest];
	float lineHeight = [StaffController lineHeightOf:[measure getStaff]];
	NSRect measureBounds = [MeasureController innerBoundsOf:measure];
	float middle = measureBounds.origin.y + measureBounds.size.height / 2.0;
	NSRect rect;
	NSImage *img = nil;
	switch([rest getDuration]){
		case 1:
			if(highlighted) [[NSColor redColor] set];
			rect.origin.x = x;
			rect.origin.y = middle - lineHeight * 2;
			rect.size.height = lineHeight;
			rect.size.width = 15;
			[NSBezierPath fillRect:rect];
			break;
		case 2:
			if(highlighted) [[NSColor redColor] set];
			rect.origin.x = x;
			rect.origin.y = middle - lineHeight;
			rect.size.height = lineHeight;
			rect.size.width = 15;
			[NSBezierPath fillRect:rect];
			break;
		case 4:
			if(highlighted){
				img = [NSImage imageNamed:@"qrest-over.png"];
			} else{
				img = [NSImage imageNamed:@"qrest.png"];
			}
			[img drawFlippedAtPoint:NSMakePoint(x, middle - [img size].height / 2)];
			break;
		case 8:
			if(highlighted){
				img = [NSImage imageNamed:@"erest-over.png"];
			} else{
				img = [NSImage imageNamed:@"erest.png"];
			}
			[img drawFlippedAtPoint:NSMakePoint(x, middle - [img size].height / 2)];
			break;
		case 16:
			if(highlighted){
				img = [NSImage imageNamed:@"srest-over.png"];
			} else{
				img = [NSImage imageNamed:@"srest.png"];
			}
			[img drawFlippedAtPoint:NSMakePoint(x, middle - [img size].height / 2)];
			break;
		case 32:
			if(highlighted){
				img = [NSImage imageNamed:@"trest-over.png"];
			} else{
				img = [NSImage imageNamed:@"trest.png"];
			}
			[img drawFlippedAtPoint:NSMakePoint(x, middle - [img size].height / 2)];
			break;
	}
	if([rest getDotted]){
		NSRect dotRect;
		dotRect.origin.x = x + (img != nil ? [img size].width : 17);
		dotRect.origin.y = (img != nil ? middle + 10 : middle);
		dotRect.size.width = dotRect.size.height = 4;
		[[NSBezierPath bezierPathWithOvalInRect:dotRect] fill]; 
	}
	if([rest isTriplet]){
		if(![rest isPartOfFullTriplet]){
			
		} else{
			[NoteDraw drawTriplet:rest];
		}
	}
}

+ (float) topOf:(NoteBase *)note inMeasure:(Measure *)measure{
	NSRect measureBounds = [MeasureController innerBoundsOf:measure];
	float middle = measureBounds.origin.y + measureBounds.size.height / 2.0;
	float lineHeight = [StaffController lineHeightOf:[measure getStaff]];
	return middle - lineHeight * 4;
}

@end
