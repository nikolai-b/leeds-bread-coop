desc "This task is called by the Heroku scheduler add-on hourly"
task :copy_regular_orders => :environment do
  if (Date.current.cwday == 7) && (Order::Copy.week_num != Date.current.cweek)
    Order.copy_regular_orders
    Order::Copy.week_num = Date.current.cweek
  end

  if (Date.current.cwday == 3) || (Date.current.cwday == 7)
    if Time.now.hour == 14
      system('python', 'compost.v2.py')
    end
  end


end
