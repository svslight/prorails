class ReputationJob < ApplicationJob
  queue_as :default

  # Фоновая задача вызывает сервис Reputation по уникальной ссылке (id и type)
  # которую генерирует ActiveJob и через которую сам объект загружается в БД
  # есть ограничения- не все типы можно передавать в класс фоновой задачи
  # н-р, это не работает для ассоциаций (особенно has_many)
  def perform(object)
    Reputation.calculate(object)
  end
end
