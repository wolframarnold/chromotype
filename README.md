# Chromotype? #

**Before August 12, 2011:** (noun) A sheet printed in colors by any process.

**After:** Your new favorite way of gathering, archiving, and viewing the photos and movies of your life.

<em>This is the Rails port of <a href="http://photostructure.com">PhotoStructure</a></em>.

**Unfortunately, it's not ready for public consumption yet.**

## Why not Google+/Facebook/Flickr?

Between losing your entire cloud-based email account, having privacy
settings changed behind your back, and hundreds of photo sharing sites
going out of business, why *would* you trust a company to store what
amounts to the visual record of your life?

### Why not some other cloud service?

If you've been taking photos regularly for a couple years, you'll have
tens to hundreds of gigabytes of photos already. It would take weeks
or months to upload all of your photos and movies to the
cloud. Desktop applications like iPhoto and Picasa just don't scale to
libraries with that many assets.

## What's the solution?

*Chromotype*. It runs on your local computer, but it can also be used to
share your photos directly -- but *you* are the cloud.

Chromotype imports both the photos you have on your computer, even in
your iPhoto and Picasa libraries. It also can import the photos and
movies you previously uploaded in the cloud (like Flickr, Picasa, and
Facebook), and archive those on your computer as well.

### Randomness makes you fast
 
Chromotype, by default, shows you a "chronoshuffle" -- Your photos and
images, sorted by time, gathered by event, with a random assortment
from that event. This randomized algorithm makes finding that "needle
in a haystack" always only a couple clicks away.

You can hide photos you don't want to see, give the images you love a
star, and use web services to get your photo printed with just a click
or two.

## Nerdy details

### How does this work?

Chromotype is a Ruby on Rails application.

You'll need Ruby 1.9 (use RVM) and a database (I've only tested with
MySQL, but Postgres should work too).

### How do I tell Chromotype where my stuff is?

You specify directories to import, and Chromotype will see when
you add new files and directories, and import them automatically.

### When does Chromotype synchronize my stuff?

Chromotype runs different kind of "harvesters" to keep the db in
sync with reality.

### Fast Harvester

This only processes the directories whose mtime != last_processed_mtime.

This is fairly cheap, but it doesn't find files that are updated.

### Thorough Harvester

The thorough harvester doesn't skip any files -- it checks everything.

### When do harvesters run?

When rails starts up, the nightly harvester is scheduled and a fast
harvester is kicked off.

### In what order do files get processed?

Newer files are imported before older files, by setting priority to
100 + (current time - mtime) (so newer photos are processed before
older photos). Priorities < 100 are for user-facing tasks.