## Installation

Add this line to your application's Gemfile:

    gem 'crush_pics'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crush_pics

## Getting Started

First you need to sign-up for the [Crush.pics API](http://app.crush.pics/) and obtain your unique **api token**. You will find it under [API Details](https://app.crush.pics/account). Once you have set up your account, you can start using Crush.pics API in your application.

## Authentication

The first step is to authenticate to Crush.pics API by providing your unique **api token** while creating new `CrushPics::Client` instance:

```ruby
require 'crush_pics'

client = CrushPics::Client.new(api_token: 'api-token')
```

## How to use

You can optimize your images in two ways - by providing an URL of the image you want to optimize or by uploading an image file directly to Crush.pics API.

The first option (image URL) is great for images that are already in production or any other place on the Internet. The second one (direct upload) is ideal for your deployment process, build script or the on-the-fly processing of your user's uploads where you don't have the images available on-line yet.

## Usage - Image URL

You will need to provide an `url` to the image

```ruby
client = CrushPics::Client.new(api_token: 'api-token')
response = client.compress_async(url: '<http://example.com/path/to/image.png>', type: 'balanced')

if response.success?
  puts response.body['original_image']
elsif response.validation_error?
  puts response.validation_error_message
else
  puts response.body
end
```

Depending on if you perform a asynchronous or synchronous request, in response you will find either details of created original image record details or original image record details along with array of optimized images.

Original image attributes:

```json
{
    "id": 5671,
    "compression_type": "lossy",
    "compression_level": 75,
    "origin": "file",
    "size": 62497,
    "file_type": "image/jpeg",
    "filename": "61ScJ54p17L._UX679_.jpg",
    "status": "enqueued",
    "created_at": "2019-09-27T12:57:01.047Z",
    "updated_at": "2019-09-27T12:57:01.056Z",
    "link": "<https://download.crush.pics/2>.."
}
```

```json
{
    "id": 6698,
    "status": "completed",
    "error_msg": null,
    "style": "original",
    "width": null,
    "height": null,
    "link": "<https://download.crush.pics/7f>...",
    "size": 40484,
    "file_type": "image/jpeg",
    "filename": "61ScJ54p17L._UX679_.jpg",
    "created_at": "2019-09-27T12:52:17.280Z",
    "updated_at": "2019-09-27T12:52:18.346Z"
}
```

## Usage - Image Upload

If you want to upload your images directly to Crush.pics API provide an IO-compatible object as argument.

```ruby
client = CrushPics::Client.new(api_token: 'api-token')

File.open('/path/to/image.png') do |file|
  response = client.compress_async(io: file, type: 'balanced')

  if response.success?
    puts response.body['original_image']
  elsif response.validation_error?
    puts response.validation_error_message
  else
    puts response.body
  end
end
```

## Async and Sync compression

Crush.pics API gives you two options for fetching optimization results. Using `compress_async` the results will be posted to the URL specified in your account settings.
With `compress_sync` the results will be returned immediately in the response.

### Async compression

With the `compress_async` call the HTTPS connection will be terminated immediately after receiveing all data and a unique `original_image.id` will be returned in the response body. After the optimization is finished, Crush.pics will POST a message to the callback URL specified in your account settings. The ID in the response will reflect the ID in the results posted to your Callback URL.
