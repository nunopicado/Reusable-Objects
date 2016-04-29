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


Use Guide
---------

Each object will have its own how-to documentation. There is however some 
guidelines that will be usefull for every one of them.

All these objects are interface based, which means object memory is always
managed and freed automatically. You don't ever have to call Free or FreeAndNil 
on any of these objects.

Another important issue is that you don't ever instantiate any of them with its 
constructors. Any constructor you may find are for self-use only.
Every object has one (or more) class functions named New that act in fact as a 
constructor.
The idea behind this approach is to force an interface instance, instead of a 
implementation class instance, thus avoiding memory leaks even when you don't 
have a variable to hold that instance.
This method and all its advantages I owe to **Marco Douglas Santos**, a great 
Object Pascal developer which came up with this elegant approach.

Seldom will you find procedures or properties in these objects.
All methods will tend to be functions, and most of these will return the object
itself, which means you will be able to chain method calls in one single 
statement.