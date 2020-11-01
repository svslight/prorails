class QuestionsChannel < ApplicationCable::Channel
  # stream - канал связи на pub/sub; stream_from - имя stream; 'questions' - id stream
  def follow
    stream_from 'questions'
  end
end
