Reusable Objects
================

As the name of this repository suggests, here-in you will find a collection of
objects with very distinct responsabilities, but with the capability of working
toguether as a whole.

Some of these are entirely stand-alone objects, but some have some dependency on
others. `rtl` in particular is often required by the other objects as this 
collection contains a great deal of small, highly re-usable classes.

In each unit you will find as a preffix the list of dependencies, so you can 
quickly evaluate if it suits your needs.

Under **UnitTest** there is a test project using the **DUnit** testing framework.


Installation
------------

The only 'installation' required for using these objects is that you add the 
project folder to your compiler search path either on a per project basis or in
your IDE Library settings (recommended).


Documentation
-------------

In addition to any **README.MD** files which may be found in various locations in
the **Reusable Objects** repository, additional documentation might be available 
in each unit when necessary.


External Dependencies
---------------------

There is no common dependency for every object class. Each one will have different
requirements, and will state them in the unit itself.
However, in order to compile the whole project as a package, you will require to 
have them all availble in the path.
As of now, you will require the following:

* LibEay Extended (https://github.com/nunopicado/libeay32)

* TZDB (https://github.com/pavkam/tzdb)


Use Guide
---------

Each object will have its own how-to documentation. There is however some 
guidelines that will be usefull for every one of them.

All these objects are interface based, which means object memory is always
managed and freed automatically. You don't ever have to call `Free` or `FreeAndNil`
on any of these objects.

Another important issue is that you don't ever instantiate any of them with its 
constructors. Any constructor you may find are for self-use only.
Every object has one (or more) class functions named `New` that act in fact as a 
constructor.
The idea behind this approach is to force an interface instance, instead of a 
implementation class instance, thus avoiding memory leaks even when you don't 
have a variable to hold that instance.
This method and all its advantages I owe to **Marcos Douglas B. Santos**, a great 
**Object Pascal** developer which came up with this elegant approach.

Seldom will you find procedures or properties in these objects.
All methods will tend to be functions, and most of these will return the object
itself, which means you will be able to chain method calls in one single 
statement.

Some objects are merely interfaced versions of existing components, and aim to
allow a more streamlined runtime creation, without the need to free it's memory
when it stops being needed. Of these, some will have a special function, `Obj`, 
which will expose the object itself to allow compatibility use with other 
components.


Licence Agreement
-----------------

All the code in this object collection falls under the GNU LGPLv3, which you
can read here: http://www.gnu.org/licenses/lgpl-3.0.html

The licence agreement applies to the code in this collection of components.
It does not apply to any of its dependencies, which have their own licence 
agreement and to which you must comply in their terms.


Contributions
-------------

You may contribute for this project if you feel so inclined, either with bug 
fixes, enhancements or completely new objects.
It is required however that the code you submit complies with the guidelines.
Always interfaced, no constructors required, using the `New` class function to
instantiate, no destructors needed, functions return the object itself whenever
possible, etc.
Just create a pull request on the main repository whenever you want to submit.
