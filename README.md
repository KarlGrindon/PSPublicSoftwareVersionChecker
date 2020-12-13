# PSPublicSoftwareVersionChecker
 A repo holding code that allows you to check external websites for the latest version of software.

## What it is

This is (currently) a script that will check upstream websites for the latest version of a particular piece of software.

## How to use it

Pass a json file to the script (an example is supplied).

The json file has specific keys in it:

### "product_name"
This is the name of the software. This can be anything you like, however it's probably best to set the value of this to something appropriate.

### "url"
This is the URL where the latest version can be found. For example, this could be a releases page, or download page. This page can hold multiple version numbers in its HTML; the script will pick the highest version.

### "regex_pattern"
The script uses regex to find versions. This is where things get tricky; you need to be able to work out appriopriate regex to capture the version correctly. Sadly, there's too much variation out there for me to provide a good example, but perhaps look at the supplied config.json file for examples.

### "platform"
This is the essentially the OS that the software runs on. Any value will work here, but perhaps stick to Windows, Mac OS, Linux etc. No validation is performed on this value.

### "os-type"
This is the type of OS, as in client, server, mobile etc. Any value will work here, but perhaps stick to Windows, Mac OS, Linux etc. No validation is performed on this value.

# Potential future improvements

- Create validation for platofrm and os-type. This could be tricky as people may want values for different builds of Windows, Mac OS, Linux, Android etc.
- Create validation for os-type. Again, could be slightly tricky as people may want to define what they want here.
- JSON manipulation and validation. Allowing people to easily add items to the JSON array, without touching the JSON manually.
- Logic to differentiate beteen different platforms when scraping. For example, we may want to get the latest version of software X for Mac OS only, where different platforms are on the same page. This can already be done techincally, depending on the regex match you choose.