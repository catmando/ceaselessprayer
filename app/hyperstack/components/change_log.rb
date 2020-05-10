class ChangeLog < Markdown
MARKDOWN = <<MARKDOWN
## Change Log

See what is new and different and any known problems and issues.

To report a problem send an email to [ceaselessprayers@gmail.com](mailto:ceaselessprayers@gmail.com)
or if you have a github account [visit our github page](https://github.com/catmando/ceaselessprayer)

~~~~
<details><summary style="display: block;font-size: 1.17em; margin-block-start: 1em; margin-block-end: 1em; margin-inline-start: 0px; margin-inline-end: 0px; font-weight: bold;">Change Log</summary>
### Version 1.10, May 9, 2020

+ Fixed problem with Flags
+ Fixed ios PWA issue

### Version 1.9, May 9, 2020

+ Removed version number from end of About page.
+ Added Recent and Frequent Cities pages.
+ Added Prayer of thanksgiving for recovery from sickness.

### Version 1.8, May 7, 2020

+ Speed up map loading
+ Fixed prayer detection to include scrolling

### Version 1.7, May 4, 2020

+ Fixed several typos in prayers.
+ Made oceans on the map more transparent to the background image.
+ Added this change log.

### Version 1.6, May 2, 2020

+ Installable onto the homescreen with automatic SW updates.
+ Map now updates in realtime even while viewing home page.
+ Cleaned up styles for better visibility on all phones.

~~~~
<details><summary style="display: block;font-size: 1.17em; margin-block-start: 1em; margin-block-end: 1em; margin-inline-start: 0px; margin-inline-end: 0px; font-weight: bold;">Problems and New Features</summary>

+ One user reports App will never open on his phone.
+ Users would like to zoom/scroll map.  This is okay, but we need to bring up a reset button I think.
+ Add a ranking by cities to encourage people.
+ Install to home to screen needs instructions for iOS devices.
+ Automatically change background images periodically.
+ Allow people to easily share on facebook.
+ With the more transparent background on the map, the colors of prayers needs to be more intense.

MARKDOWN

  render do
    DIV(style(:container)) do
      papers
    end
  end
end
