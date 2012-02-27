## What constitutes a duplicate file?

### Certainly

* A file with the same sha2

### Probably:

* A file with the same "durable exif headers" and same numeric filename
(EXIF headers that get persisted by Photoshop, iPhoto, Preview, ...)

### Probably not

* Same durable exif headers, different numeric filename (to detect intra-second exposures)
