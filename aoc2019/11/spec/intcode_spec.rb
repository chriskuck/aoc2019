require './spec/spec_helper'
require './intcode/machine'

RSpec.describe 'intcode' do

  let(:program_text) { "" }
  let(:program) { Machine.new(program_text) }
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }

  context '#process' do
    subject  { program.process(input, output) }

    context 'given quine' do
      let(:program_text) { "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99" }
      it 'produces a quine' do
        subject
        expect(output.string.sub(/\s/,"")).to eq program_text+","
      end
    end

    context 'given program to output integers' do
      let(:program_text) { "1102,34915192,34915192,7,4,7,99,0" }
      it 'should output a 16 digit number' do
        subject
        expect(output.string.sub(/\s/,"").length).to be 17
      end
    end

    context 'given program to output middle integer' do
      let (:program_text) { "104,1125899906842624,99" }
      it 'should be equal to the middle integer' do
        subject
        expect(output.string.sub(/\s/,"")).to eq "1125899906842624,"
      end
    end

    context 'test add' do
      let(:program_text) { "1,0,0,0,99" }

      it 'should put 2, in program[0]' do
        subject
        expect(program.program_text).to eq "2,0,0,0,99"
      end
    end

    context 'test mult and add' do
      let(:program_text) { "1,9,10,3,2,3,11,0,99,30,40,50" }

      it 'should store 3500 at program[0]' do
        subject
        expect(program.program_text[0..4]).to eq "3500,"
      end
    end

    context 'test mult' do
      let(:program_text) { "2,3,0,3,99" }

      it 'should store 6 at program[3]' do
        subject
        expect(program.program_text[5..7]).to eq ",6,"
      end
    end

    context 'test mult' do
      let(:program_text) { "2,4,4,5,99,0" }

      it 'should write an exact program' do
        subject
        expect(program.program_text).to eq "2,4,4,5,99,9801"
      end
    end

    context 'test mult and overwrite program' do
      let(:program_text) { "1,1,1,4,99,5,6,0,99" }

      it 'should write an exact program' do
        subject
        expect(program.program_text).to eq "30,1,1,4,2,5,6,0,99"
      end
    end

    context 'indirect memory and overwrite' do
      let(:program_text) { "1002,4,3,4,33" }

      it 'should write an exact program' do
        subject
        expect(program.program_text).to eq "1002,4,3,4,99"
      end
    end

    context 'program to test input and less than' do
      let(:program_text) { "3,9,8,9,10,9,4,9,99,-1,8" }
      context 'when less than 8' do
        let(:input) { StringIO.new("3") }
        it 'writes a 0' do
          subject
          expect(output.string.sub(/\s/,"")).to eq "0,"
        end
      end

      context 'when equal 8' do
        let(:input) { StringIO.new("8") }
        it 'writes a 1' do
          subject
          expect(output.string).to eq "1,"
        end
      end
    end
  end
end
