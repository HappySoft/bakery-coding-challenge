# frozen_string_literal: true

ENV['RUBY_ENV'] ||= 'development'

require 'bundler/setup'

Bundler.require(:default, ENV['RUBY_ENV'].to_sym)

require_relative 'order_processor'
require_relative 'packs_calculator'
require_relative 'products_database'
