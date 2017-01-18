class Event < ApplicationRecord
  validates :description, length: { maximum: 500 }
  validates_datetime :time, :after => lambda { DateTime.now }

  scope :in_future, (lambda do
    where("time > ?", DateTime.now)
  end)

  scope :by_interval, (lambda do |interval|
    due_date = DateTime.now + interval[0..-2].to_i.days
    where("time < ?", due_date)
  end)

  scope :due_date, (lambda do |due_date|
    where("time < ?", due_date)
  end)
end
