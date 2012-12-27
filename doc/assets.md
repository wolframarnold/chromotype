# Chromotype asset terminology

## What's an "asset"?

An "asset" has a caption, a description, and tags.

An asset embodies an image (or later, a movie or other types of files).

If an image is edited, the new image will be associated to the same asset as the
original (but can be disassociated manually), so it won't need to be re-tagged or re-described.

## What's an "asset url"?

An asset url is a path to an asset. An asset has one or more asset_url instances.

If an asset is first found non-locally, the asset will be cached
locally and will _also_ have a `file://` asset location.

If duplicate files are found, those `file://` URLs will point to the same asset.

If an iPhoto library is imported, for example, the "original" or "master" version,
including the RAW/CR2 version, as well as a "modified" or "preview" .JPG version
of a photo will point to the same asset. The modified asset will be shown by default,
because the last_modified value of the file will be the most recent.

# Use cases

## What happens when assets with the same byte contents are found in two different directories?

* Their SHA content fingerprint will match, and both Asset urls will point to the same Asset.

## What happens when assets are modified in iPhoto?

* ProtoAsset will find the prior asset because the URN::Exif will match the previous version of the image.

## What happens when a file is edited in place?

If the SHA content fingerprint and the EXIF header don't match the previous values for that asset
URI, we mark the Asset URI as missing.

## What happens on asset tombstone
and if that's the last Asset URI pointing to an Asset, we mark the asset as tombstoned.

# Asset library

Chromotype's library defaults to `~/Pictures/Chromotype` (on Mac and Linux)
or `~/My Pictures/Chromotype` (on Windows).

The Chromotype library holds:

## Assets

When `Settings.move_to_library` is enabled, assets are moved into the following path:

`#{library_directory}/Assets/YYYY/MM/DD/#{original filename}`

If the same filename with the same taken-at date is found, the file will be moved to:

`#{library_directory}/Assets/YYYY/MM/DD/#{content SHA}-#{original filename}`

## Resized images

* `#{library_directory}/Resized/#{sha[0]}/#{sha[1]}/#{sha}-#{width}.jpg` which holds variously-size thumbnails

## SHA-1 versus SHA-256 or SHA-512?

We're using SHA-1 for file content comparisons, not for integrity.

Although collisions have been found, it is extremely unlikely (1e-80) that different file contents
will have the same SHA-1 value. A number of systems (including git) use SHA-1 as a unique description
for a stream of bytes. If it's good enough for git, it's good enough for me.
