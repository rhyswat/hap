require_relative '../../lib/hap/driver'
require_relative '../../lib/hap/symbols'

module Hap

    describe 'Driver' do

        before :each do
            @driver = Driver.new
            @event = Event.new
        end
        
        context 'Helpers' do
            it 'should translate piano keyboard notes' do
                @event.note = :c_4
                expect(@driver.note_value(@event)).to eql 60
            end

            it 'should translate rests to a surrogate note' do
                @event.note = :rest
                expect(@driver.note_value(@event)).to eql 1
            end

            it 'should translate rest notes to zero velocity' do
                @event.note = :rest
                expect(@driver.note_velocity(@event)).to eql 0
            end

            it 'should translate rest dynamics to zero velocity' do
                @event.note = :c_3
                @event.dynamic = :rest
                expect(@driver.note_velocity(@event)).to eql 0
            end
        end
    end
end