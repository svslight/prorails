ThinkingSphinx::Index.define :answer, with: :active_record do
  # fields
  indexes body
  indexes author.email, as: :author, sortable: true

  # attributes
  has question_id, author_id, created_at, updated_at
end
