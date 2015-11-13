require 'bundler'
Bundler.require

ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kaname'
require 'minitest/autorun'
require 'mocha/mini_test'
require "webmock/minitest"
