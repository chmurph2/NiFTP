Pull requests are very welcome. Please follow these guidelines (modeled after
thoughtbot's):

1. Fork the repo.

1. Run the tests.  All changes made to the code have passing tests: `bundle && rake`

1. Add a test for your change/fix. Only refactoring and documentation changes
require no new tests.

1. Push to your fork and submit a pull request.

I will respond as quickly as possible and may suggest some changes,
improvements or alternatives.  Some things that will increase the chance that
your pull request is accepted, taken straight from the Ruby on Rails guide:

* Use Rails idioms and helpers
* Include tests that fail without your code, and pass with it
* Update the documentation, the surrounding one or whatever is affected by
your contribution

Syntax:

* Follow the conventions you see used in the source already.
* [No trailing whitespace](http://blogobaggins.com/2009/03/31/waging-war-on-whitespace.html).
Blank lines should not have any space.
* Two spaces, no tabs.
* Prefer &&/|| over and/or.
* MyClass.my_method(my_arg) not my_method( my_arg ) or my_method my_arg.
* a = b and not a=b.