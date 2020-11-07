module AnswersHelper
  def cable_files(answer)
    answer.files.map do |file|
      { name: file.filename.to_s, url: url_for(file) }
    end
  end

  def cable_links(answer)
    answer.links.map do |link|
      { id: link.id, name: link.name, url: link.url, gist_content: link.gist? ? link.gist_content : '' }
    end
  end
end
