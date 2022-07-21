# AliyunGreen

基于 阿里云的 内容审核

具体参见 [阿里云内容审核](https://help.aliyun.com/document_detail/84456.html?spm=a2c4g.11186623.0.0.7662754aWakeeW)

记得在使用前， 请在阿里云的“内容安全” => “设置” => "机器审核" 的 default 场景中， 点击编辑
之后在图片和文字选项卡里， 开启各种识别类型， 并保存



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aliyun_green'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install aliyun_green

## Usage

具体可参见 spec/aliyun_green_spec.rb 的测试用例

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/aliyun_green.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
