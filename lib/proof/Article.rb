class Article < Table
  f [:id, :n, :key]
  f [:author, :s]
  f [:name, :s]
  f [:uri, :s]
  # p [:stateful, 'article-counter']
end