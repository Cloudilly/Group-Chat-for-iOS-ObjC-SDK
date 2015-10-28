#Anonymous Group Chat for iOS ObjC SDK
Repository contains sample codes required to build an anonymous group chat application using Cloudilly iOS ObjC SDK.

![Anonymous](https://github.com/Cloudilly/Images/blob/master/ios_anonymous.png)

#####Create app > Secret
If you have not already done so, first create an account on [Cloudilly](https://cloudilly.com). Next create an app with a unique app identifier and a cool name. Once done, you should arrive at the app page with all the access keys for the different platforms. Under Web SDK, you will find the parameters required for your web application. _"Secret"_ refers to the secret key shared between the developer and Cloudilly. It will be used by the server side token generator to sign the JSON Web Tokens. _"Access"_ refers to the access keys to be embedded in the client side codes. _"Domains"_ refer the URLs of your web application authorized to make use of the access key. Note that _'example.com'_ and _'www.example.com'_ are considered 2 separate URLs.

![Web Console](https://github.com/cloudilly/images/blob/master/web_console.png)

#####Instantiate ExpressJS server
We will be using ExpressJS as our application server. Deploy the below dependencies.
```
npm install jsonwebtoken
npm install body-parser
npm install express
```

#####Update Secret
[Download the NodeJS files](../tree/master/NodeJS) and save them to a local directory. Insert _"Secret"_ obtained earlier into [app.js](../blob/master/NodeJS/app.js) where appropriate. App.js is the ExpressJS file that dispenses out signed tokens at _'/tokens'_ endpoint. Later the [Web plugin](../blob/master/Cloudilly/web.js) will be pointing to this endpoint to retrieve the token needed for subsequent authentication.

#####Update Access
Insert your _"App Name"_ and _"Access"_ into [custom.js](../blob/master/NodeJS/public/custom.js) where appropriate. Custom.js is the frontend Javascript that calls Cloudilly. Once done, upload all files to the ExpressJS server. Finally, navigate to the authorized URL on your browser to verify connection to Cloudilly. If you have setup the anonymous chat app for other platforms, you should also test if you can send messages across platforms, ie from Web to iOS / Android and vice versa.
