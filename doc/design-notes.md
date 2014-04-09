# HTWax Design Notes

## Basic Flow

REST in a nutshell:

    +--------+
    |        v
    |     Request ----+
    |        |        +-- HTTP Client
    |        v        |
    |     Response ---+
    |        |
    |        v
    |  Representation
    |        |
    |        v
    |       Link
    |        |
    +--------+

An HTTP client turns a Request for a resource into a Response. From
that you can get the returned Representation. The Representation
may contain a number of Links to other resources; these can be
used to initiate further Requests.

## Plug-ins

The various parts of the basic flow can be tailored for specific uses
by adding plug-ins. Examples:

* Adding Basic (or other) authentication headers to each request before
  it is sent.
* Adding appropriate cache control headers to each request and caching
  responses as appropriate. Cache could either be in memory or on disk.
* Adding cookies to requests and storing cookies that appear in responses.
  Again, cookies could be held either in memory or on disk.
* Extracting Links from returned Representations. Different response
  media types will need different plug-ins to extract links.

Plug-ins can maintain state between invocations, so the framework has
plug-in instances (not classes) registered with it.

## Request

Basically a way of building an HTTP request.

* Need to be able to set HTTP method and request headers.
* If Request construction normally requires a Link object there should
  be a short-cut for performing the most common HTTP requests without
  constructing a Link first.

A plug-in should be able to filter the Request before it is sent.
It should be possible for a plug-in to alter any of the request
headers, the URI, the method or the body. It should also be
possible for a plug-in to turn one request into multiple requests.
For example, the authentication plug-in might first attempt the
request without the Authentication header and then try again with
it. A caching plug-in might perform a HEAD request followed by a
GET request if the resource has changed.

## Response

Represents the response received from the server. Should provide access
to the response headers and the body without any processing having being
performed. Should allow the response to be converted into a representation
using an appropriate media type plug-in.

Assumption: A Response can be converted into a Representation in a single
operation. In other words, a Representation can be completely parsed and
a finite number of Links produced, using a reasonable amount of computing
power and memory.

## Representation

Wraps the resource representation received from the server.

* Provides a map from link identifiers to Link objects.
* Gives access to the parsed representation if the media type plug-in
  makes it available.
* Should be reusable: It should be possible for a client to hang on to
  a Representation object and use it to look up many different Links.

## Link

Link objects represent sets of possible requests that could be performed.

* Should identify parameters that can influence the request, such as
  form parameters, URL template path components.
* Should be able to build a new Request based on bound values of
  parameters.
* Should be reusable: It should be possible for a client to hang on to
  a Link object and use it to create multiple requests.

Links will need to use media type plug-ins to convert some parameters into
requests. For example, application/x-www-form-urlencoded request bodies
will need constructing from the bound link parameters.

## Media Type Plug-ins

Media type plug-ins are used primarily to extract Links from returned
representations and to build new representations from parameters for use
as Request bodies. Examples of the kinds of things that might be media
type plug-ins:

* Construct an application/x-www-form-urlencoded request body.
* Construct a multipart/form-data request body.
* Parse an HTML or XHTML document and extract all the links and forms,
  turning them in to Link objects. Links would be identified by CSS class,
  id, rel, or by the plain text content contained in the anchor. 
* Parse a WADL description.

## HTTP Request Plug-ins

Many HTTP request plug-ins will need to change their behaviour depending
on the host, path or other aspect of the request.

The HTTP authentication plug-in will need some way to identify requests
that need an Authentication header that has already been provided (i.e.
one for which the library already has appropriate credentials). It must
not send credentials in requests that do not call for them, which requires
the authentication plug-in to maintain a map from hosts, domains and
realms to credentials. Need to consult the HTTP specification to work out
the correct behaviour.

HTTP compression could be performed by a plug-in as well. Add the
correct header and decompress the response.

## Configuration

The main point of configuration is the set of plug-ins that are available.
Media type plug-ins should not carry much overhead: they will probably
add entries to a mime type list, but other than that they won't be invoked
unless a matching representation is found. This implies that there is little
penalty to including all the available media type plug-ins by default.

HTTP request/response plug-ins add additional functionality to the framework;
there is probably a minimal set that makes sense for simple usages. Perhaps
authentication but no caching?

There should be a global configuration that is used by default, but some
users might want to have separate configurations for different uses. For
example, communication with different hosts.
