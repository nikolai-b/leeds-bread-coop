class Week < ActiveRecord::Base
  class << self
    def num
      last ? last.week_num : -1
    end

    def num=(val)
      if last
        last.update week_num: val
      else
        create(week_num: val)
      end
    end
  end
end
