module TimeScopable
	extend ActiveSupport::Concern

	included do
		scope :today,            -> { on_date(Time.now) }
		scope :in_progress,      -> { where("#{time_scopable_start} <= ?", Time.now).where("#{time_scopable_end} > ?", Time.now) }
		scope :on_date,          ->(date) { where(time_scopable_moment => date.midnight..(date.midnight + 1.day)) }
		scope :upcoming,         -> { where("#{time_scopable_moment} > ?", Time.now).chrono }
		scope :upcoming_by_date, -> { where("#{time_scopable_moment} > ?", Time.now.midnight + 1.day).chrono }
		scope :past,             -> { where("#{time_scopable_moment} < ?", Time.now).chrono }
		scope :past_by_date,     -> { where("#{time_scopable_moment} < ?", Time.now.midnight).chrono }
		scope :chrono,           -> { order(time_scopable_moment => :asc) }
		scope :reverse_chrono,   -> { chrono.reverse_order }
	end

	module ClassMethods

		def time_scopable_moment
			time_scopable_duration ? time_scopable_start : :created_at
		end

		def time_scopable_start
			:starts_at
		end

		def time_scopable_end
			:ends_at
		end

		def time_scopable_duration
			false
		end

	end
	
end