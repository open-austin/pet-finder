shared_examples_for 'a time_scopable' do
  
	describe 'when loading by scope' do

		before do
			@jan_first = Time.new(2014, 1, 1, 5)
			Time.stub(:now) { @jan_first }

			moment = concernable.time_scopable_moment

			@models = {}
			@models[:oldest]       = concernable.new(moment => Time.now - 2.days)
			@models[:older]        = concernable.new(moment => Time.now - 1.day)
			@models[:today_past]   = concernable.new(moment => Time.now - 1.hour)
			@models[:today_now]    = concernable.new(moment => Time.now)
			@models[:today_future] = concernable.new(moment => Time.now + 1.hour)
			@models[:nexter]       = concernable.new(moment => Time.now + 1.day)
			@models[:nextest]      = concernable.new(moment => Time.now + 2.days)
			@models.each {|name, model| model.save validate: false }

			if concernable.time_scopable_duration
				starts_at = concernable.time_scopable_start
				ends_at = concernable.time_scopable_end
				@models.each {|name, model| model.update(ends_at => model[starts_at] + 1.day + 1.hour) }
			end
		end

		after do
			concernable.destroy_all
		end
		
		describe 'today' do
			
			it 'loads only models with moments from today' do
				concernable.today.should =~ [ @models[:today_past], @models[:today_now], @models[:today_future] ]
			end
				
		end
		
		describe 'in_progress (duration)' do
			
			it 'loads only models that are currently in progress' do
				if concernable.time_scopable_duration
					concernable.in_progress.should =~ [ @models[:older], @models[:today_past], @models[:today_now] ]
				end
			end
				
		end
		
		describe 'on_date' do
			
			it 'loads only models from the given date' do
				concernable.on_date(Time.now + 1.day).should =~ [ @models[:nexter] ]
			end
				
		end
		
		describe 'upcoming' do
			
			it 'loads only upcoming models in chrono order' do
				concernable.upcoming.should eq [ @models[:today_future], @models[:nexter], @models[:nextest] ]
			end
				
		end
		
		describe 'upcoming_by_date' do
			
			it 'loads only upcoming models by date in chrono order' do
				concernable.upcoming_by_date.should eq [ @models[:nexter], @models[:nextest] ]
			end
				
		end
		
		describe 'past' do

			it "loads only the past models in chrono order" do 
				concernable.past.should eq [ @models[:oldest], @models[:older], @models[:today_past] ]
			end
				
		end
		
		describe 'past_by_date' do

			it "loads only the past models by date in chrono order" do 
				concernable.past_by_date.should eq [ @models[:oldest], @models[:older] ]
			end
				
		end
		
		describe 'chrono' do
			
			it 'loads models in chronological order' do
				concernable.chrono.should eq [ @models[:oldest], @models[:older], @models[:today_past], @models[:today_now], @models[:today_future], @models[:nexter], @models[:nextest] ]
			end
				
		end
		
		describe 'reverse_chrono' do
			
			it 'loads models in reverse chronological order' do
				concernable.reverse_chrono.should eq [ @models[:nextest], @models[:nexter], @models[:today_future], @models[:today_now], @models[:today_past], @models[:older], @models[:oldest] ]
			end
				
		end

	end

end
