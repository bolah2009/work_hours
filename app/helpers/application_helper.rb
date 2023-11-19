module ApplicationHelper
  def get_notice_class(notice_type)
    notice_class = {
      error: 'bg-red-200 text-red-900',
      warn: 'bg-yellow-200 text-yellow-900',
      info: 'bg-green-200 text-green-900',
      success: 'bg-indigo-200 text-indigo-900'
    }.with_indifferent_access
    notice_class[notice_type]
  end
end
