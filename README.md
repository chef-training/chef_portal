# Chef Training Portal Cookbook

This cookbook installs and configures a node to be a Chef Training Portal instance. It currently is expected to be consumed exclusively by [chef_classroom][classroom] on which it also currently depends (TODO: decouple)

## Platform Support

The following platforms have been tested with Test Kitchen:

* centos-6.5

(TODO: .kitchen.cloud.yml)

## Cookbook Dependencies

- chef-dk
- sudo
- chef_classroom
- guacamole

## Roadmap

* Decouple from chef_classroom
* Packerize the process for faster spin up
* More testing
* Replace bespoke functionality with existing cookbooks

## License & Authors

- Author: George Miranda (<gmiranda@chef.io>)
- Author: Franklin Webber (<franklin@chef.io>)
- Author: Seth Thomas (<sthomas@chef.io>)


```text
License:: MIT
Copyright (c) 2015 Chef Software, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

[classroom]: https://github.com/chef-training/chef_classroom
