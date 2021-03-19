require "spec"
require "big"

describe BigDecimal do
  it "initializes from valid input" do
    BigDecimal.new
      .should eq(BigDecimal.new(BigInt.new(0)))

    BigDecimal.new("41.0123")
      .should eq(BigDecimal.new(BigInt.new(410123), 4))

    BigDecimal.new(1)
      .should eq(BigDecimal.new(BigInt.new(1)))

    BigDecimal.new(-1)
      .should eq(BigDecimal.new(BigInt.new(-1)))

    BigDecimal.new(0)
      .should eq(BigDecimal.new(BigInt.new(0)))

    BigDecimal.new("42.0123")
      .should eq(BigDecimal.new(BigInt.new(420123), 4))

    BigDecimal.new("42_42_42_24.0123_456_789")
      .should eq(BigDecimal.new(BigInt.new(424242240123456789), 10))

    BigDecimal.new("0.0")
      .should eq(BigDecimal.new(BigInt.new(0)))

    BigDecimal.new(".2")
      .should eq(BigDecimal.new(BigInt.new(2), 1))

    BigDecimal.new("2.")
      .should eq(BigDecimal.new(BigInt.new(2)))

    BigDecimal.new("-.2")
      .should eq(BigDecimal.new(BigInt.new(-2), 1))

    BigDecimal.new("-2.")
      .should eq(BigDecimal.new(BigInt.new(-2)))

    BigDecimal.new("-0.1")
      .should eq(BigDecimal.new(BigInt.new(-1), 1))

    BigDecimal.new("-1.1")
      .should eq(BigDecimal.new(BigInt.new(-11), 1))

    BigDecimal.new("123871293879123790874230984702938470917238971298379127390182739812739817239087123918273098.1029387192083710928371092837019283701982370918237")
      .should eq(BigDecimal.new(BigInt.new("1238712938791237908742309847029384709172389712983791273901827398127398172390871239182730981029387192083710928371092837019283701982370918237".to_big_i), 49))

    BigDecimal.new("-123871293879123790874230984702938470917238971298379127390182739812739817239087123918273098.1029387192083710928371092837019283701982370918237")
      .should eq(BigDecimal.new(BigInt.new("-1238712938791237908742309847029384709172389712983791273901827398127398172390871239182730981029387192083710928371092837019283701982370918237".to_big_i), 49))

    BigDecimal.new("-0.1029387192083710928371092837019283701982370918237")
      .should eq(BigDecimal.new(BigInt.new("-1029387192083710928371092837019283701982370918237".to_big_i), 49))

    BigDecimal.new("2")
      .should eq(BigDecimal.new(BigInt.new(2)))

    BigDecimal.new("-1")
      .should eq(BigDecimal.new(BigInt.new(-1)))

    BigDecimal.new("0")
      .should eq(BigDecimal.new(BigInt.new(0)))

    BigDecimal.new("-0")
      .should eq(BigDecimal.new(BigInt.new(0)))

    BigDecimal.new(BigDecimal.new(2))
      .should eq(BigDecimal.new(2.to_big_i))

    BigDecimal.new(BigRational.new(1, 2))
      .should eq(BigDecimal.new(BigInt.new(5), 1))
  end

  it "raises InvalidBigDecimalException when initializing from invalid input" do
    expect_raises(InvalidBigDecimalException) do
      BigDecimal.new("derp")
    end

    expect_raises(InvalidBigDecimalException) do
      BigDecimal.new("")
    end

    expect_raises(InvalidBigDecimalException) do
      BigDecimal.new("1.2.3")
    end

    expect_raises(InvalidBigDecimalException) do
      BigDecimal.new("..2")
    end

    expect_raises(InvalidBigDecimalException) do
      BigDecimal.new("1..2")
    end

    expect_raises(InvalidBigDecimalException) do
      BigDecimal.new("a1.2")
    end

    expect_raises(InvalidBigDecimalException) do
      BigDecimal.new("1a.2")
    end

    expect_raises(InvalidBigDecimalException) do
      BigDecimal.new("1.a2")
    end

    expect_raises(InvalidBigDecimalException) do
      BigDecimal.new("1.2a")
    end
  end

  it "performs arithmetic with bigdecimals" do
    BigDecimal.new(0).should eq(BigDecimal.new(0) + BigDecimal.new(0))
    BigDecimal.new(1).should eq(BigDecimal.new(0) + BigDecimal.new(1))
    BigDecimal.new(1).should eq(BigDecimal.new(1) + BigDecimal.new(0))
    BigDecimal.new(0).should eq(BigDecimal.new(1) + BigDecimal.new(-1))
    BigDecimal.new(0).should eq(BigDecimal.new(-1) + BigDecimal.new(1))
    BigDecimal.new("0.1").should eq(BigDecimal.new("-1.1") + BigDecimal.new("1.2"))
    BigDecimal.new("0.076543211").should eq(BigDecimal.new("-1.123456789") + BigDecimal.new("1.2"))
    BigDecimal.new("0.13456789").should eq(BigDecimal.new("-1.1") + BigDecimal.new("1.23456789"))

    BigDecimal.new(0).should eq(BigDecimal.new(0) - BigDecimal.new(0))
    BigDecimal.new(-1).should eq(BigDecimal.new(0) - BigDecimal.new(1))
    BigDecimal.new(1).should eq(BigDecimal.new(1) - BigDecimal.new(0))
    BigDecimal.new(2).should eq(BigDecimal.new(1) - BigDecimal.new(-1))
    BigDecimal.new(-2).should eq(BigDecimal.new(-1) - BigDecimal.new(1))
    BigDecimal.new(1).should eq(BigDecimal.new("1.12345") - BigDecimal.new("0.12345"))
    BigDecimal.new("1.0000067").should eq(BigDecimal.new("1.1234567") - BigDecimal.new("0.12345"))
    BigDecimal.new("0.9999933").should eq(BigDecimal.new("1.12345") - BigDecimal.new("0.1234567"))

    BigDecimal.new(0).should eq(BigDecimal.new(0) * BigDecimal.new(0))
    BigDecimal.new(0).should eq(BigDecimal.new(0) * BigDecimal.new(1))
    BigDecimal.new(0).should eq(BigDecimal.new(1) * BigDecimal.new(0))
    BigDecimal.new(-1).should eq(BigDecimal.new(1) * BigDecimal.new(-1))
    BigDecimal.new(-1).should eq(BigDecimal.new(-1) * BigDecimal.new(1))
    BigDecimal.new("1.2621466432").should eq(BigDecimal.new("1.12345") * BigDecimal.new("1.123456"))
    BigDecimal.new("1.2621466432").should eq(BigDecimal.new("1.123456") * BigDecimal.new("1.12345"))

    expect_raises(DivisionByZeroError) do
      BigDecimal.new(0) / BigDecimal.new(0)
    end
    expect_raises(DivisionByZeroError) do
      BigDecimal.new(1) / BigDecimal.new(0)
    end
    expect_raises(DivisionByZeroError) do
      BigDecimal.new(-1) / BigDecimal.new(0)
    end

    expect_raises(DivisionByZeroError) do
      BigDecimal.new(0) // BigDecimal.new(0)
    end
    expect_raises(DivisionByZeroError) do
      BigDecimal.new(1) // BigDecimal.new(0)
    end
    expect_raises(DivisionByZeroError) do
      BigDecimal.new(-1) // BigDecimal.new(0)
    end

    BigDecimal.new(1).should eq(BigDecimal.new(1) / BigDecimal.new(1))
    BigDecimal.new(10).should eq(BigDecimal.new(100, 1) / BigDecimal.new(100000000, 8))
    BigDecimal.new(5.to_big_i, 1_u64).should eq(BigDecimal.new(1) / BigDecimal.new(2))
    BigDecimal.new(-5.to_big_i, 1_u64).should eq(BigDecimal.new(1) / BigDecimal.new(-2))
    BigDecimal.new(-5.to_big_i, 4_u64).should eq(BigDecimal.new(1) / BigDecimal.new(-2000))
    BigDecimal.new(-500.to_big_i, 0).should eq(BigDecimal.new(1000) / BigDecimal.new(-2))
    BigDecimal.new(-500.to_big_i, 0).should eq(BigDecimal.new(-1000) / BigDecimal.new(2))
    BigDecimal.new(500.to_big_i, 0).should eq(BigDecimal.new(-1000) / BigDecimal.new(-2))
    BigDecimal.new(5.to_big_i, 1_u64).should eq(BigDecimal.new(-1) / BigDecimal.new(-2))
    BigDecimal.new(5.to_big_i, 4_u64).should eq(BigDecimal.new(-1) / BigDecimal.new(-2000))
    BigDecimal.new(500.to_big_i, 0).should eq(BigDecimal.new(-1000) / BigDecimal.new(-2))
    BigDecimal.new(0).should eq(BigDecimal.new(0) / BigDecimal.new(1))
    BigDecimal.new("3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333".to_big_i, 100_u64).should eq(BigDecimal.new(1) / BigDecimal.new(3))

    BigDecimal.new(0).should eq(BigDecimal.new(1) // BigDecimal.new(2))
    BigDecimal.new(-1).should eq(BigDecimal.new(1) // BigDecimal.new(-2))
    BigDecimal.new(-1).should eq(BigDecimal.new(1) // BigDecimal.new(-2000))
    BigDecimal.new(-500).should eq(BigDecimal.new(1000) // BigDecimal.new(-2))
    BigDecimal.new(-500).should eq(BigDecimal.new(-1000) // BigDecimal.new(2))
    BigDecimal.new(500).should eq(BigDecimal.new(-1000) // BigDecimal.new(-2))
    BigDecimal.new(0).should eq(BigDecimal.new(-1) // BigDecimal.new(-2))
    BigDecimal.new(0).should eq(BigDecimal.new(-1) // BigDecimal.new(-2000))
    BigDecimal.new(500).should eq(BigDecimal.new(-1000) // BigDecimal.new(-2))
    BigDecimal.new(0).should eq(BigDecimal.new(0) // BigDecimal.new(1))
    BigDecimal.new(0).should eq(BigDecimal.new(1) // BigDecimal.new(3))

    BigDecimal.new(33333.to_big_i, 5_u64).should eq(BigDecimal.new(1).div(BigDecimal.new(3), 5))
    BigDecimal.new(33.to_big_i, 5_u64).should eq(BigDecimal.new(1).div(BigDecimal.new(3000), 5))

    BigDecimal.new(3333333.to_big_i, 7_u64).should eq(BigDecimal.new(1).div(BigDecimal.new(3), 7))
    BigDecimal.new(3333.to_big_i, 7_u64).should eq(BigDecimal.new(1).div(BigDecimal.new(3000), 7))

    (-BigDecimal.new(3)).should eq(BigDecimal.new(-3))
  end

  describe "#round" do
    {% for sign in %w[+ -] %}
      context "(with {{sign.id}} sign)" do
        it "returns self if digits are equal or more than significant digits" do
          BigDecimal.new("{{sign.id}}2.5").round(1)
            .should eq(BigDecimal.new(BigInt.new({{sign.id}}25), 1))
          BigDecimal.new("{{sign.id}}000.5").round(1)
            .should eq(BigDecimal.new(BigInt.new({{sign.id}}5), 1))
          BigDecimal.new("{{sign.id}}2.00").round(10)
            .should eq(BigDecimal.new(BigInt.new({{sign.id}}20), 1))
          BigDecimal.new("{{sign.id}}0.00").round(-10)
            .should eq(BigDecimal.new(BigInt.zero))
        end

        it "rounds :to_zero" do
          BigDecimal.new("{{sign.id}}979797799999666.9").round(0, mode: :to_zero)
            .should eq(BigDecimal.new(BigInt.new({{sign.id}}979797799999666)))
        end

        it "rounds :ties_away" do
          BigDecimal.new("{{sign.id}}979797799999666.5").round(0, mode: :ties_away)
            .should eq(BigDecimal.new(BigInt.new({{sign.id}}979797799999667)))
        end

        it "rounds :ties_even" do
          BigDecimal.new("{{sign.id}}979797799999666.5").round(0, mode: :ties_even)
            .should eq(BigDecimal.new(BigInt.new({{sign.id}}979797799999666)))
          BigDecimal.new("{{sign.id}}979797799999666.5").round(0, mode: :ties_even)
            .should eq(BigDecimal.new(BigInt.new({{sign.id}}979797799999666)))
          BigDecimal.new("{{sign.id}}123456078.999").round(-3, mode: :ties_even)
            .should eq(BigDecimal.new(BigInt.new({{sign.id}}123456000)))
        end

        it "rounds :to_positive" do
          BigDecimal.new("{{sign.id}}2.5").round(0, mode: :to_positive)
            .should eq(BigDecimal.new(BigInt.new({{sign.id}}{{sign == "+" ? 3 : 2}})))
        end

        it "rounds :to_negative" do
          BigDecimal.new("{{sign.id}}2.5").round(0, mode: :to_negative)
            .should eq(BigDecimal.new(BigInt.new({{sign.id}}{{sign == "-" ? 3 : 2}})))
        end
      end
    {% end %}
  end

  describe ".rounding_mode" do
    it "defaults to :ties_even" do
      BigDecimal.rounding_mode.should eq(Number::RoundingMode::TIES_EVEN)
    end

    it "allows to be set" do
      begin
        BigDecimal.rounding_mode = :to_zero
        BigDecimal.rounding_mode.should eq(Number::RoundingMode::TO_ZERO)
      ensure
        BigDecimal.rounding_mode = nil
      end
    end

    it "acts as default value for mode argument in #round" do
      BigDecimal.rounding_mode = :to_positive
      BigDecimal.new("2.5").round.should eq(BigDecimal.new(BigInt.new(3)))
      BigDecimal.rounding_mode = nil
      BigDecimal.new("2.5").round.should eq(BigDecimal.new(BigInt.new(2)))
    end
  end

  describe ".save_rounding_mode" do
    it "properly retains and resets rounding mode state" do
      begin
        BigDecimal.rounding_mode = :to_zero
        BigDecimal.save_rounding_mode do
          BigDecimal.rounding_mode = :ties_even
        end
        BigDecimal.rounding_mode.should eq(Number::RoundingMode::TO_ZERO)
      ensure
        BigDecimal.rounding_mode = nil
      end
    end
  end

  describe ".with_rounding_mode" do
    it "sets given mode as .rounding_mode within yielded block" do
      begin
        BigDecimal.rounding_mode = :to_zero
        BigDecimal.with_rounding_mode(:ties_even) do
          BigDecimal.rounding_mode.should eq(Number::RoundingMode::TIES_EVEN)
        end
        BigDecimal.rounding_mode.should eq(Number::RoundingMode::TO_ZERO)
      ensure
        BigDecimal.rounding_mode = nil
      end
    end
  end

  it "performs arithmetic with other number types" do
    (1.to_big_d + 2).should eq(BigDecimal.new("3.0"))
    (2 + 1.to_big_d).should eq(BigDecimal.new("3.0"))
    (2.to_big_d - 1).should eq(BigDecimal.new("1.0"))
    (2 - 1.to_big_d).should eq(BigDecimal.new("1.0"))
    (1.to_big_d * 2).should eq(BigDecimal.new("2.0"))
    (1 * 2.to_big_d).should eq(BigDecimal.new("2.0"))
    (3.to_big_d / 2).should eq(BigDecimal.new("1.5"))
    (3 / 2.to_big_d).should eq(BigDecimal.new("1.5"))
  end

  it "exponentiates" do
    result = "12.34".to_big_d ** 5
    result.should be_a(BigDecimal)
    result.to_s.should eq("286138.1721051424")
  end

  it "can be converted from other types" do
    1.to_big_d.should eq (BigDecimal.new(1))
    "1.5".to_big_d.should eq (BigDecimal.new(15, 1))
    "+1.5".to_big_d.should eq (BigDecimal.new(15, 1))
    BigInt.new(15).to_big_d.should eq (BigDecimal.new(15, 0))
    1.5.to_big_d.should eq (BigDecimal.new(15, 1))
    1.5.to_big_f.to_big_d.should eq (BigDecimal.new(15, 1))
    1.5.to_big_r.to_big_d.should eq(BigDecimal.new(15, 1))
  end

  it "can be converted from scientific notation" do
    "10.01e1".to_big_d.should eq (BigDecimal.new("100.1"))
    "10.01e-1".to_big_d.should eq (BigDecimal.new("1.001"))
    "6.033e2".to_big_d.should eq (BigDecimal.new("603.3"))
    "603.3e-2".to_big_d.should eq (BigDecimal.new("6.033"))
    "-0.123e12".to_big_d.should eq (BigDecimal.new("-123000000000"))
    "0.123e12".to_big_d.should eq (BigDecimal.new("123000000000"))
    "0.123e+12".to_big_d.should eq (BigDecimal.new("123000000000"))
    "-0.123e-7".to_big_d.should eq (BigDecimal.new("-0.0000000123"))
    "-0.1e-7".to_big_d.should eq (BigDecimal.new("-0.00000001"))
    "0.1e-7".to_big_d.should eq (BigDecimal.new("0.00000001"))
    "1.0e-8".to_big_d.should eq (BigDecimal.new("0.00000001"))
    "10e-8".to_big_d.should eq (BigDecimal.new("0.0000001"))
    "1.0e+8".to_big_d.should eq (BigDecimal.new("100000000"))
    "10e+8".to_big_d.should eq (BigDecimal.new("1000000000"))
    "10E+8".to_big_d.should eq (BigDecimal.new("1000000000"))
    "10E8".to_big_d.should eq (BigDecimal.new("1000000000"))
  end

  it "is comparable with other types" do
    BigDecimal.new("1.0").should eq BigDecimal.new("1")
    BigDecimal.new("1").should eq BigDecimal.new("1.0")
    1.should_not eq BigDecimal.new("-1.0")
    1.should_not eq BigDecimal.new("0.1")
    BigDecimal.new(1, 10).should eq BigDecimal.new(10, 11)
    BigDecimal.new(10, 11).should eq BigDecimal.new(1, 10)

    (BigDecimal.new(1) > BigDecimal.new(1)).should be_false
    (BigDecimal.new("1.00000000000000000000000000000000000001") > BigDecimal.new(1)).should be_true
    (BigDecimal.new("0.99999999999999999999999999999999999999") > BigDecimal.new(1)).should be_false
    BigDecimal.new("1.00000000000000000000000000000000000000").should eq BigDecimal.new(1)

    (1 < BigDecimal.new(1)).should be_false
    (BigDecimal.new(1) < 1).should be_false
    (2 < BigDecimal.new(1)).should be_false
    (BigDecimal.new(2) < 1).should be_false
    (BigDecimal.new("-1") > BigDecimal.new("1")).should be_false

    (1 > BigDecimal.new(1)).should be_false
    (BigDecimal.new(1) > 1).should be_false
    (2 > BigDecimal.new(1)).should be_true
    (BigDecimal.new(2) > 1).should be_true
    (BigDecimal.new("-1") < BigDecimal.new("1")).should be_true

    (1 >= BigDecimal.new(1)).should be_true
    (2 >= BigDecimal.new(1)).should be_true

    (1 <= BigDecimal.new(1)).should be_true
    (0 <= BigDecimal.new(1)).should be_true

    (BigDecimal.new("6.5") < 6.6).should be_true
    (6.6 > BigDecimal.new("6.5")).should be_true
    (BigDecimal.new("7.5") > 6.6).should be_true
    (6.6 < BigDecimal.new("7.5")).should be_true

    BigDecimal.new("6.6").should eq(6.6)
    6.6.should eq(BigDecimal.new("6.6"))

    (BigDecimal.new("6.5") > 7).should be_false
    (BigDecimal.new("7.5") > 6).should be_true

    BigDecimal.new("0.5").should eq(BigRational.new(1, 2))
    BigDecimal.new("0.25").should eq(BigDecimal.new("0.25"))

    BigRational.new(1, 2).should eq(BigDecimal.new("0.5"))
    BigRational.new(1, 4).should eq(BigDecimal.new("0.25"))
  end

  it "keeps precision" do
    one_thousandth = BigDecimal.new("0.001")
    one = BigDecimal.new("1")

    x = BigDecimal.new
    1000.times do
      x += one_thousandth
    end
    one.should eq(x)

    x = BigDecimal.new("2")
    1000.times do
      x -= one_thousandth
    end
    one.should eq(x)
  end

  it "converts to string" do
    BigDecimal.new.to_s.should eq "0"
    BigDecimal.new(0).to_s.should eq "0"
    BigDecimal.new(1).to_s.should eq "1"
    BigDecimal.new(-1).to_s.should eq "-1"
    BigDecimal.new("-0.35").to_s.should eq "-0.35"
    BigDecimal.new("-.35").to_s.should eq "-0.35"
    BigDecimal.new("0.01").to_s.should eq "0.01"
    BigDecimal.new("-0.01").to_s.should eq "-0.01"
    BigDecimal.new("0.00123").to_s.should eq "0.00123"
    BigDecimal.new("-0.00123").to_s.should eq "-0.00123"
    BigDecimal.new("1.0").to_s.should eq "1"
    BigDecimal.new("-1.0").to_s.should eq "-1"
    BigDecimal.new("1.000").to_s.should eq "1"
    BigDecimal.new("-1.000").to_s.should eq "-1"
    BigDecimal.new("1.0001").to_s.should eq "1.0001"
    BigDecimal.new("-1.0001").to_s.should eq "-1.0001"

    (BigDecimal.new(1).div(BigDecimal.new(3), 9)).to_s.should eq "0.333333333"
    (BigDecimal.new(1000).div(BigDecimal.new(3000), 9)).to_s.should eq "0.333333333"
    (BigDecimal.new(1).div(BigDecimal.new(3000), 9)).to_s.should eq "0.000333333"

    (BigDecimal.new("112839719283").div(BigDecimal.new("3123779"), 9)).to_s.should eq "36122.824080384"
    (BigDecimal.new("112839719283").div(BigDecimal.new("3123779"), 14)).to_s.should eq "36122.8240803846879"

    BigDecimal.new(1, 2).to_s.should eq "0.01"
    BigDecimal.new(100, 4).to_s.should eq "0.01"
  end

  it "converts to other number types" do
    bd1 = BigDecimal.new(123, 5)
    bd2 = BigDecimal.new(-123, 5)
    bd3 = BigDecimal.new(123, 0)
    bd4 = BigDecimal.new(-123, 0)
    bd5 = "-123.000".to_big_d
    bd6 = "-1.1".to_big_d

    bd1.to_i.should eq 0
    bd2.to_i.should eq 0
    bd3.to_i.should eq 123
    bd4.to_i.should eq -123
    bd5.to_i.should eq -123
    bd6.to_i.should eq -1

    bd1.to_u.should eq 0
    expect_raises(OverflowError) { bd2.to_u }
    bd3.to_u.should eq 123
    expect_raises(OverflowError) { bd4.to_u }
    expect_raises(OverflowError) { bd5.to_u }
    expect_raises(OverflowError) { bd6.to_u }

    bd1.to_f.should eq 0.00123
    bd2.to_f.should eq -0.00123
    bd3.to_f.should eq 123.0
    bd4.to_f.should eq -123.0
    bd5.to_f.should eq -123.0
    bd6.to_f.should eq -1.1

    bd1.to_i!.should eq 0
    bd2.to_i!.should eq 0
    bd3.to_i!.should eq 123
    bd4.to_i!.should eq -123
    bd5.to_i!.should eq -123
    bd6.to_i!.should eq -1

    bd1.to_u!.should eq 0
    bd2.to_u!.should eq 0
    bd3.to_u!.should eq 123
    bd4.to_u!.should eq 123
    bd5.to_u!.should eq 123
    bd6.to_u!.should eq 1

    bd1.to_f!.should eq 0.00123
    bd2.to_f!.should eq -0.00123
    bd3.to_f!.should eq 123.0
    bd4.to_f!.should eq -123.0
    bd5.to_f!.should eq -123.0
    bd6.to_f!.should eq -1.1
  end

  it "hashes" do
    bd1 = BigDecimal.new("123.456")
    bd2 = BigDecimal.new("0.12345")
    bd3 = BigDecimal.new("1.23456")
    bd4 = BigDecimal.new("-123456")
    bd5 = BigDecimal.new("0")

    hash = {} of BigDecimal => String
    hash[bd1] = "bd1"
    hash[bd2] = "bd2"
    hash[bd3] = "bd3"
    hash[bd4] = "bd4"
    hash[bd5] = "bd5"

    # regular cases
    hash[BigDecimal.new("123.456")].should eq "bd1"
    hash[BigDecimal.new("0.12345")].should eq "bd2"
    hash[BigDecimal.new("1.23456")].should eq "bd3"
    hash[BigDecimal.new("-123456")].should eq "bd4"
    hash[BigDecimal.new("0")].should eq "bd5"

    # not found
    expect_raises(KeyError) do
      hash[BigDecimal.new("4")]
    end
  end

  it "upkeeps hashing invariant" do
    # a == b => h[a] == h[b]
    bd1 = BigDecimal.new(1, 2)
    bd2 = BigDecimal.new(100, 4)

    bd1.hash.should eq bd2.hash
  end

  it "can normalize quotient" do
    positive_one = BigDecimal.new("1.0")
    negative_one = BigDecimal.new("-1.0")

    positive_ten = BigInt.new(10)
    negative_ten = BigInt.new(-10)

    positive_one.normalize_quotient(positive_one, positive_ten).should eq(positive_ten)
    positive_one.normalize_quotient(positive_one, negative_ten).should eq(negative_ten)

    positive_one.normalize_quotient(negative_one, positive_ten).should eq(negative_ten)
    positive_one.normalize_quotient(negative_one, negative_ten).should eq(negative_ten)

    negative_one.normalize_quotient(positive_one, positive_ten).should eq(negative_ten)
    negative_one.normalize_quotient(positive_one, negative_ten).should eq(negative_ten)

    negative_one.normalize_quotient(negative_one, positive_ten).should eq(positive_ten)
    negative_one.normalize_quotient(negative_one, negative_ten).should eq(negative_ten)
  end

  describe "#ceil" do
    it { 2.0.to_big_d.ceil.should eq(2) }
    it { 2.1.to_big_d.ceil.should eq(3) }
    it { 2.9.to_big_d.ceil.should eq(3) }

    it { 2.01.to_big_d.ceil.should eq(3) }
    it { 2.11.to_big_d.ceil.should eq(3) }
    it { 2.91.to_big_d.ceil.should eq(3) }

    it { -2.01.to_big_d.ceil.should eq(-2) }
    it { -2.91.to_big_d.ceil.should eq(-2) }

    it { "-123.000".to_big_d.ceil.value.should eq(-123) }
    it { "-1.1".to_big_d.ceil.value.should eq(-1) }
  end

  describe "#floor" do
    it { 2.1.to_big_d.floor.should eq(2) }
    it { 2.9.to_big_d.floor.should eq(2) }
    it { -2.9.to_big_d.floor.should eq(-3) }

    it { 2.11.to_big_d.floor.should eq(2) }
    it { 2.91.to_big_d.floor.should eq(2) }
    it { -2.91.to_big_d.floor.should eq(-3) }

    it { "-123.000".to_big_d.floor.value.should eq(-123) }
    it { "-1.1".to_big_d.floor.value.should eq(-2) }
  end

  describe "#trunc" do
    it { 2.1.to_big_d.trunc.should eq(2) }
    it { 2.9.to_big_d.trunc.should eq(2) }
    it { -2.9.to_big_d.trunc.should eq(-2) }

    it { 2.11.to_big_d.trunc.should eq(2) }
    it { 2.91.to_big_d.trunc.should eq(2) }
    it { -2.91.to_big_d.trunc.should eq(-2) }
  end

  describe "#inspect" do
    it { "123".to_big_d.inspect.should eq("123") }
  end
end
