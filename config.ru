# frozen_string_literal: true

require 'bundler'
require 'dotenv/load'
require_relative 'lib/ip'

run Sinatra::Application
