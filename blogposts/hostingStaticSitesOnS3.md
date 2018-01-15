# Hosting static sites on S3

Turns out this was pretty straightforward. The steps are basically:

    * decide on a dns name for your static page
    * create an S3 bucket using that name (bullshit.jowj.net) 
    * upload at least one file to your bucket
    * change bucket to enable hosting static pages (ensure you set the file you uploaded to be your index)
    * copy fully qied aws name of endpoint and point cname (bullshit) to that endpoint
    * boom done. 

I'd had this as a "thing to do" for forever, but I guess I thought it'd be more involved. this was just really straight forward.


