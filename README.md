# GetItUploaded
> Minimalistic uploader

## Description

Long story short: I was drawing this layout inside [Sketch](https://www.sketch.com/) just for fun, so I was planning to delete it once I finish it, but I came across [Supernova Studio](https://supernova.io/) and saw that it is able to perform automatic code generation for Flutter based on Adobe XD or Sketch files.

So, here it is. The generated UI is not responsive (and before edits didn’t really match the layout), that's why I decided to restrict UI orientation programmatically to portrait-only.

After that I've decided to write an MVP. 
**GetItUploaded** is basically a [file.io](https://file.io) client. The application uploads a file you select and prompts a "Share" dialog with the link in it. 

To prevent bots/crawlers from invalidating the link when you're sending it over the Net (because [file.io](https://file.io) deletes files once they’ve been accessed), the link is being encoded according to [Base64](https://www.base64decode.org/) format. 

## Screenshot

![image](https://user-images.githubusercontent.com/24318966/85229553-f3163d80-b3f2-11ea-911a-33670b150063.png)

## Meta

Distributed under the GPL-3.0 license. See ``LICENSE`` for more information.

[@limitedeternity](https://github.com/limitedeternity)
