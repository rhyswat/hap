require_relative "../lib/config"

module Config

    describe 'Config' do
        context 'Parts' do
            it 'returns a blank part with empty configuration' do
                part = Config.part { }

                expect(part.title).to eql 'untitled'
                expect(part.clips).to be_empty
                expect(part.transitions).to be_empty
            end

            it 'accepts simple parameters' do
                part = Config.part {
                    title 'Wombat'
                    tempo 100
                }

                expect(part.title).to eql 'Wombat'
                expect(part.tempo).to eql 100
            end

            it 'accepts a list of clips' do
                part = Config.part {
                    clip {
                        label 'c1'
                        event {
                            note 'a'
                            duration 'minim'
                            dynamic 'ff'
                        }
                    }
                    clip {
                        label 'c2'
                        event {
                            note 'b'
                            duration 'semiquaver'
                            dynamic 'p'
                        }
                    }
                }

                expect(part.clips.length).to eql 2
                expect(part.clips.keys). to eql %i[c1 c2]
                expect(part.clips[:c1].label).to eql :c1
                expect(part.clips[:c1].events.length).to eql 1
                expect(part.clips[:c1].events[0].note).to eql :a
                expect(part.clips[:c1].events[0].duration).to eql :minim
                expect(part.clips[:c1].events[0].dynamic).to eql :ff
            end

            it 'accepts a list transitions' do
                part = Config.part {
                    transition {
                        from 'c1'
                        to 'c2'
                        probability 0.4
                    }
                    transition {
                        from 'c2'
                        to 'c1'
                        probability 0.6
                    }
                }

                expect(part.transitions.length).to eql 2
                expect(part.transitions[0].from).to eql :c1
                expect(part.transitions[0].to).to eql :c2
                expect(part.transitions[0].probability).to eql 0.4
            end
        end
    end
end
