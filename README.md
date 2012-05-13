# Chromotype [![Build Status](https://secure.travis-ci.org/mceachen/chromotype.png?branch=master)](http://travis-ci.org/mceachen/chromotype)

**Before August 12, 2011:** (noun) A sheet printed in colors by any process.

**After:** Your new favorite way of gathering, archiving, and viewing the photos and movies of your life.

<em>This is the Rails port of <a href="http://photostructure.com">PhotoStructure</a></em>.

**Unfortunately, it's not ready for public consumption yet.** Feel free to read on, but know this still a work in progress.

## Why not Google+/Facebook/Flickr?

Between losing your entire cloud-based email account, having privacy
settings changed behind your back, and hundreds of photo sharing sites
going out of business, why *would* you trust a company to store what
amounts to the visual record of your life?

### Why not iPhoto/Picasa/…?

If you've been taking photos regularly for a couple years, you'll have
tens to hundreds of /gigabytes/ of photos already. It would take weeks
or months to upload all of your photos and movies to the
cloud. Desktop applications like iPhoto and Picasa just don't scale to
libraries with that many assets.

## What's the solution?

*Chromotype*. It runs on your local computer, but it can also be used to
share your photos directly -- but *you* are the cloud.

Chromotype imports the photos you have on your computer, even in
your iPhoto and Picasa libraries. It also can import the photos and
movies you previously uploaded in the cloud (like Flickr, Picasa, and
Facebook), and archive those on your computer as well.

### Randomness makes you fast
 
Chromotype shows you /shuffled/ views of your photos and
images. Finding that one shot, that "needle in a haystack," is always
only a couple clicks away even if you don't know where to look at first.

<!-- Coming "soon": You can hide photos you don't want to see, give the images you love a
star, and use web services to get your photo printed with just a click
or two. -->

## Nerdy details

### How does this work?

Chromotype is a Ruby on Rails application.

You'll need to install Rails and an RDBMS (sqlite3, MySQL, or PostgreSQL).

### How do I tell Chromotype where my stuff is?

You specify root URIs when you install Chromotype. They're stored
in the ```settings``` table.

### How do the models interact?

There are only two main models:

* ```tags```, which are hierarchical and polymorphic
* ```assets```, which represents a thing that can be tagged, like an image.

When Chromotype starts, it recurses through each root URI, finds interesting things, extracts features, and imports.

Currently only local filesystems are supported.
