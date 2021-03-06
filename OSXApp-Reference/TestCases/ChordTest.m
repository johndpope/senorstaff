//
//  ChordTest.m
//  Señor Staff
//
//  Created by Konstantine Prevas on 10/1/06.
//  Copyright 2006 Konstantine Prevas. All rights reserved.
//

#import "ChordTest.h"
#import "Chord.h"
#import "Measure.h"
#import "Note.h"
#include "TestUtil.h"

extern int enableMIDI;

@implementation ChordTest

- (void)setUp{
	enableMIDI = 0;
	chord = [[Chord alloc] initWithStaff:nil];
	int i;
	for(i=0; i<3; i++){
		[chord addNote:[[Note alloc] initWithPitch:3 octave:4 duration:2 dotted:YES accidental:NO_ACC onStaff:nil]];
	}
}
- (void)tearDown{
	NSEnumerator *notes = [[chord getNotes] objectEnumerator];
	id note;
	while(note = [notes nextObject]){
		[note release];
	}
	[chord release];
}

- (void) testGetEffectiveDuration{
	STAssertEquals([chord getEffectiveDuration], effDuration(2, YES), @"Wrong duration returned for chord.");
}

- (void) testSetDuration{
	[(NoteBase *)chord setDuration:4];
	STAssertEquals([chord getEffectiveDuration], effDuration(4, YES), @"Setting chord duration failed.");
	[(NoteBase *)chord setDuration:2];
}

- (void) testTryToFill{
	Chord *chordCopy = [chord copy];
	[chordCopy tryToFill:(effDuration(2, YES) + effDuration(16, YES))];
	STAssertEquals([chordCopy getEffectiveDuration], effDuration(2, YES), @"Chord failed to fill duration.");
	[chordCopy release];
}

- (void) testSubtractDurationReturningSingleChord{
	NSArray *array = [chord subtractDuration:effDuration(4, NO)];
	STAssertEquals([array count], (unsigned)1, @"Wrong number of chords returned after subtracting duration.");
	STAssertTrue([[array objectAtIndex:0] isKindOfClass:[Chord class]], @"Chord not returned when subtracting duration from chord.");
	STAssertEquals([[[array objectAtIndex:0] getNotes] count], (unsigned)3, @"Wrong number of notes in returned chord.");
	STAssertEquals([[array objectAtIndex:0] getEffectiveDuration], effDuration(2, NO), @"Wrong duration left after subtracting duration.");
	STAssertEquals([chord getEffectiveDuration], effDuration(2, YES), @"Original chord object modified during subtract duration.");
}

- (void) testSubtractDurationReturningMultipleChords{
	NSArray *array = [chord subtractDuration:effDuration(8, NO)];
	STAssertEquals([array count], (unsigned)2, @"Wrong number of chords returned after subtracting duration.");
	STAssertTrue([[array objectAtIndex:0] isKindOfClass:[Chord class]], @"Chord note returned when subtracting duration from chord.");
	STAssertEquals([[[array objectAtIndex:0] getNotes] count], (unsigned)3, @"Wrong number of notes in returned chord.");
	STAssertTrue([[array objectAtIndex:1] isKindOfClass:[Chord class]], @"Chord note returned when subtracting duration from chord.");
	STAssertEquals([[[array objectAtIndex:1] getNotes] count], (unsigned)3, @"Wrong number of notes in returned chord.");
	STAssertEquals([[array objectAtIndex:0] getEffectiveDuration] + [[array objectAtIndex:1] getEffectiveDuration],
				   effDuration(2, NO) + effDuration(8, NO), @"Wrong duration left after subtracting duration.");
	STAssertEquals([chord getEffectiveDuration], effDuration(2, YES), @"Original chord object modified during subtract duration.");
	//STAssertEqualObjects([[array objectAtIndex:0] getTieTo], [array objectAtIndex:1], @"Notes returned from subtracting duration not tied together.");
}

- (void) testAddNoteAddsOtherChord{
	Chord *otherChord = [chord copy];
	[chord addNote:otherChord];
	STAssertEquals([[chord getNotes] count], (unsigned)6, @"Chord not added to other chord.");
	[otherChord release];
}

// undo/redo tests

- (void)setUpUndoTest{
	doc = [[MusicDocument alloc] init];
	mgr = [[NSUndoManager alloc] init];
	[doc setUndoManager:mgr];
	song = [[Song alloc] initWithDocument:doc];
	staff = [[song staffs] lastObject];
	[chord setStaff:staff];
	measure = [staff getLastMeasure];
	[measure addNote:chord atIndex:-0.5 tieToPrev:NO];
}

- (void)tearDownUndoTest{
	[song release];
	[mgr release];
	[doc release];	
}

- (void) testUndoRedoAddNote{
	[self setUpUndoTest];
	[mgr beginUndoGrouping];
	Note *note = [[Note alloc] initWithPitch:0 octave:0 duration:2 dotted:YES accidental:NO_ACC onStaff:staff];
	[chord addNote:note];
	[mgr endUndoGrouping];
	[mgr undo];
	STAssertEquals([[chord getNotes] count], (unsigned)3, @"Failed to undo adding note to chord");
	[mgr redo];
	STAssertEquals([[chord getNotes] count], (unsigned)4, @"Failed to redo adding note to chord");
	[self tearDownUndoTest];
}

- (void) testUndoRedoRemoveNote{
	[self setUpUndoTest];
	[mgr beginUndoGrouping];
	Note *note = [[chord getNotes] objectAtIndex:1];
	[chord removeNote:note];
	[mgr endUndoGrouping];
	[mgr undo];
	STAssertEquals([[chord getNotes] count], (unsigned)3, @"Failed to undo removing note from chord");
	[mgr redo];
	STAssertEquals([[chord getNotes] count], (unsigned)2, @"Failed to redo removing note from chord");
	[self tearDownUndoTest];
}

@end
