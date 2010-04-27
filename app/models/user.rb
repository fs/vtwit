require 'ostruct'

class User < ActiveRecord::Base
  class Twitter < OpenStruct
  end
end
