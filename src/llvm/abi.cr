# LLVM::ABI is deprecated. The compiler uses Crystal::ABI instead.

# Based on https://github.com/rust-lang/rust/blob/29ac04402d53d358a1f6200bea45a301ff05b2d1/src/librustc_trans/trans/cabi.rs
@[Deprecated("This API is now internal to the compiler and no longer updated publicly.")]
abstract class LLVM::ABI
  getter target_data : TargetData
  getter? osx : Bool
  getter? windows : Bool

  @[Deprecated("This API is now internal to the compiler and no longer updated publicly.")]
  def initialize(target_machine : TargetMachine)
    @target_data = target_machine.data_layout
    triple = target_machine.triple
    @osx = !!(triple =~ /apple/)
    @windows = !!(triple =~ /windows/)
  end

  abstract def abi_info(atys : Array(Type), rty : Type, ret_def : Bool, context : Context)
  abstract def size(type : Type)
  abstract def align(type : Type)

  def size(type : Type, pointer_size) : Int32
    case type.kind
    when Type::Kind::Integer
      (type.int_width + 7) // 8
    when Type::Kind::Float
      4
    when Type::Kind::Double
      8
    when Type::Kind::Pointer
      pointer_size
    when Type::Kind::Struct
      if type.packed_struct?
        type.struct_element_types.reduce(0) do |memo, elem|
          memo + size(elem)
        end
      else
        size = type.struct_element_types.reduce(0) do |memo, elem|
          align_offset(memo, elem) + size(elem)
        end
        align_offset(size, type)
      end
    when Type::Kind::Array
      size(type.element_type) * type.array_size
    else
      raise "Unhandled Type::Kind in size: #{type.kind}"
    end
  end

  def align_offset(offset, type) : Int32
    align = align(type)
    (offset + align - 1) // align * align
  end

  def align(type : Type, pointer_size) : Int32
    case type.kind
    when Type::Kind::Integer
      (type.int_width + 7) // 8
    when Type::Kind::Float
      4
    when Type::Kind::Double
      8
    when Type::Kind::Pointer
      pointer_size
    when Type::Kind::Struct
      if type.packed_struct?
        1
      else
        type.struct_element_types.reduce(1) do |memo, elem|
          Math.max(memo, align(elem))
        end
      end
    when Type::Kind::Array
      align(type.element_type)
    else
      raise "Unhandled Type::Kind in align: #{type.kind}"
    end
  end

  @[Deprecated("This API is now internal to the compiler and no longer updated publicly.")]
  enum ArgKind
    Direct
    Indirect
    Ignore
  end

  @[Deprecated("This API is now internal to the compiler and no longer updated publicly.")]
  struct ArgType
    getter kind : ArgKind
    getter type : Type
    getter cast : Type?
    getter pad : Nil
    getter attr : Attribute?

    def self.direct(type, cast = nil, pad = nil, attr = nil)
      new ArgKind::Direct, type, cast, pad, attr
    end

    def self.indirect(type, attr) : self
      new ArgKind::Indirect, type, attr: attr
    end

    def self.ignore(type) : self
      new ArgKind::Ignore, type
    end

    @[Deprecated("This API is now internal to the compiler and no longer updated publicly.")]
    def initialize(@kind, @type, @cast = nil, @pad = nil, @attr = nil)
    end
  end

  @[Deprecated("This API is now internal to the compiler and no longer updated publicly.")]
  class FunctionType
    getter arg_types : Array(ArgType)
    getter return_type : ArgType

    @[Deprecated("This API is now internal to the compiler and no longer updated publicly.")]
    def initialize(@arg_types, @return_type)
    end
  end
end
