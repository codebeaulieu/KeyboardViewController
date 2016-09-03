# KeyboardViewController
This is a class I wrote that wraps up all of the extra code necessary to hide and show your keyboard.

# Instructions
1. Simply add the KeyboardViewController class to your project and swap out the "UIViewController" subclass for the "KeyboardViewController" subclass in any view that has text input fields.
2. Set your textField and textView delegates in your viewDidLoad like this:

```javascript
setDelegates(nameTextField, estimatedPriceTextField, dateTextField, descriptionTextView,  historyTextView)
```
