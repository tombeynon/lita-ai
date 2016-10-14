require "spec_helper"

describe Lita::Handlers::Ai, lita_handler: true do
  let(:cleverbot){ double(:cleverbot) }
  before(:each) do
    allow(subject.class).to receive(:cleverbot){ cleverbot }
  end

  describe 'handling unhandled_message' do
    context 'unhandled directed at lita' do
      it 'uses cleverbot to reply' do
        allow(subject.class.cleverbot).to receive(:say){ 'Hello' }
        send_message('Hi lita')
        expect(replies.last).to eq('Hello')
      end
    end
    context 'unhandled not directed at lita' do
      it 'doesn\'t reply' do
        send_message('Not talking to you')
        expect(replies.last).to be_nil
      end
    end
  end

  describe '#chat' do
    let(:cleverbot){ double(:cleverbot) }
    let(:source){ double(:source) }
    context 'commanding lita' do
      let(:message){ double(:message, body: 'Hello', command?: true, source: source) }

      it 'strips out the robot name' do
        expect(subject.class.cleverbot).to receive(:say).with('Hello')
        subject.chat(message: message)
      end

      it 'strips out the robot aliases' do
        robot.alias = 'bender'
        allow(message).to receive(:body){ 'Hi bender' }
        expect(subject.class.cleverbot).to receive(:say).with('Hi')
        subject.chat(message: message)
      end

      it 'sends a message with cleverbot\'s response' do
        expect(subject.class.cleverbot).to receive(:say).with('Hello'){ 'Hi' }
        expect(subject.robot).to receive(:send_message).with(source, 'Hi')
        subject.chat(message: message)
      end

    end

    context 'unicode decoding' do
      let(:message){ double(:message, body: '中文', command?: true, source: source) }
      before { allow(described_class.cleverbot).to receive(:say).and_return("|56E0|4E3A|6211|4E0D|61C2...") }

      it { expect(subject.chat(message: message)[0]).to eq "因为我不懂..." }
    end

    context 'HTML entity decoding' do
      let(:message){ double(:message, body: 'Foo &#xA9; bar &#x1D306;', command?: true, source: source) }
      before { allow(described_class.cleverbot).to receive(:say).and_return("Baz &#x2603; Bim &aring;") }

      it { expect(subject.chat(message: message)[0]).to eq "Baz ☃ Bim å" }
    end

    context 'mentioning lita' do
      let(:message){ double(:message, body: 'Hi lita', command?: false, source: source) }

      it 'strips out the robot name' do
        expect(subject.class.cleverbot).to receive(:say).with('Hi')
        subject.chat(message: message)
      end

      it 'strips out the robot aliases' do
        robot.alias = 'bender'
        allow(message).to receive(:body){ 'Hello bender' }
        expect(subject.class.cleverbot).to receive(:say).with('Hello')
        subject.chat(message: message)
      end

      it 'sends a message with cleverbot\'s response' do
        expect(subject.class.cleverbot).to receive(:say).with('Hi'){ 'Hello' }
        expect(subject.robot).to receive(:send_message).with(source, 'Hello')
        subject.chat(message: message)
      end
    end

    context 'is not chatting' do
      let(:message){ double(:message, body: 'Not talking to you', command?: false, source: source) }

      it 'Doesn\'t call cleverbot' do
        expect(subject.class.cleverbot).to_not receive(:say)
        subject.chat(message: message)
      end
    end
  end
end
