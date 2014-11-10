namespace :scheduler do
  def perform(*names)
    names.each do |name|
      Rake::Task[name].invoke
    end
  end

  desc "This task is called by the Heroku scheduler add-on hourly"
  task hourly: :environment do
    if Week.num != Date.current
      perform 'scheduler:daily'
      Week.num = Date.current
    end
  end

  desc "Called early every day"
  task daily: :environment do
    perform 'scheduler:weekly' if Date.current.cwday == 1
    if (Date.current.cwday == 3) || (Date.current.cwday == 7)
      if Time.now.hour == 14
        system('python', 'compost.v2.py')
      end
    end
  end

  desc "Called once early Sunday"
  task weekly: :environment do
    Order.copy_regular_orders
    StripeSub.refund_holidays
  end
end
