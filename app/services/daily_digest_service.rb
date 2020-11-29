class DailyDigestService
  # deliver_later делает отправку - асинхронно, помещает отправку в очередь (фоновая отправка) 
  # deliver_now - синхронно без добавления в очередь
  # find_each - грузит в память из БД по 500 записей
  def send_digest
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
