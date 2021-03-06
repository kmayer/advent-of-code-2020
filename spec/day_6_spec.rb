class CustomDeclaration
  attr_reader :group
  def initialize(group)
    @group = group.each_line.map(&:chomp).map(&:chars).reject(&:empty?).map(&:to_set)
  end

  def score
    group.inject(&:|).count # union
  end
end

class CustomDeclaration2 < CustomDeclaration
  def score
    group.inject(&:&).count # intersection
  end
end

RSpec.describe CustomDeclaration do
  let(:data) { 
    <<~EOT
    abc

    a
    b
    c
    
    ab
    ac
    
    a
    a
    a
    a
    
    b
    EOT
  }

  let(:custom_declarations) {
    Array.new.tap do |array|
      data.each_line("\n\n") do |group|
        array << described_class.new(group)
      end
    end
  }

  it { expect(custom_declarations.map(&:score)).to eq([3, 3, 3, 1, 1]) }
  it { expect(custom_declarations.map(&:score).inject(&:+)).to eq(11) }

  context "problem data" do
    let(:data) { File.read(File.expand_path("../fixtures/day_6.txt", __FILE__)) }

    it { expect(custom_declarations.map(&:score).inject(&:+)).to eq(6_532) }
  end
end

RSpec.describe CustomDeclaration2 do
  let(:data) { 
    <<~EOT
    abc

    a
    b
    c
    
    ab
    ac
    
    a
    a
    a
    a
    
    b
    EOT
  }

  let(:custom_declarations) {
    Array.new.tap do |array|
      data.each_line("\n\n") do |group|
        array << described_class.new(group)
      end
    end
  }

  it { expect(custom_declarations.map(&:score)).to eq([3, 0, 1, 1, 1]) }
  it { expect(custom_declarations.map(&:score).inject(&:+)).to eq(6) }

  context "problem data" do
    let(:data) { File.read(File.expand_path("../fixtures/day_6.txt", __FILE__)) }

    it { expect(custom_declarations.map(&:score).inject(&:+)).to eq(3_427) }
  end
end