require 'spec_helper'

describe Yell::Formatter do

  let( :formatter ) { Yell::Formatter.new(subject) }
  let( :event ) { Yell::Event.new 'INFO', 'Hello World!' }
  let( :time ) { Time.now }

  let( :format ) { formatter.format(event) }

  before do
    Timecop.freeze( time )
  end

  context "%m" do
    subject { "%m" }

    it { format.should == "Hello World!" }
  end

  context "%l" do
    subject { "%l" }

    it { format.should == "I" }
  end

  context "%L" do
    subject { "%L" }

    it { format.should == "INFO" }
  end

  context "%d" do
    subject { "%d" }

    it { format.should == time.iso8601 }
  end

  context "%p" do
    subject { "%p" }

    it { format.should == Process.pid.to_s }
  end

  context "%h" do
    subject { "%h" }

    it { format.should == Socket.gethostname }
  end

  context "caller" do
    let( :_caller ) { ["/path/to/file.rb:123:in `test_method'"] }

    before do
      any_instance_of( Yell::Event ) do |e|
        mock(e).caller(4) { _caller }
      end
    end

    context "%F" do
      subject { "%F" }

      it { format.should == "/path/to/file.rb" }
    end

    context "%f" do
      subject { "%f" }

      it { format.should == "file.rb" }
    end

    context "%M" do
      subject { "%M" }

      it { format.should == "test_method" }
    end

    context "%n" do
      subject { "%n" }

      it { format.should == "123" }
    end
  end

  context "DefaultFormat" do
    subject { Yell::DefaultFormat }

    it { format.should == "#{time.iso8601} [ INFO] #{$$} : Hello World!"  }
  end

  context "BasicFormat" do
    subject { Yell::BasicFormat }

    it { format.should == "I, #{time.iso8601} : Hello World!"  }
  end

  context "ExtendedFormat" do
    subject { Yell::ExtendedFormat }

    it { format.should == "#{time.iso8601} [ INFO] #{$$} #{Socket.gethostname} : Hello World!" }
  end

end