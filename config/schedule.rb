set :output, "#{path}/log/cron.log"

every 1.day, at: '5.30am' do
  runner "Articolo.ricalcola_eli"
end
