require_relative "../lib/config"

module Config
    describe 'Config' do
        context 'Code first' do
            it 'returns a blank part with empty configuration' do
                part = ConfigReader.part { }

                expect(part.name).to eql 'untitled'
                expect(part.clips).to be_empty
                expect(part.transitions).to be_empty
            end

            it 'accepts simple parameters' do
                part = ConfigReader.part {
                    name 'Wombat'
                }

                expect(part.valid?).to be false
                expect(part.name).to eql 'Wombat'
            end

            it 'accepts a list of clips' do
                part = ConfigReader.part {
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

                expect(part.valid?).to be false
                expect(part.clips.length).to eql 2
                expect(part.clips.keys). to eql %i[c1 c2]
                expect(part.clips[:c1].label).to eql :c1
                expect(part.clips[:c1].events.length).to eql 1
                expect(part.clips[:c1].events[0].note).to eql :a
                expect(part.clips[:c1].events[0].duration).to eql :minim
                expect(part.clips[:c1].events[0].dynamic).to eql :ff
            end

            it 'accepts a list transitions' do
                part = ConfigReader.part {
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

                expect(part.valid?).to be false
                expect(part.transitions.length).to eql 2
                expect(part.transitions[0].from).to eql :c1
                expect(part.transitions[0].to).to eql :c2
                expect(part.transitions[0].probability).to eql 0.4
            end
        end

        context 'Config first' do
            it 'returns a blank part with empty configuration' do
                src = File.join(__dir__, 'data', 'empty_part.rb')
                data = File.open(src).read
                part = eval(data, ConfigReader.get_binding)

                expect(part.valid?).to be false
                expect(part.name).to eql 'untitled'
                expect(part.clips).to be_empty
                expect(part.transitions).to be_empty
            end

            it 'populates a part from configuration' do
                src = File.join(__dir__, 'data', 'complete_part.rb')
                data = File.open(src).read
                part = eval(data, ConfigReader.get_binding)
                
                expect(part.valid?).to be true
                expect(part.name).to eql 'Part #7'
                expect(part.clips.length).to eql 2
                expect(part.transitions.length).to eql 4
            end
        end

        context 'Piece' do
            it 'recognises an invalid piece' do
                piece = Piece.new
                piece.seed = 'abcde'
                piece.parts = [Part.new]

                expect(piece.valid?).to be false
            end

            it 'reads an empty piece' do
                src = File.join(__dir__, 'data', 'empty_piece.rb')
                data = File.open(src).read
                piece = eval(data, ConfigReader.get_binding)

                expect(piece.valid?).to be false
                expect(piece.title).to eql 'untitled'
                expect(piece.tempo).to eql 90
                expect(piece.seed).to be_nil
                expect(piece.parts).to be_empty
            end

            it 'reads a complete piece' do
                src = File.join(__dir__, 'data', 'complete_piece.rb')
                data = File.open(src).read
                piece = eval(data, ConfigReader.get_binding)

                expect(piece.valid?).to be true
                expect(piece.title).to eql 'Compelte Piece'
                expect(piece.tempo).to eql 120
                expect(piece.seed).to eql 12345
                expect(piece.parts.length).to eql 2
            end
        end

    end
end