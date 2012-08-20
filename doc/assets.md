# Chromotype asset terminology

## What's an "asset"?

An asset embodies an image (or later, a movie or other types of files).

An "asset" has a caption, a description, and tags.

## What's an "asset URI"?

An asset URI[^1] is a path to an asset. An asset has one or more asset URIs.

It can be a local file:// URI, or something non-local.

If an asset is first found non-locally, the asset will be cached
locally and will ALSO have a file:// Asset URI.

An asset may have multiple file: Asset URIs if duplicate local files are found.

To support iPhoto's edited photos, where there is an "original" or "master" version,
as well as a "modified" or "preview" version of a photo,
(and the user would want to see only the modified version by default),

## What's a "content fingerprint"?

It's a hash of an aspect of a file -- a SHA of the asset's contents or the SHA
of a select set of EXIF header contents are two content fingerprints.

## What's a "derivative asset"?

Any asset where a content fingerprint matches another asset's content fingerprint.

To make displaying the "best" derivative assets efficient, a "primary derivative" asset id FK
will be null for primary assets, and will point to the most recently modified version of an
image.

# Use cases

## What happens when assets with the same byte contents are found in two different directories?

* Their SHA content fingerprint will match, and both Asset URIs will point to the same Asset.

## What happens when assets are modified in iPhoto?

* Their SHA content fingerprint will not match. Two Assets will be created, and the least
recently modified asset will set it's primary_derivative_asset_id to the most recently
modified asset.

## What happens when a file is edited in place
* The SHA content fingerprint will not match the previous value, which will require
** thumbnails to be rebuilt
** recalculation of the "primary derivative asset id"

## How are derivative asset ids recalculated?

1. for a given asset, A
2. there are N fingerprints: T.
3. and there are 1 or more assets with matching fingerprints to T: M.
4. the most recently modified asset that isn't in a path =~ /Masters|Originals?/ is the "primary": P
5. collect all unique primary_derivative_asset_id in M that are not in M: O
5. all assets in M set primary_derivative_asset_id to P.
6. P.primary_derivative_asset_id is set to null.
7. Recalculate all derivative asset IDs in O.


# TODO: REWRITE ABOVE

## How to determine the "primary" asset URI?

select content_sha, min(uri), min(mtime) as min_mtime from asset_uri
where asset_id = ?
order by min_mtime desc
group by 1
limit 1



# Asset library

Chromotype's library defaults to `~/Pictures/Chromotype` (on Mac and Linux)
or `~/My Pictures/Chromotype` (on Windows).

The Chromotype library holds

## Resized images
* `Resized/%Y/%m/%d/#{sha}-#{width}.jpg` which holds variously-size thumbnails

When `Settings.move_to_library` is enabled, assets are moved into one of the following:

* `Assets/YYYY/MM/dd/` (if the file was originally found in a …/Masters/… directory),
* ```Modified``` (for )

# WAT?

## [^1]: URI? Why not URL?

Yeah, you know I googled "URI versus URL".

No, I won't store URNs.

## SHA-1 versus SHA-256 or SHA-512?

We're using SHA-1 for file content comparisons, not for integrity.

Although collisions have been found, it is extremely unlikely (1e-80) that different file contents
will have the same SHA-1 value. A number of systems (including git) use SHA-1 as a unique description
for a stream of bytes. If it's good enough for git, it's good enough for me.

