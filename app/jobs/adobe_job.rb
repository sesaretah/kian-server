class ImportJob < ApplicationJob
  queue_as :default

  def perform(semster)
    MoodleCourse.prepare_semster(3991)
  end
end
