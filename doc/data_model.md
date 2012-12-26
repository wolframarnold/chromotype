# Model design

* handle multiple URLs pointing to the same, or edited file
* fast import support for the same image, so we should be able to find assets by attributes
  that have an increasing cost to compute)

## asset_urls / url_urns / urns

By making a generic "URN" model that could hold the different ways of finding
* ```urn:sha1:#{sha1 of content}```
* ```urn:fs-attrs:#{mtime}:#{file size}```
* ```urn:exif-sha:#{sha of durable exif headers}```

An alternative db design would include the above attributes as fields in the asset_urls table.

By pulling the URN out of the asset_url table it makes the finder code and schema design more
receptive to alternative file fingerprinting methods, including normalized image histograms,
and wavelet signatures.