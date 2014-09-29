desc "This task is called by the Heroku scheduler add-on"
task :copy_regular_orders => :environment do
  if (Date.current.cwday == 7) && (Order::Copy.week_num != Date.current.cweek)
    Order.copy_regular_orders
    Order::Copy.week_num = Date.current.cweek
  end
end
