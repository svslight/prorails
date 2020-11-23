require 'rails_helper'

# т.к. класс будет перебирать всех user и отсылать им письма
# поэтому создадим список этих userов используя фабрику user
# В тесте достаточно проверить что вызывается нужный метод у нужного Mailer с нужным польз-лем
# Mailer работает с оним польз-лем поэтому нужно установить ожидание для всех поль-лей в списке
# Вызываем DailyDigestMailer у него метод digest с польз-лем который передан в блок
# и у этого сервиса нужно вызвать метод который будет заниматься отправкой (send_digest)

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }

  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
    subject.send_digest
  end
end
