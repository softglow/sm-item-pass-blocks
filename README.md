Happy New Year 2014 from softglow!


ITEM-PASSABLE BLOCKS
====================
"What if you had GRAVITY SUIT BLOCKS?"  Now you can.  Or any other item!
In fact, because of how I decided to test this, the item used by this ASM is
Hi-Jump.


USAGE
=====

Make an Air Fool X-Ray tile and give it BTS $0E.  (Note: I have not actually
checked that this BTS is 100% unused in the game.  But, there aren't many of
those block types around.)

Change the #$0100 values in the AND and CMP to whatever inventory item you
desire.  (I haven't made it a handy define yet.)

Change the BTS that activates this by updating the last `org` statement.  It
should be $94DF00 + (2 * BTS).  Note that the game uses the BTS elsewhere, so
the usable BTS values are $00-0F.  The other tables are only that big.

Run xkas on an unheadered ROM.

The ONLY change in behavior in this version of the patch is that those blocks
will act solid to Samus unless she has collected the relevant item.  Enemy and
projectile reactions are untouched, and no PLMs are made.


COMPATIBILITY
=============

* Entirely bypasses the Samus+block collision detection for Air Fool XRay.
* Consumes free space at $94:DE50-DF20.  It's not tightly packed there, but
  I might want all that (or more?) in an updated patch.
* Creates a "standard" way to handle Air Fool XRay BTS.  Other patches could
  be ported on top of this framework...


SPECIAL MENTIONS
================

This would not have been possible (perhaps even dreamed up) without everyone
behind xkas, SMILE JX, and metroidconstruction.com.  But also...

SquishyIchigo:

* I used your ASM mnemonic and instruction list docs rather a lot.

Shadow34370 and BlackFalcon:

* I learned a lot from your Air Tubes and MP2 Style Blocks patches.

Kejardon and Jathys:

* BlockCollisReact.txt
* We are all standing on your shoulders.


LICENSE
=======

Copyright 2014 [softglow](https://github.com/softglow).  All rights reserved.

GPLv3.  See the LICENSE file for details.
