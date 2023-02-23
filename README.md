# UnitFormatter

The 'better' NumberFormatter for Apple platforms supporting values with appended units and
allowing the User to enter values (format string to number) even without or with a 
wrongly formatted unit string.



## Motivation

The NumberFormatter belonging to the Foundation framework is specifically designed to 
format numerical values into strings and vice versa. It was not intended to add a 
unit to such strings.

There is a possible workaround by setting a `positiveSuffix` and `negativeSuffix` to
the name of the unit (including a separating space), but these were never intended
to serve this purpose. They shall rather be different for positive and negative numbers
and shall be used in such circumstances where a negative / positive sign is rather 
appended than prepended (e. g. in bookkeeping).

When formatting a string to a number with a NumberFormatter with defined suffixes, the
User is forced to provide the exact unit string, which is quite easy for "mm", but with
"°C" or "mv/V / kN" things may become tricky for the user trying to figure out the correct
suffix.



## Solution

``UnitFormatter`` jumps in here. It's basic feature is, that string-to-number conversion
is much more tolerant. Independently of the suffix entered by the user, only the remainder
of the string will be interpreted as a number. So, in scenarios, where the user enters the
wrong unit. This will simply be ignored by the UnitFormatter and the correct numerical
value should be returned.

In the other direction, where a number is formatted into a string, the unit is just added as
a suffix.



## Known Issues
Currently, all non-numerical characters (decimal numbers, decimal point characters) are kept 
for numerical interpretation. This results in the fact that negative numbers can't be entered.
Also all suffixes and prefixes and thousands-separators (e.g ')are ignored during formatting.

This shall be fixed by referencing the NumberFormatters behviour. But for the time beeing this
is considered being "good enough".



## Use of the ``UnitFormatter``

The ``UnitFormatter`` is a subclass of the ``NumberFormatter`` and hence, can be used in 
every place, where the ``NumberFormatter`` is used. Simply set the `unit` and the
`paddingString` being used between value and unit and you're done.  



