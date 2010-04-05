
package flashx.funk.collections.immutable {
  import flashx.funk.IFunkObject;
  import flashx.funk.IImmutable;
  import flashx.funk.Product;
  import flashx.funk.collections.IList;
  import flashx.funk.collections.list;
  import flashx.funk.collections.nil;
  import flashx.funk.error.NoSuchElementError;
  import flashx.funk.option.IOption;
  import flashx.funk.option.none;
  import flashx.funk.option.some;
  import flashx.funk.tuple.ITuple2;
  import flashx.funk.tuple.tuple2;
  import flashx.funk.util.eq;
  import flashx.funk.util.require;
  import flashx.funk.util.verifiedType;

  public final class List extends Product implements IImmutable, IList {
    private var _value: *
    private var _next: IList
    private var _length: int = 0
    private var _lengthKnown: Boolean = false

    public function List(value: *, next: IList) {
      _value = value
      _next = next
    }

    /**
     * @inheritDoc
     */
    [Deprecated(replacement="size", since="0.1")]
    public function get length(): int {
      return _lengthKnown ? _length : size
    }

    /**
     * @inheritDoc
     */
    public function get size(): int {
      if(_lengthKnown) {
        return _length
      }

      var p: IList = this
      var length: int = 0;

      while(p.notEmpty) {
        ++length;
        p = p.tail
      }

      _length = length
      _lengthKnown = true

      return length
    }

    /**
     * @inheritDoc
     */
    public function get hasDefinedSize(): Boolean {
      return true
    }

    /**
     * @inheritDoc
     */
    override public function equals(that:IFunkObject): Boolean {
      if (that is IList) {
        return super.equals(that)
      }

      return false
    }

    /**
     * @inheritDoc
     */
    override public function get productArity(): int {
      return size
    }

    /**
     * @inheritDoc
     */
    override public function productElement(i: int): * {
      validateIndex(i)

      var p: IList = this

      while(p.notEmpty) {
        if(i == 0) {
          return p.head
        }

        p = p.tail
        i -= 1
      }

      throw new NoSuchElementError()
    }

    /**
     * @inheritDoc
     */
    override public function get productPrefix(): String {
      return "List"
    }

    /**
     * @inheritDoc
     */
    public function prepend(value: *): IList {
      return new List(value, this)
    }

    /**
     * @inheritDoc
     */
    public function prependAll(value: IList): IList {
      const n: int = value.size

      if(0 == n) {
        return this
      }

      const buffer: Vector.<List> = new Vector.<List>(n, true)
      const m: int = n - 1
      var p: IList = value
      var i: int, j: int

      i = 0

      while(p.notEmpty) {
        buffer[i++] = new List(p.head, null)
        p = p.tail
      }

      buffer[m]._next = this

      for(i = 0, j = 1; i < m; ++i, ++j) {
        buffer[i]._next = buffer[j]
      }

      return buffer[0]
    }

    /**
     * @inheritDoc
     */
    public function get(i: int): * {
      return productElement(i)
    }

    /**
     * @inheritDoc
     */
    public function contains(value: *): Boolean {
      var p: IList = this

      while(p.notEmpty) {
        if(eq(p.head, value)) {
          return true
        }
        p = p.tail
      }

      return false
    }

    /**
     * @inheritDoc
     */
    public function count(f: Function): int {
      var n: int = 0
      var p: IList = this

      while(p.notEmpty) {
        if(f(p.head)) {
          ++n
        }

        p = p.tail
      }

      return n
    }

    /**
     * @inheritDoc
     */
    public function get notEmpty(): Boolean {
      return true
    }

    /**
     * @inheritDoc
     */
    public function drop(n: int): IList {
      require(n >= 0, "n must be positive.")

      var p: IList = this

      for(var i: int = 0; i < n; ++i) {
        if(p.isEmpty) {
          return nil
        }

        p = p.tail
      }

      return p
    }

    /**
     * @inheritDoc
     */
    public function dropRight(n: int): IList {
      require(n >= 0, "n must be positive.")

      if(0 == n) {
        return this
      }
      
      n = size - n

      if(n <= 0) {
        return nil
      }

      const buffer: Vector.<List> = new Vector.<List>(n, true)
      const m: int = n - 1
      var p: IList = this
      var i: int, j: int

      for(i = 0; i < n; ++i) {
        buffer[i] = new List(p.head, null)
        p = p.tail
      }

      buffer[m]._next = nil

      for(i = 0, j = 1; i < m; ++i, ++j) {
        buffer[i]._next = buffer[j]
      }

      return buffer[0]
    }

    /**
     * @inheritDoc
     */
    public function dropWhile(f: Function): IList {
      var p: IList = this

      while(p.notEmpty) {
        if(!f(p.head)) {
          return p
        }

        p = p.tail
      }

      return nil
    }

    /**
     * @inheritDoc
     */
    public function exists(f: Function): Boolean {
      var p: IList = this

      while(p.notEmpty) {
        if(f(p.head)) {
          return true
        }

        p = p.tail
      }

      return false
    }

    /**
     * @inheritDoc
     */
    public function filter(f: Function): IList {
      var p: IList = this
      var q: List = null
      var first: List = null
      var last: List = null
      var allFiltered: Boolean = true;

      while(p.notEmpty) {
        if(f(p.head)) {
          q = new List(p.head, nil)

          if(null != last) {
            last._next = q
          }

          if(null == first) {
            first = q
          }

          last = q
        } else {
          allFiltered = false
        }

        p = p.tail
      }

      if(allFiltered) {
        return this
      }

      return (first == null) ? nil : first
    }

    /**
     * @inheritDoc
     */
    public function filterNot(f: Function): IList {
      var p: IList = this
      var q: List = null
      var first: List = null
      var last: List = null
      var allFiltered: Boolean = true;

      while(p.notEmpty) {
        if(!f(p.head)) {
          q = new List(p.head, nil)

          if(null != last) {
            last._next = q
          }

          if(null == first) {
            first = q
          }

          last = q
        } else {
          allFiltered = false
        }

        p = p.tail
      }

      if(allFiltered) {
        return this
      }

      return (first == null) ? nil : first
    }

    /**
     * @inheritDoc
     */
    public function find(f: Function): IOption {
      var p: IList = this

      while(p.notEmpty) {
        if(f(p.head)) {
          return some(p.head)
        }

        p = p.tail
      }

      return none
    }

    /**
     * @inheritDoc
     */
    public function flatMap(f: Function): IList {
      var n: int = size
      const buffer: Vector.<IList> = new Vector.<IList>(n, true)
      var p: IList = this
      var i: int

      while(p.notEmpty) {
        buffer[i++] = IList(verifiedType(f(p.head), IList))
        p = p.tail
      }

      var list: IList = buffer[--n]

      while(--n > -1) {
        list = list.prependAll(buffer[n])
      }

      return list
    }

    /**
     * @inheritDoc
     */
    public function foldLeft(x: *, f: Function): * {
      var value: * = x
      var p: IList = this

      while(p.notEmpty) {
        value = f(value, p.head)
        p = p.tail
      }

      return value
    }

    /**
     * @inheritDoc
     */
    public function foldRight(x: *, f: Function): * {
      var value: * = x
      var buffer: Array = toArray
      var n: int = buffer.length

      while(--n > -1) {
        value = f(value, buffer[n])
      }

      return value
    }

    /**
     * @inheritDoc
     */
    public function forall(f: Function): Boolean {
      var p: IList = this

      while(p.notEmpty) {
        if(!f(p.head)) {
          return false
        }

        p = p.tail
      }

      return true
    }

    /**
     * @inheritDoc
     */
    public function foreach(f: Function): void {
      var p: IList = this

      while(p.notEmpty) {
        f(p.head)
        p = p.tail
      }
    }

    /**
     * @inheritDoc
     */
    public function get head(): * {
      return _value
    }

    /**
     * @inheritDoc
     */
    public function get headOption(): IOption {
      return some(_value)
    }

    /**
     * @inheritDoc
     */
    public function get indices(): IList {
      var n: int = size
      var p: IList = nil

      while(--n > -1) {
        p = p.prepend(n)
      }

      return p
    }

    /**
     * @inheritDoc
     */
    public function get init(): IList {
      return dropRight(1)
    }

    /**
     * @inheritDoc
     */
    public function get isEmpty(): Boolean {
      return false
    }

    /**
     * @inheritDoc
     */
    public function get last(): * {
      var p: IList = this
      var value: * = null
      while(p.notEmpty) {
        value = p.head
        p = p.tail
      }

      return value
    }

    /**
     * @inheritDoc
     */
    public function map(f: Function): IList {
      const n: int = size
      const buffer: Vector.<List> = new Vector.<List>(n, true)
      const m: int = n - 1

      var p: IList = this
      var i: int, j: int

      for(i = 0; i < n; ++i) {
        buffer[i] = new List(f(p.head), null)
        p = p.tail
      }

      buffer[m]._next = nil

      for(i = 0, j = 1; i < m; ++i, ++j) {
        buffer[i]._next = buffer[j]
      }

      return buffer[0]
    }

    /**
     * @inheritDoc
     */
    public function partition(f: Function): ITuple2 {
      const left: Vector.<List> = new Vector.<List>()
      const right: Vector.<List> = new Vector.<List>()

      var i: int = 0
      var j: int = 0
      var m: int
      var o: int

      var p: IList = this

      while(p.notEmpty) {
        if(f(p.head)) {
          left[i++] = new List(p.head, nil)
        } else {
          right[j++] = new List(p.head, nil)
        }

        p = p.tail
      }

      m = i - 1
      o = j - 1

      if(m > 0) {
        for(i = 0, j = 1; i < m; ++i, ++j) {
          left[i]._next = left[j]
        }
      }

      if(o > 0) {
        for(i = 0, j = 1; i < o; ++i, ++j) {
          right[i]._next = right[j]
        }
      }

      return tuple2(m > 0 ? left[0] : nil, o > 0 ? right[0] : nil)
    }

    /**
     * @inheritDoc
     */
    public function reduceLeft(f: Function): * {
      var value: * = head
      var p: IList = this._next

      while(p.notEmpty) {
        value = f(value, p.head)
        p = p.tail
      }

      return value
    }

    /**
     * @inheritDoc
     */
    public function reduceRight(f: Function): * {
      var buffer: Array = toArray
      var value: * = buffer.pop()
      var n: int = buffer.length

      while(--n > -1) {
        value = f(value, buffer[n])
      }

      return value
    }

    /**
     * @inheritDoc
     */
    public function get reverse(): IList {
      var result: IList = nil
      var p: IList = this

      while(p.notEmpty) {
        result = result.prepend(p.head)
        p = p.tail
      }

      return result
    }

    /**
     * @inheritDoc
     */
    public function get tail(): IList {
      return _next
    }

    /**
     * @inheritDoc
     */
    public function get tailOption(): IOption {
      return some(_next)
    }

    /**
     * @inheritDoc
     */
    public function take(n: int): IList {
      require(n >= 0, "n must be positive.")

      if(n > size) {
        return this
      } else if(0 == n) {
        return nil
      }

      const buffer: Vector.<List> = new Vector.<List>(n, true)
      const m: int = n - 1
      var p: IList = this
      var i: int, j: int

      for(i = 0; i < n; ++i) {
        buffer[i] = new List(p.head, null)
        p = p.tail
      }

      buffer[m]._next = nil

      for(i = 0, j = 1; i < m; ++i, ++j) {
        buffer[i]._next = buffer[j]
      }

      return buffer[0]
    }

    /**
     * @inheritDoc
     */
    public function takeRight(n: int): IList  {
      require(n >= 0, "n must be positive.")

      if(n > size) {
        return this
      } else if(0 == n) {
        return nil
      }

      n = size - n

      if(n <= 0) {
        return this
      }

      var p: IList = this

      for(var i: int = 0; i < n; ++i) {
        p = p.tail
      }

      return p
    }

    /**
     * @inheritDoc
     */
    public function takeWhile(f: Function): IList {
      const buffer: Vector.<List> = new Vector.<List>()
      var p: IList = this
      var i: int, j: int
      var n: int = 0

      while(p.notEmpty) {
        if(f(p)) {
          buffer[n++] = new List(p.head, null)
          p = p.tail
        } else {
          break
        }
      }

      var m: int = n - 1

      buffer[m]._next = nil

      for(i = 0, j = 1; i < m; ++i, ++j) {
        buffer[i]._next = buffer[j]
      }

      return buffer[0]
    }

    /**
     * @inheritDoc
     */
    public function get toArray(): Array {
      const n: int = size
      const array: Array = new Array(n)
      var p: IList = this
      var i: int

      for(i = 0; i < n; ++i) {
        array[i] = p.head
        p = p.tail
      }

      return array
    }

    /**
     * @inheritDoc
     */
    public function get toVector(): Vector.<*> { return createVector(false) }

    /**
     * @inheritDoc
     */
    public function get toFixedVector(): Vector.<*> { return createVector(true) }

    /**
     * @inheritDoc
     */
    public function zip(that: IList): IList {
      const n: int = Math.min(size, that.size)
      const m: int = n - 1
      const buffer: Vector.<List> = new Vector.<List>(n, true)
      var i: int, j: int

      var p: IList = this, q: IList = that

      for(i = 0; i < n; ++i) {
        buffer[i] = new List(tuple2(p.head, q.head), null)
        p = p.tail
        q = q.tail
      }

      buffer[m]._next = nil

      for(i = 0, j = 1; i < m; ++i, ++j) {
        buffer[i]._next = buffer[j]
      }

      return buffer[0]
    }

    /**
     * @inheritDoc
     */
    public function get zipWithIndex(): IList {
      const n: int = size
      const m: int = n - 1
      const buffer: Vector.<List> = new Vector.<List>(n, true)
      var i: int, j: int

      var p: IList = this

      for(i = 0; i < n; ++i) {
        buffer[i] = new List(tuple2(p.head, i), null)
        p = p.tail
      }

      buffer[m]._next = nil

      for(i = 0, j = 1; i < m; ++i, ++j) {
        buffer[i]._next = buffer[j]
      }

      return buffer[0]
    }

    /**
     * Creates and returns a new Vector.<*> containing all elements
     * of the list while preserving order.
     *
     * @param fixed Whether or not the vector is fixed.
     * @return A Vector.<*> containing all elements of the list.
     */
    private function createVector(fixed: Boolean): Vector.<*> {
      const n: int = size
      const vector: Vector.<*> = new Vector.<*>(n, fixed)
      var p: IList = this
      var i: int

      for(i = 0; i < n; ++i) {
        vector[i] = p.head
        p = p.tail
      }

      return vector
    }

    /**
     * @inheritDoc
     */
    public function findIndexOf(f:Function):int {
      var index: int = 0
      var p: IList = this

      while(p.notEmpty) {
        if(f(p.head)) {
          return index
        }

        p = p.tail
        index += 1
      }

      return -1
    }

    /**
     * @inheritDoc
     */
    public function get flatten(): IList {
      return flatMap(function(x: *): IList { return x is IList ? x : list(x) })
    }

    /**
     * @inheritDoc
     */
    public function indexOf(value:*):int {
      var index: int = 0
      var p: IList = this

      while(p.notEmpty) {
        if(eq(p.head, value)) {
          return index
        }

        p = p.tail
        index += 1
      }

      return -1
    }

    /**
     * @inheritDoc
     */
    override public function mkString(separator: String): String {
      const n: int = size
      const m: int = n - 1

      var buffer: String = ""
      var p: IList = this
      var i: int

      for(i = 0; i < n; ++i) {
        buffer += p.head

        if(i != m) {
          buffer += separator
        }

        p = p.tail
      }

      return buffer
    }
  }
}