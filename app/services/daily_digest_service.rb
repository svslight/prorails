class DailyDigestService
  # метод Mailer не делает отправку он только подготавливает письмо
  # отправку делает deliver_later (асинхронно-помещает отправку в очередь - фоновая отправка) 
  # или deliver_now (синхронно без добавления в очередь - это удобно для тестов)
  # используем find_each - который грузит и перебирает по 500 записей в память из БД
  def send_digest
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
