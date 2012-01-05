require File.join(File.dirname(__FILE__), '../ext/PhoneNumberFormatter/PhoneNumberFormatter')
require File.join(File.dirname(__FILE__), 'spec_helper')

describe PhoneNumberFormatter do
  describe 'stringForObjectValue:' do
    before do
      @phone_number_formatter = PhoneNumberFormatter.alloc.init
    end

    it 'returns (234) 567-7890 for 2345677890' do
      actual = @phone_number_formatter.stringForObjectValue('2345677890')
      actual.should.equal('(234) 567-7890')
    end

    it 'returns 1 for 1' do
      actual = @phone_number_formatter.stringForObjectValue('1')
      actual.should.equal('1')
    end

    it 'returns 223-4 for 2234' do
      actual = @phone_number_formatter.stringForObjectValue('2234')
      actual.should.equal('223-4')
    end

    it 'returns 223-45 for 22345' do
      actual = @phone_number_formatter.stringForObjectValue('22345')
      actual.should.equal('223-45')
    end

    it 'returns (223) 456-78 for 22345678' do
      actual = @phone_number_formatter.stringForObjectValue('22345678')
      actual.should.equal('(223) 456-78')
    end

    it 'returns 23456778909 for 23456778909' do
      actual = @phone_number_formatter.stringForObjectValue('23456778909')
      actual.should.equal('23456778909')
    end

    it 'returns 223-4567 for 2234567' do
      actual = @phone_number_formatter.stringForObjectValue('2234567')
      actual.should.equal('223-4567')
    end

    describe 'starting with a 1' do
      it 'returns 1 (2  ) for 12' do
        actual = @phone_number_formatter.stringForObjectValue('12')
        actual.should.equal('1 (2  )')
      end

      it 'returns 1 (23 ) for 123' do
        actual = @phone_number_formatter.stringForObjectValue('123')
        actual.should.equal('1 (23 )')
      end

      it 'returns 1 (234) for 1234' do
        actual = @phone_number_formatter.stringForObjectValue('1234')
        actual.should.equal('1 (234)')
      end

      it 'returns 1 (234) 5 for 12345' do
        actual = @phone_number_formatter.stringForObjectValue('12345')
        actual.should.equal('1 (234) 5')
      end

      it 'returns 1 (234) 567-8 for 12345678' do
        actual = @phone_number_formatter.stringForObjectValue('12345678')
        actual.should.equal('1 (234) 567-8')
      end

      it 'returns 1 (234) 567-8900 for 12345678900' do
        actual = @phone_number_formatter.stringForObjectValue('12345678900')
        actual.should.equal('1 (234) 567-8900')
      end

      it 'returns 123456789000 for 123456789000' do
        actual = @phone_number_formatter.stringForObjectValue('123456789000')
        actual.should.equal('123456789000')
      end
    end
  end
end

