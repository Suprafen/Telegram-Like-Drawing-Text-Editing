# What is this project about?

This is a Telegram-like drawing and text editing app module which was a task for October's contest. 


## Requirements:

• The app should be written with compatability of iOS 13 and above

• No third-party UI frameworks are allowed
 
 
 ## Current tasks: 
 
- [X] To make a background for text view to become nice. Without the background duplication.
   - [ ] To make a background seen as one area with rounded corners at each intersection.
- [ ] Add an ability to add a few text views on the screen and change/delete them without any problems.

### 12.13.22 
- [X] Text container size adjustment. Size should fit content size. It could be made as next: During init make probable size of the frame and use this size always when text is being edited, however when `textDidChange` called make the size of the container and text view to fit its content.
   - [X] Make max size for width for font changing. E.g. when we increase font size we want to use as many space as we could horizontaly before we go vertically. So make it possible to get all space horizontaly. It should be a conditional btw.
      - [ ] Still need to improve how this looks.
- [ ] Make font name converter the way app could use bold version of e.g. Helvetica but the name to the user should remain Helvetica without any -bold suffixes.
- [ ] Make sure buttons's state is the same when we switch between different text views.
- [ ] Add an ability to delete text views after they've been added.
- [ ] Add two points that centered horzontaly on the left and right sides of text views to make it possible to rotate views.
### 12.12.22 
- [X] Make the size of text container to be dynamic. The size must depend on text font size and content. Don't allow scrolling.


## Done tasks:

- [X] Substitute default slider with custom view as Telegram’s video sample shows.
   - [X] Improve how the slider looks when text editing is active.
- [X] Refactor existing code that’s used to set filling. Move it to NSLayoutManager
- [X] Use provided by Telegram icons for buttons and make them change icons dynamically.
- [X] Add an ability to drag text view after saving.
