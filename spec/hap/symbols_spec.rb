require_relative "../../lib/hap/symbols"

module Hap

    describe 'Symbols' do
        context 'Notes' do
            it 'produces a frozen collection of notes' do
                expect{ NOTES[:added] = 5}.to raise_error FrozenError
            end

            it 'produces a full piano' do
                distinct_midi_values = Set.new(NOTES.values)
                expect(distinct_midi_values.length).to eql 88
            end

            it 'produces a full octave starting from C' do
                expect(NOTES[:c_1]).to eql 24
                expect(NOTES[:cs_1]).to eql 25
                expect(NOTES[:db_1]).to eql 25
                expect(NOTES[:d_1]).to eql 26
                expect(NOTES[:ds_1]).to eql 27
                expect(NOTES[:eb_1]).to eql 27
                expect(NOTES[:e_1]).to eql 28
                expect(NOTES[:f_1]).to eql 29
                expect(NOTES[:fs_1]).to eql 30
                expect(NOTES[:gb_1]).to eql 30
                expect(NOTES[:g_1]).to eql 31
                expect(NOTES[:gs_1]).to eql 32
                expect(NOTES[:ab_1]).to eql 32
                expect(NOTES[:a_1]).to eql 33
                expect(NOTES[:as_1]).to eql 34
                expect(NOTES[:bb_1]).to eql 34
                expect(NOTES[:b_1]).to eql 35
            end

            it 'produces the right extremes in the right places' do
                sorted = NOTES.values.sort()
                expect(sorted[0]).to eql 21
                expect(sorted[-1]).to eql 108

                expect(NOTES[:a_0]).to eql 21
                expect(NOTES[:c_4]).to eql 60
                expect(NOTES[:c_8]).to eql 108
            end

            it 'produces enharmonics' do
                expect(NOTES[:cs_3]).to eql NOTES[:db_3]
                expect(NOTES[:ds_3]).to eql NOTES[:eb_3]
                expect(NOTES[:fs_3]).to eql NOTES[:gb_3]
                expect(NOTES[:gs_3]).to eql NOTES[:ab_3]
                expect(NOTES[:as_3]).to eql NOTES[:bb_3]
            end
        end
    end
end