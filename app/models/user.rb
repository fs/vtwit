require 'ostruct'

class User < ActiveRecord::Base
  class Twitter < OpenStruct; end
  class VK < OpenStruct; end
end
