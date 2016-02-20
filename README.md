# CodePathWeek3Mailbox
CodePath iOS for Designers Week 3 Assignment
Mailbox App Demo

This is a walkthrough of the iOS Mailbox app for week 3's assignment.

Time spent: 8.5 hours in total

Project Requirements
 * [x] On dragging the message left...
   * [x] Initially, the revealed background color should be gray.
   * [x] As the reschedule icon is revealed, it should start semi-transparent and become fully opaque. If released at this point, the message should return to its initial position.
   * [x] After 60 pts, the later icon should start moving with the translation and the background should change to yellow.
   * [x] Upon release, the message should continue to reveal the yellow background. When the animation it complete, it should show the reschedule options.
   * [x] After 260 pts, the icon should change to the list icon and the background color should change to brown.
   * [x] Upon release, the message should continue to reveal the brown background. When the animation it complete, it should show the list options.
   * [x] User can tap to dismissing the reschedule or list options. After the reschedule or list options are dismissed, you should see the message finish the hide animation.
 * [x] On dragging the message right...
   * [x] Initially, the revealed background color should be gray.
   * [x] As the archive icon is revealed, it should start semi-transparent and become fully opaque. If released at this point, the message should return to its initial position.
   * [x] After 60 pts, the archive icon should start moving with the translation and the background should change to green.
   * [x] Upon release, the message should continue to reveal the green background. When the animation it complete, it should hide the message.
   * [x] After 260 pts, the icon should change to the delete icon and the background color should change to red.
   * [x] Upon release, the message should continue to reveal the red background. When the animation it complete, it should hide the message.
 * [x] Optional: Panning from the edge should reveal the menu
   * [x] Optional: If the menu is being revealed when the user lifts their finger, it should continue revealing.
   * [x] Optional: If the menu is being hidden when the user lifts their finger, it should continue hiding.
 * [ ] Optional: Tapping on compose should animate to reveal the compose view.
 * [x] Optional: Tapping the segmented control in the title should swipe views in from the left or right.
 * [x] Optional: Shake to undo.

Notes: I stored the number of files archived/saved for later in NSUserDefaults. Don't think it's necessary in this case as I mantain the lists in one view.
This value drives the number count next to Saved for Later in the menu, and the number of emails in each scrollview list.
I had some trouble getting a tap gesture recognizer to work for closing the menu. It might have tried to use the one I created for the reschedule/list view dismiss.
I didn't yet store the past actions in an array, but that would let me more intelligently go backwards in time with each shake.
