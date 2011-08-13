class Directory < ActiveRecord::Base
  belongs_to :parent, :classname => Directory
  
end

