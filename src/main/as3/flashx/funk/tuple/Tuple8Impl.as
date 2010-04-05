package flashx.funk.tuple {
  import flashx.funk.Product;
  import flashx.funk.collections.IList;
  import flashx.funk.error.IndexOutOfBoundsError;

  internal final class Tuple8Impl extends Product implements ITuple8 {
    private var __1: *
    private var __2: *
    private var __3: *
    private var __4: *
    private var __5: *
    private var __6: *
    private var __7: *
    private var __8: *

    public function Tuple8Impl(_1: *, _2: *, _3: *, _4: *, _5: *, _6: *, _7: *, _8: *) {
      __1 = _1, __2 = _2, __3 = _3, __4 = _4, __5 = _5, __6 = _6, __7 = _7, __8 = _8
    }

    public function get _1():* { return __1 }
    public function get _2():* { return __2 }
    public function get _3():* { return __3 }
    public function get _4():* { return __4 }
    public function get _5():* { return __5 }
    public function get _6():* { return __6 }
    public function get _7():* { return __7 }
    public function get _8():* { return __8 }

    override public function get productArity(): int {
      return 8
    }

    override public function productElement(i: int): * {
      switch(i) {
        case 0: return __1
        case 1: return __2
        case 2: return __3
        case 3: return __4
        case 4: return __5
        case 5: return __6
        case 6: return __7
        case 7: return __8
        default: throw new IndexOutOfBoundsError()
      }
    }
  }
}