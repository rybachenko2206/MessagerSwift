# MessagerSwift

Test Assignment for iOS Developer
Objective: Create a chat screen using UITableView or UICollectionView with functionality similar to a messaging app.
Main Conditions:
Cell Display:
Cells should be displayed from bottom to top.
New cells should be added at the bottom (behavior similar to any messaging app conversation screen).
Dynamic Cell Height:
Cell height should be dynamic, depending on the content.
Initial State:
The message list is empty initially.
Implementation:
Use Swift and UIKit.
Functional Requirements:
Message Sending:
Place a text field (UITextField) at the bottom of the controller where the user can enter text.
When the "Send" button is pressed, a new cell with the entered text is created (text of arbitrary length).
Message Loading:
Provide the ability to load more messages.
Messages should be loaded into the collection along with current messages upon some event (e.g., button press, scroll to a specific element in the table, etc.).
Image Sending:
Add the ability to send images.
If more than one image is sent, display them in a gallery format with horizontal scrolling.
Context Menu:
Implement a context menu on long press of a cell.
The menu should have at least one button with any text (e.g., "Delete").
Additional Conditions:
Upload the project to GitHub and provide the repository link.
Project Structure
Project:
Create a new project in Xcode.
Ensure the project compiles and runs without errors.
UI:
Place UITableView or UICollectionView on the main screen.
Add a UITextField and a UIButton at the bottom of the screen.
Logic:
Set up the datasource and delegate for UITableView or UICollectionView.
Implement adding new cells when the "Send" button is pressed.
Handle the event for loading more messages.
Add support for sending images and displaying them in a gallery format.
Context Menu:
Set up long press recognition on a cell.
Add a context menu with one button.
Testing:
Verify the correct display of messages.
Verify the dynamic height of cells.
Ensure proper functioning of message loading.
Test sending and displaying images.
Ensure the context menu works correctly.
Approximate Action Plan
Create the project and set up the main structure.
Implement the UI with UITableView or UICollectionView, UITextField, and UIButton.
Set up text message sending.
Implement message loading.
Add the ability to send and display images.
Set up the context menu on long press of a cell.
Test the functionality and fix any bugs found.
Upload the project to GitHub and provide the link.
Good luck with the assignment!
